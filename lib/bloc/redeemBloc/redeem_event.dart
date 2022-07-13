part of 'redeem_bloc.dart';

abstract class RedeemEvent extends Equatable {
  const RedeemEvent();

  @override
  List<Object> get props => [];
}

class RedeemErrorEvent extends RedeemEvent {}

class RedeemSuccessEvent extends RedeemEvent {}
