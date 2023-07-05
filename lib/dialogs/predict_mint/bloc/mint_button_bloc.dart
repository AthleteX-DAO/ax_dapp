import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'mint_button_event.dart';
part 'mint_button_state.dart';

class MintButtonBloc extends Bloc<MintButtonEvent, MintButtonState> {
  MintButtonBloc({
    required this.eventMarketRepository,
    required WalletRepository walletRepository,
    required StreamAppDataChangesUseCase streamAppDataChanges,
  })  : _streamAppDataChanges = streamAppDataChanges,
        _walletRepository = walletRepository,
        super(const MintButtonState()) {
    on<MintButtonPressed>(_onMintButtonPressed);
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    add(const WatchAppDataChangesStarted());
  }

  final EventMarketRepository eventMarketRepository;
  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;

  Future<void> _onMintButtonPressed(
    MintButtonPressed event,
    Emitter<MintButtonState> emit,
  ) async {
    try {
      print('Mint button is PRESSED');
      eventMarketRepository.eventMarketAddress = event.eventMarketAddress;
      //First is approve, then mint
      await eventMarketRepository.approve(event.eventMarketAddress, 1);
      await eventMarketRepository.mint();
    } catch (e) {
      // await eventMarketRepository.mint();
    }
  }

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<MintButtonState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
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
