import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

part 'yes_button_event.dart';
part 'yes_button_state.dart';

class YesButtonBloc extends Bloc<YesButtonEvent, YesButtonState> {
  YesButtonBloc({
    required this.eventMarketRepository,
  }) : super(const YesButtonState()) {
    on<YesButtonPressed>(_onYesButtonPressed);
  }

  final EventMarketRepository eventMarketRepository;

  Future<void> _onYesButtonPressed(
    YesButtonPressed event,
    Emitter<YesButtonState> emit,
  ) async {
    try {
      print('Yes Button IS PRESSED');
      await eventMarketRepository.buy();
    } catch (e) {
      // await _eventMarketRepository.Yes();
    }
  }
}
