part of 'perps_trading_bloc.dart';

abstract class PerpsTradingState extends Equatable {
  const PerpsTradingState();

  @override
  List<Object?> get props => [];
}

class PerpsTradingInitial extends PerpsTradingState {
  const PerpsTradingInitial();
}

class PerpsTradingLoading extends PerpsTradingState {
  const PerpsTradingLoading();
}

class PerpsTradingSuccess extends PerpsTradingState {
  const PerpsTradingSuccess({
    required this.transactionHash,
    this.message,
  });

  final String transactionHash;
  final String? message;

  @override
  List<Object?> get props => [transactionHash, message];
}

class PerpsTradingError extends PerpsTradingState {
  const PerpsTradingError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class PerpsTradingBalanceUpdated extends PerpsTradingState {
  const PerpsTradingBalanceUpdated({
    required this.availableMargin,
    required this.accountValue,
  });

  final double availableMargin;
  final double accountValue;

  @override
  List<Object?> get props => [availableMargin, accountValue];
}
