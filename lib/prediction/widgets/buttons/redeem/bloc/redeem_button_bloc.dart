import 'package:ax_dapp/util/bloc_status.dart';
import 'package:shared/shared.dart';

part 'redeem_button_event.dart';
part 'redeem_button_state.dart';

class RedeemButtonBloc extends Bloc<RedeemButtonEvent, RedeemButtonState> {
  RedeemButtonBloc() : super(const RedeemButtonState()) {
    on<RedeemButtonPressed>(_onRedeemButtonPressed);
  }

  Future<void> _onRedeemButtonPressed(
    RedeemButtonPressed event,
    Emitter<RedeemButtonState> emit,
  ) async {
    try {
      print('Redeem Button IS PRESSED');
    } catch (e) {}
  }
}
