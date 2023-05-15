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
      eventMarketRepository.address1.value = event.longTokenAddress;

      eventMarketRepository.address2.value =
          '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909';
      await eventMarketRepository.buy();
    } catch (e) {
      // await _eventMarketRepository.Yes();
    }
  }
}
