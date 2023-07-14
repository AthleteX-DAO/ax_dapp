import 'dart:async';

import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'redeem_button_event.dart';
part 'redeem_button_state.dart';

class RedeemButtonBloc extends Bloc<RedeemButtonEvent, RedeemButtonState> {
  RedeemButtonBloc({
    required this.eventMarketRepository,
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
    required WalletRepository walletRepository,
  })  : _streamAppDataChangesUseCase = streamAppDataChangesUseCase,
        _walletRepository = walletRepository,
        super(const RedeemButtonState()) {
    on<RedeemButtonPressed>(_onRedeemButtonPressed);
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    add(const WatchAppDataChangesStarted());
  }

  final EventMarketRepository eventMarketRepository;
  final StreamAppDataChangesUseCase _streamAppDataChangesUseCase;
  final WalletRepository _walletRepository;

  Future<void> _onRedeemButtonPressed(
    RedeemButtonPressed event,
    Emitter<RedeemButtonState> emit,
  ) async {
    try {
      eventMarketRepository.eventMarketAddress = event.eventMarketAddress;
      await eventMarketRepository.redeem();
      emit(state.copyWith(status: BlocStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<RedeemButtonState> emit,
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
