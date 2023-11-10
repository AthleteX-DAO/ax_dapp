import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'mint_button_event.dart';
part 'mint_button_state.dart';

class MintButtonBloc extends Bloc<MintButtonEvent, MintButtonState> {
  MintButtonBloc({
    required this.eventMarketRepository,
    required WalletRepository walletRepository,
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
  })  : _streamAppDataChangesUseCase = streamAppDataChangesUseCase,
        _walletRepository = walletRepository,
        super(const MintButtonState()) {
    on<MintButtonPressed>(_onMintButtonPressed);
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    add(const WatchAppDataChangesStarted());
  }

  final EventMarketRepository eventMarketRepository;
  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChangesUseCase;

  Future<void> _onMintButtonPressed(
    MintButtonPressed event,
    Emitter<MintButtonState> emit,
  ) async {
    try {
      eventMarketRepository.eventMarketAddress = event.eventMarketAddress;
      await eventMarketRepository.approve(event.eventMarketAddress, 1);
      await eventMarketRepository.mint();
      emit(state.copyWith(status: BlocStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<MintButtonState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChangesUseCase.appDataChanges,
      onData: (appData) {
        final appConfig = appData.appConfig;
        eventMarketRepository.controller.client.value =
            appConfig.reactiveWeb3Client.value;
        eventMarketRepository.controller.credentials =
            _walletRepository.credentials.value;
        eventMarketRepository
          ..eventBasedPredictionMarket =
              appConfig.reactiveEventMarketsClient.value
          ..aptFactory = appConfig.reactiveAptFactoryClient.value
          ..aptRouter = appConfig.reactiveAptRouterClient.value;
      },
    );
  }
}
