import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:ethereum_api/emp_api.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'prediction_page_event.dart';
part 'prediction_page_state.dart';

class PredictionPageBloc
    extends Bloc<PredictionPageEvent, PredictionPageState> {
  PredictionPageBloc({
    required WalletRepository walletRepository,
    required TokensRepository tokensRepository,
    required EventMarketRepository eventMarketRepository,
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
  })  : _walletRepository = walletRepository,
        _tokensRepository = tokensRepository,
        _eventMarketRepository = eventMarketRepository,
        _streamAppDataChangesUseCase = streamAppDataChangesUseCase,
        super(const PredictionPageState()) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<PredictionPageLoaded>(_onPredictionPageLoaded);
  }

  final WalletRepository _walletRepository;
  final TokensRepository _tokensRepository;
  final EventMarketRepository _eventMarketRepository;
  final StreamAppDataChangesUseCase _streamAppDataChangesUseCase;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<PredictionPageState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChangesUseCase.appDataChanges,
      onData: (appData) {
        emit(
          state.copyWith(
            status: BlocStatus.loading,
            predictionAddress: kNullAddress,
          ),
        );
      },
    );
  }

  Future<void> _onMintPredictionTokens(
    MintPredictionTokens event,
    Emitter<PredictionPageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.success));
    await _eventMarketRepository.create();
  }

  Future<void> _onRedeemPredictionTokens(
    RedeemPredictionTokens event,
    Emitter<PredictionPageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.success));
    await _eventMarketRepository.redeem();
  }

  Future<void> _onPredictionPageLoaded(
    PredictionPageLoaded event,
    Emitter<PredictionPageState> emit,
  ) async {
    _eventMarketRepository.eventMarketAddress = event.predictionAddress;
  }
}
