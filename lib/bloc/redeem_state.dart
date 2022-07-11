part of 'redeem_bloc.dart';

class RedeemState extends Equatable {
  final bool sucessful;

  const RedeemState(
    this.sucessful,
  );

  @override
  List<Object> get props => [
        sucessful,
      ];
}

class RedeemInitial extends RedeemState {
  final bool sucessful;

  RedeemInitial({this.sucessful = false}) : super(sucessful);

  @override
  List<Object> get props => [sucessful];
}

class RedeemStatus extends RedeemState {
  final bool sucessful;

  RedeemStatus({this.sucessful = false}) : super(sucessful);

  @override
  List<Object> get props => [sucessful];
}
