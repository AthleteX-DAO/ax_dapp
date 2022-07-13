part of 'redeem_bloc.dart';

class RedeemState extends Equatable {
  final bool sucessful;
  factory RedeemState.initial() {
    return RedeemState(sucessful: false);
  }

  RedeemState({
    required this.sucessful,
  });

  @override
  List<Object> get props {
    return [
      sucessful,
    ];
  }

  RedeemState copyWith({
    bool? sucessful = false,
  }) {
    return RedeemState(
      sucessful: sucessful ?? this.sucessful,
    );
  }
}
