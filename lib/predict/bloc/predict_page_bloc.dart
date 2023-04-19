import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:equatable/equatable.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'predict_page_event.dart';
part 'predict_page_state.dart';

class PredictPageBloc extends Bloc<PredictPageEvent, PredictPageState> {
  PredictPageBloc({
    required WalletRepository walletRepository,
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
  }) : _walletRepository = walletRepository,
      _streamAppDataChanges = streamAppDataChangesUseCase
   {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    add( const WatchAppDataChangesStarted());
  }

  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;


  Future<void> _onWatchAppDataChangesStarted(
      WatchAppDataChangesStarted _, Emitter<PredictPageState> emit) async {
        await emit.onEach<AppData>(_streamAppDataChanges.appDataChanges, onData: )
      }
}
