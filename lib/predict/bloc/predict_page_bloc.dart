import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'predict_page_event.dart';
part 'predict_page_state.dart';

class PredictPageBloc extends Bloc<PredictPageEvent, PredictPageState> {
  PredictPageBloc({
    required WalletRepository walletRepository,
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
  })  : _walletRepository = walletRepository,
        _streamAppDataChanges = streamAppDataChangesUseCase,
        super(const PredictPageState()) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<LoadPredictionsEvent>(_onLoadPredictions);
    add(const WatchAppDataChangesStarted());
    add(const LoadPredictionsEvent());
  }

  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final List<PredictionModel> questions = [
    const PredictionModel(
      prompt: 'Houston Astros vs Tampa Bay Rays',
      details:
          'This market will resolve to “Red Sox” if Boston Red Sox win the game against Baltimore Orioles on April 26, 2023. If the Baltimore Orioles win the game the market will resolve to “Orioles”. The resolution source for this market will be MLB or a consensus of credible reporting will also suffice. If the fight is canceled, postponed, or ends in a draw, Yes and No will resolve to 50/50.',
      address: '',
    ),
    const PredictionModel(
      prompt: 'Washington Nationals vs New York Mets',
      details:
          'This market will resolve to “Knicks” if the New York Knicks win the game against the Cleveland Cavaliers on April 26, 2023. If the Cleveland Cavaliers win the game the market will resolve to “Cavaliers”. The resolution source for this market will be NBA or a consensus of credible reporting will also suffice. If the fight is canceled, postponed, or ends in a draw, Yes and No will resolve to 50/50.',
      address: '',
    ),
    const PredictionModel(
      prompt: 'New York Knicks vs Cleveland Cavaliers',
      details:
          'This market will resolve to “Yes” if the Gervonta Davis is knocked down at least once. Otherwise, this market will resolve to “No”. A “No” resolution would mean Garcia does not knockdown Davis during the fight. The resolution source for this market will be WBA or a consensus of credible reporting will also suffice. If the fight is canceled or postponed, Yes and No will resolve to 50/50.',
      address: '',
    ),
    const PredictionModel(
      prompt: 'Los Angeles Lakers vs Memphis Grizzlies',
      details:
          'This market will resolve to “Davis” if Gervonta Davis is knocked down more than Garcia. This market will resolve to “Garcia” if Ryan Garcia is knocked down more than Davis. The resolution source for this market will be WBA or a consensus of credible reporting will also suffice. If Davis and Garcia are knocked down equally, Yes and No will resolve to 50/50. If the fight is canceled or postponed, Yes and No will resolve to 50/50.',
      address: '',
    ),
    const PredictionModel(
      prompt: 'Miami Heat vs Milwaukee Bucks',
      details:
          'This market will resolve to “Yes” if the winner of the fight cries during the in-ring post-fight interview. If the winner of the fight does not shed a tear in the ring during the post-fight interview, this market will resolve to “No”. Post-fight press conferences outside the ring do not apply to this market. The resolution source for this market will be post-fight interview video or a consensus of credible reporting will also suffice. If the fight is canceled or postponed, Yes and No will resolve to 50/50.',
      address: '',
    ),
    const PredictionModel(
      prompt: 'Golden State Warriors vs Sacramento Kings',
      details: '',
      address: '',
    ),
  ];

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<PredictPageState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        emit(
          state.copyWith(
            status: BlocStatus.loading,
          ),
        );
      },
    );
  }

  Future<void> _onLoadPredictions(
    LoadPredictionsEvent _,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(predictions: questions, status: BlocStatus.initial),
    );
  }

  Future<void> _onYesButtonTapped() async {
    emit(
      state.copyWith(),
    );
  }

  Future<void> _onNoButtonTapped() async {
    emit(
      state.copyWith(),
    );
  }
}
