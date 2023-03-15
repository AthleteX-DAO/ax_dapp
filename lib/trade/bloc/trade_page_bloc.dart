import 'dart:async';

import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair_info.dart';
import 'package:ax_dapp/service/controller/swap/swap_repository.dart';
import 'package:ax_dapp/trade/models/models.dart';
import 'package:ax_dapp/util/bloc_status.dart';
// ignore: implementation_imports
import 'package:ethereum_api/src/tokens/models/contract.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'trade_page_event.dart';
part 'trade_page_state.dart';

class TradePageBloc extends Bloc<TradePageEvent, TradePageState> {
  TradePageBloc({
    required WalletRepository walletRepository,
    required StreamAppDataChangesUseCase streamAppDataChanges,
    required this.repo,
    required this.swapRepository,
    required this.isBuyAX,
  })  : _walletRepository = walletRepository,
        _streamAppDataChanges = streamAppDataChanges,
        super(
          TradePageState.initial(
            isBuyAX: isBuyAX,
            chain: walletRepository.currentChain,
          ),
        ) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<FetchTradeInfoRequested>(_onFetchTradeInfoRequested);
    on<MaxSwapTapEvent>(_mapMaxSwapTapEventToState);
    on<NewTokenFromInputEvent>(_mapNewTokenFromInputEventToState);
    on<NewTokenToInputEvent>(_mapNewTokenToInputEventToState);
    on<SetTokenFrom>(_mapSetTokenFromEventToState);
    on<SetTokenTo>(_mapSetTokenToEventToState);
    on<SwapTokens>(_mapSwapTokensEventToState);

    add(WatchAppDataChangesStarted());
    add(FetchTradeInfoRequested());
  }

  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final GetSwapInfoUseCase repo;
  final SwapRepository swapRepository;
  final bool isBuyAX;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<TradePageState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        final appConfig = appData.appConfig;
        swapRepository
          ..aptFactory = appConfig.reactiveAptFactoryClient.value
          ..aptRouter = appConfig.reactiveAptRouterClient.value;
        swapRepository.controller.credentials =
            _walletRepository.credentials.value;
        swapRepository.factoryAddress.value =
            Contract.exchangeFactory(appData.chain).address;
        swapRepository.routerAddress.value =
            Contract.exchangeRouter(appData.chain).address;
        final tradeTokens = appData.chain.computeTradeTokens(
          isBuyAX: isBuyAX,
        );
        emit(
          state.copyWith(
            tokenFrom: tradeTokens.tokenFrom,
            tokenTo: tradeTokens.tokenTo,
          ),
        );
        add(FetchTradeInfoRequested());
      },
    );
  }

  FutureOr<void> _onFetchTradeInfoRequested(
    FetchTradeInfoRequested event,
    Emitter<TradePageState> emit,
  ) async {
    if (_walletRepository.currentWallet.isDisconnected) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          failure: DisconnectedWalletFailure(),
          tokenFromBalance: 0,
          tokenToBalance: 0,
          swapInfo: TokenSwapInfo.empty,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        swapInfo: TokenSwapInfo.empty,
        failure: Failure.none,
      ),
    );
    try {
      final tokenFromBalance =
          await _walletRepository.getTokenBalance(state.tokenFrom.address);
      final tokenToBalance =
          await _walletRepository.getTokenBalance(state.tokenTo.address);
      final tokenFromDecimal = await _walletRepository.getDecimals(state.tokenFrom.address);
      final tokenToDecimal = await _walletRepository.getDecimals(state.tokenTo.address);
      swapRepository
        ..topDecimals = (tokenFromDecimal.toInt())
        ..bottomDecimals = (tokenToDecimal.toInt());
      emit(
        state.copyWith(
          tokenFromBalance: tokenFromBalance ?? 0,
          tokenToBalance: tokenToBalance ?? 0,
          swapInfo: TokenSwapInfo.empty,
          failure: Failure.none,
        ),
      );
      final response = await repo.fetchSwapInfo(
        tokenFrom: state.tokenFrom.address,
        tokenTo: state.tokenTo.address,
      );
      final isSuccess = response.isLeft();
      if (isSuccess) {
        swapRepository
          ..fromAddress = (state.tokenFrom.address)
          ..toAddress = (state.tokenTo.address);
        final swapInfo = response.getLeft().toNullable()!.swapInfo;

        //do some math
        emit(
          state.copyWith(
            status: BlocStatus.success,
            swapInfo: swapInfo,
            failure: Failure.none,
          ),
        );
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(
          state.copyWith(
            status: BlocStatus.error,
            failure: UnknownTradeFailure(),
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          failure: UnknownTradeFailure(),
        ),
      );
    }
  }

  Future<void> _mapNewTokenFromInputEventToState(
    NewTokenFromInputEvent event,
    Emitter<TradePageState> emit,
  ) async {
    final tokenInputFromAmount = event.tokenInputFromAmount;
    final tokenFromBalance =
        await _walletRepository.getTokenBalance(state.tokenFrom.address);
    try {
      emit(
        state.copyWith(swapInfo: TokenSwapInfo.empty),
      );

      final response = await repo.fetchSwapInfo(
        tokenFrom: state.tokenFrom.address,
        tokenTo: state.tokenTo.address,
        fromInput: tokenInputFromAmount,
      );
      final isSuccess = response.isLeft();

      if (isSuccess) {
        if (tokenInputFromAmount > tokenFromBalance!) {
          emit(
            state.copyWith(
              status: BlocStatus.error,
              failure: InSufficientFailure(),
            ),
          );
        } else {
          if (swapRepository.amount1.value != tokenInputFromAmount) {
            swapRepository.fromAmount = tokenInputFromAmount;
          }
          final swapInfo = response.getLeft().toNullable()!.swapInfo;
          //do some math
          emit(state.copyWith(status: BlocStatus.success, swapInfo: swapInfo));
        }
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        final errorMsg = response.getRight().toNullable()?.errorMsg;
        if (errorMsg == noSwapInfoErrorMessage) {
          emit(
            state.copyWith(
              status: BlocStatus.error,
              failure: NoSwapInfoFailure(),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: BlocStatus.error,
              failure: UnknownTradeFailure(),
            ),
          );
        }
      }
    } catch (_) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          failure: UnknownTradeFailure(),
        ),
      );
    }
  }

  Future<void> _mapNewTokenToInputEventToState(
    NewTokenToInputEvent event,
    Emitter<TradePageState> emit,
  ) async {}

  Future<void> _mapMaxSwapTapEventToState(
    MaxSwapTapEvent event,
    Emitter<TradePageState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BlocStatus.loading,
        failure: Failure.none,
      ),
    );
    try {
      final tokenFromBalance =
          await _walletRepository.getTokenBalance(state.tokenFrom.address);
      final maxInput = tokenFromBalance ?? 0;
      emit(
        state.copyWith(
          tokenInputFromAmount: maxInput,
          tokenFromBalance: maxInput,
          failure: Failure.none,
        ),
      );
    } catch (_) {
      // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
      emit(
        state.copyWith(
          status: BlocStatus.error,
          failure: UnknownTradeFailure(),
        ),
      );
    }
  }

  void _mapSetTokenFromEventToState(
    SetTokenFrom event,
    Emitter<TradePageState> emit,
  ) {
    swapRepository.fromAddress = event.tokenFrom.address;
    emit(
      state.copyWith(
        tokenFrom: event.tokenFrom,
        failure: Failure.none,
      ),
    );
  }

  void _mapSetTokenToEventToState(
    SetTokenTo event,
    Emitter<TradePageState> emit,
  ) {
    swapRepository.toAddress = event.tokenTo.address;
    emit(
      state.copyWith(
        tokenTo: event.tokenTo,
        failure: Failure.none,
      ),
    );
  }

  void _mapSwapTokensEventToState(
    SwapTokens event,
    Emitter<TradePageState> emit,
  ) {
    final tokenFromBalance = double.parse(event.tokenFromBalance);
    final tokenToBalance = double.parse(event.tokenToBalance);
    final tokenFrom = state.tokenTo;
    final tokenTo = state.tokenFrom;
    final tokenInputFromAmount = state.tokenInputToAmount;
    final tokenInputToAmount = state.tokenInputFromAmount;
    emit(
      state.copyWith(
        tokenFrom: tokenFrom,
        tokenTo: tokenTo,
        tokenInputFromAmount: tokenInputFromAmount,
        tokenInputToAmount: tokenInputToAmount,
        tokenFromBalance: tokenToBalance,
        tokenToBalance: tokenFromBalance,
        failure: Failure.none,
      ),
    );
  }
}
