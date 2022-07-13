import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'redeem_event.dart';
part 'redeem_state.dart';

class RedeemBloc extends Bloc<RedeemEvent, RedeemState> {
  RedeemBloc() : super(RedeemState.initial()) {
    on<RedeemSuccessEvent>(_mapSuccessEventToState);
    on<RedeemErrorEvent>(_mapErrorEventToState);
  }

  Future<void> _mapSuccessEventToState(
      RedeemSuccessEvent event, Emitter<RedeemState> emit) async {
    emit(state.copyWith(sucessful: true));
    print('i was triggered success');
    print(state.sucessful);
  }

  Future<void> _mapErrorEventToState(
      RedeemErrorEvent event, Emitter<RedeemState> emit) async {
    emit(state.copyWith(sucessful: false));
    print('i was triggered error');
  }
}
