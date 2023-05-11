import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';

part 'redeem_button_event.dart';
part 'redeem_button_state.dart';

class RedeemButtonBloc extends Bloc<RedeemButtonEvent, RedeemButtonState> {
  RedeemButtonBloc({
    required this.eventMarketRepository,
  }) : super(const RedeemButtonState()) {
    on<RedeemButtonPressed>(_onRedeemButtonPressed);
  }
  final EventMarketRepository eventMarketRepository;

  Future<void> _onRedeemButtonPressed(
    RedeemButtonPressed event,
    Emitter<RedeemButtonState> emit,
  ) async {
    try {
      await eventMarketRepository.redeem();
    } catch (e) {}
  }
}
