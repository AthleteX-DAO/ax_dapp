import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:equatable/equatable.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'predict_page_event.dart';
part 'predict_page_state.dart';

class PredictPageBloc extends Bloc<PredictPageEvent, PredictPageState> {
  PredictPageBloc({
    required WalletRepository walletRepository,
  }) : _walletRepository = walletRepository {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
  }

  final WalletRepository _walletRepository;

  Future<void> _onWatchAppDataChangesStarted(
      WatchAppDataChangesStarted _, Emitter<PredictPageState> emit) async {}
}
