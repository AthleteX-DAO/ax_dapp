import 'package:ax_dapp/service/controller/perps/perps_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Events for the Perps page bloc.
abstract class PerpsPageEvent {
  const PerpsPageEvent();
}

class PerpsPageInitialize extends PerpsPageEvent {
  const PerpsPageInitialize();
}

class PerpsPageRefresh extends PerpsPageEvent {
  const PerpsPageRefresh();
}

/// States for the Perps page bloc.
abstract class PerpsPageState {
  const PerpsPageState();
}

class PerpsPageInitial extends PerpsPageState {
  const PerpsPageInitial();
}

class PerpsPageLoading extends PerpsPageState {
  const PerpsPageLoading();
}

class PerpsPageLoaded extends PerpsPageState {
  final BtcPerpsData btcPerpsData;

  const PerpsPageLoaded({required this.btcPerpsData});
}

class PerpsPageError extends PerpsPageState {
  final String message;

  const PerpsPageError({required this.message});
}

/// Bloc for managing Perps page state.
class PerpsPageBloc extends Bloc<PerpsPageEvent, PerpsPageState> {
  final PerpsRepository perpsRepository;

  PerpsPageBloc({required this.perpsRepository})
      : super(const PerpsPageInitial()) {
    on<PerpsPageInitialize>((event, emit) async {
      await _loadBtcPerpsData(emit);
    });

    on<PerpsPageRefresh>((event, emit) async {
      await _loadBtcPerpsData(emit);
    });
  }

  Future<void> _loadBtcPerpsData(Emitter<PerpsPageState> emit) async {
    try {
      emit(const PerpsPageLoading());
      final btcData = await perpsRepository.getBtcPerpsData();
      emit(PerpsPageLoaded(btcPerpsData: btcData));
    } catch (e) {
      emit(PerpsPageError(message: 'Failed to load BTC Perps data: $e'));
    }
  }
}
