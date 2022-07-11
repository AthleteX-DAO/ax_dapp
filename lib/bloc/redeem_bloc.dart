import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'redeem_event.dart';
part 'redeem_state.dart';

class RedeemBloc extends Bloc<RedeemEvent, RedeemState> {
  RedeemBloc() : super(RedeemInitial(sucessful: false));

  @override
  Stream<RedeemState> mapEventToState(
    RedeemEvent event,
  ) async* {
    if (event is RedeemErrorEvent) {
      yield RedeemStatus(sucessful: false);
    } else if (event is RedeemSuccessEvent) {
      yield RedeemStatus(sucessful: true);
    }
  }
}
