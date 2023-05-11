part of 'redeem_button_bloc.dart';

abstract class RedeemButtonEvent extends Equatable {
  const RedeemButtonEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends RedeemButtonEvent {
  const WatchAppDataChangesStarted();
}

class RedeemButtonPressed extends RedeemButtonEvent {
  const RedeemButtonPressed();
}
