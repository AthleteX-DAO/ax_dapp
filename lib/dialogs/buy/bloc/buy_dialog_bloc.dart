// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/apt_buy_info.dart';
import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:ethereum_api/src/tokens/models/contract.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'buy_dialog_event.dart';
part 'buy_dialog_state.dart';

const String noTokenInfoMessage = 'There is no detailed data for this token.';
const String exceptionMessage =
    'There is an exception for the action of this token';

class BuyDialogBloc extends Bloc<BuyDialogEvent, BuyDialogState> {
  BuyDialogBloc({
    required TokensRepository tokensRepository,
    required WalletRepository walletRepository,
    required StreamAppDataChangesUseCase streamAppDataChanges,
    required this.repo,
    required this.wallet,
    required this.swapController,
    required int athleteId,
  })  : _streamAppDataChanges = streamAppDataChanges,
        _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        super(
          // setting the apt corresponding to the default aptType which is long
          BuyDialogState(
            longApt: tokensRepository.currentAptPair(athleteId).longApt,
          ),
        ) {
    on<WatchAptPairStarted>(_onWatchAptPairStarted);
    on<AptTypeSelectionChanged>(_onAptTypeSelectionChanged);
    on<FetchAptBuyInfoRequested>(_onFetchAptBuyInfoRequested);
    on<OnMaxBuyTap>(_mapMaxBuyTapEventToState);
    on<OnConfirmBuy>(_mapConfirmBuyEventToState);
    on<OnNewAxInput>(_mapNewAxInputEventToState);
    on<UpdateSwapController>(_mapUpdateSwapControllerEventToState);

    add(WatchAptPairStarted(athleteId));
    add(const FetchAptBuyInfoRequested());
  }

  final TokensRepository _tokensRepository;
  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final GetBuyInfoUseCase repo;
  final GetTotalTokenBalanceUseCase wallet;
  final SwapController swapController;

  Future<void> _onWatchAptPairStarted(
    WatchAptPairStarted event,
    Emitter<BuyDialogState> emit,
  ) async {
    await emit.onEach<AptPair>(
      _tokensRepository.aptPairChanges(event.athleteId),
      onData: (aptPair) {
        emit(
          state.copyWith(longApt: aptPair.longApt, shortApt: aptPair.shortApt),
        );
        add(const UpdateSwapController());
      },
    );
  }

  Future<void> _mapUpdateSwapControllerEventToState (
    UpdateSwapController event,
    Emitter<BuyDialogState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        final appConfig = appData.appConfig;
        swapController
          ..aptFactory = appConfig.reactiveAptFactoryClient.value
          ..aptRouter = appConfig.reactiveAptRouterClient.value;
        swapController.controller.credentials =
            _walletRepository.credentials.value;
        swapController.factoryAddress.value = Contract.exchangeFactory(appData.chain).address;
        swapController.routerAddress.value = Contract.exchangeRouter(appData.chain).address;
        add(const FetchAptBuyInfoRequested());
      },
    );
  }

  void _onAptTypeSelectionChanged(
    AptTypeSelectionChanged event,
    Emitter<BuyDialogState> emit,
  ) {
    emit(state.copyWith(aptTypeSelection: event.aptType));
    add(const FetchAptBuyInfoRequested());
  }

  Future<void> _onFetchAptBuyInfoRequested(
    FetchAptBuyInfoRequested _,
    Emitter<BuyDialogState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final selectedAptAddress = state.selectedAptAddress;
    try {
      final response =
          await repo.fetchAptBuyInfo(aptAddress: selectedAptAddress);
      final isSuccess = response.isLeft();
      final balance = await wallet.getTotalAxBalance();

      if (isSuccess) {
        swapController
          ..updateFromAddress(_tokensRepository.currentTokens.axt.address)
          ..updateToAddress(selectedAptAddress);
        final pairInfo = response.getLeft().toNullable()!.aptBuyInfo;

        emit(
          state.copyWith(
            balance: balance,
            status: BlocStatus.success,
            aptBuyInfo: AptBuyInfo(
              axPerAptPrice: pairInfo.fromPrice,
              minimumReceived: pairInfo.minimumReceived,
              priceImpact: pairInfo.priceImpact,
              receiveAmount: pairInfo.receiveAmount,
              totalFee: pairInfo.totalFee,
            ),
          ),
        );
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(
          state.copyWith(
            balance: balance,
            status: BlocStatus.noData,
            errorMessage: noTokenInfoMessage,
            aptBuyInfo: AptBuyInfo.empty,
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          errorMessage: exceptionMessage,
          aptBuyInfo: AptBuyInfo.empty,
        ),
      );
    }
  }

  Future<void> _mapMaxBuyTapEventToState(
    OnMaxBuyTap event,
    Emitter<BuyDialogState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final maxInput = await wallet.getTotalAxBalance();
      emit(state.copyWith(axInputAmount: maxInput, status: BlocStatus.success));
      add(OnNewAxInput(axInputAmount: maxInput));
    } catch (e) {
      // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
      emit(
        state.copyWith(
          status: BlocStatus.error,
          errorMessage: 'Insufficient balance',
        ),
      );
    }
  }

  void _mapConfirmBuyEventToState(
    OnConfirmBuy event,
    Emitter<BuyDialogState> emit,
  ) {}

  Future<void> _mapNewAxInputEventToState(
    OnNewAxInput event,
    Emitter<BuyDialogState> emit,
  ) async {
    final axInputAmount = event.axInputAmount;
    final balance = await wallet.getTotalAxBalance();
    try {
      final response = await repo.fetchAptBuyInfo(
        aptAddress: state.selectedAptAddress,
        axInput: axInputAmount,
      );
      final isSuccess = response.isLeft();

      if (isSuccess) {
        if (swapController.amount1.value != axInputAmount) {
          swapController.updateFromAmount(axInputAmount);
        }
        final pairInfo = response.getLeft().toNullable()!.aptBuyInfo;
        emit(
          state.copyWith(
            status: BlocStatus.success,
            balance: balance,
            aptBuyInfo: AptBuyInfo(
              axPerAptPrice: pairInfo.fromPrice,
              minimumReceived: pairInfo.minimumReceived,
              priceImpact: pairInfo.priceImpact,
              receiveAmount: pairInfo.receiveAmount,
              totalFee: pairInfo.totalFee,
            ),
          ),
        );
      } else {
        // TODO(anyone): Create User facing error messages https://athletex.atlassian.net/browse/AX-466
        emit(
          state.copyWith(
            status: BlocStatus.noData,
            errorMessage: noTokenInfoMessage,
            aptBuyInfo: AptBuyInfo.empty,
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          errorMessage: exceptionMessage,
          aptBuyInfo: AptBuyInfo.empty,
        ),
      );
    }
  }
}
