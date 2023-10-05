import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/apt_buy_info.dart';
import 'package:ax_dapp/service/blockchain_models/apt_sell_info.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'short_button_event.dart';
part 'short_button_state.dart';

class ShortButtonBloc extends Bloc<ShortButtonEvent, ShortButtonState> {
  ShortButtonBloc({
    required this.repo,
    required EventMarketRepository eventMarketRepository,
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
    required WalletRepository walletRepository,
  })  : _streamAppDataChanges = streamAppDataChangesUseCase,
        _eventMarketRepository = eventMarketRepository,
        _walletRepository = walletRepository,
        super(const ShortButtonState()) {
    on<ShortButtonPressed>(_onShortButtonPressed);
    on<FetchBuyInfoRequested>(_onFetchBuyInfoRequested);
    on<BuyButtonPressed>(_onBuyButtonPressed);
    on<SellButtonPressed>(_onSellButtonPressed);
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);

    add(const WatchAppDataChangesStarted());
  }

  final GetBuyInfoUseCase repo;
  final EventMarketRepository _eventMarketRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final WalletRepository _walletRepository;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted event,
    Emitter<ShortButtonState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        final appConfig = appData.appConfig;
        _eventMarketRepository.controller.client.value =
            appConfig.reactiveWeb3Client.value;
        _eventMarketRepository.controller.credentials =
            _walletRepository.credentials.value;
      },
    );
  }

  Future<void> _onShortButtonPressed(
    ShortButtonPressed event,
    Emitter<ShortButtonState> emit,
  ) async {
    try {
      _eventMarketRepository.address1.value = event.shortTokenAddress;
      _eventMarketRepository.address2.value =
          '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909';
      await _eventMarketRepository.sell();
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onFetchBuyInfoRequested(
    FetchBuyInfoRequested event,
    Emitter<ShortButtonState> emit,
  ) async {
    final aptAddress = event.shortTokenAddress;
    final response = await repo.fetchAptBuyInfo(aptAddress: aptAddress);
    final isSuccess = response.isLeft();
    if (isSuccess) {
      final pairInfo = response.getLeft().toNullable()!.aptBuyInfo;
      emit(
        state.copyWith(
          aptBuyInfo: AptBuyInfo(
            axPerAptPrice: pairInfo.toPrice,
            minimumReceived: pairInfo.minimumReceived,
            priceImpact: pairInfo.priceImpact,
            receiveAmount: pairInfo.receiveAmount,
            totalFee: pairInfo.totalFee,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          aptBuyInfo: AptBuyInfo.empty,
          status: BlocStatus.error,
        ),
      );
    }
  }

  Future<void> _onBuyButtonPressed(
    BuyButtonPressed event,
    Emitter<ShortButtonState> emit,
  ) async {
    try {
      _eventMarketRepository.address1.value =
          '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909';
      _eventMarketRepository.address2.value = event.shortTokenAddress;
      _eventMarketRepository.amount1.value = 1 * 1e18;
      const contractAddress = '0x4C2295082FC932EDE19EefB1af03c0b6B323610A';
      const amount = 100.0;
      await _eventMarketRepository
          .approve(contractAddress, amount)
          .then((value) => _eventMarketRepository.buy());
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onSellButtonPressed(
    SellButtonPressed event,
    Emitter<ShortButtonState> emit,
  ) async {
    try {
      _eventMarketRepository.address1.value = event.shortTokenAddress;
      _eventMarketRepository.address2.value =
          '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909';
      const contractAddress = '0x4C2295082FC932EDE19EefB1af03c0b6B323610A';
      const amount = 100.0;
      await _eventMarketRepository
          .approve(contractAddress, amount)
          .then((value) => _eventMarketRepository.sell());
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }
}
