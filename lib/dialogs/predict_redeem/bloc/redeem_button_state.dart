part of 'redeem_button_bloc.dart';

class RedeemButtonState extends Equatable {
  const RedeemButtonState({
    this.status = BlocStatus.initial,
  });

  final BlocStatus status;

  @override
  List<Object?> get props => [status];

  RedeemButtonState copyWith({
    BlocStatus? status,
  }) {
    return RedeemButtonState(
      status: status ?? this.status,
    );
  }
}
