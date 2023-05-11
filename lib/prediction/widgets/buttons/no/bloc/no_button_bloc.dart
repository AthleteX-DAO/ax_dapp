import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

part 'no_button_event.dart';
part 'no_button_state.dart';

class NoButtonBloc extends Bloc<NoButtonEvent, NoButtonState> {
  NoButtonBloc() : super(const NoButtonState()) {
    on<NoButtonPressed>(_onNoButtonPressed);
  }

  // final EventMarketRepository _eventMarketRepository;

  Future<void> _onNoButtonPressed(
    NoButtonPressed event,
    Emitter<NoButtonState> emit,
  ) async {
    try {
      print('No Button IS PRESSED');
    } catch (e) {
      // await _eventMarketRepository.No();
    }
  }
}
