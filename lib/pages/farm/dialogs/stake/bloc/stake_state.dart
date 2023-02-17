part of 'stake_bloc.dart';

class StakeState extends Equatable {
  const StakeState({
    this.status = BlocStatus.initial,
    this.currentStaked = 0,
    this.fundsAdded = 0,
    this.newBalance = 0,
    this.currentBalance = 0,
    this.stakeInput = 0,
    this.errorMessage = '',
    this.failure = Failure.none,
  });

  final double currentBalance;
  final double currentStaked;
  final double fundsAdded;
  final double newBalance;
  final double stakeInput;
  final BlocStatus status;
  final String errorMessage;
  final Failure failure;

  @override
  List<Object> get props => [
        currentBalance,
        currentStaked,
        fundsAdded,
        newBalance,
        stakeInput,
        status,
        errorMessage,
        failure,
      ];

  StakeState copyWith({
    double? currentBalance,
    double? currentStaked,
    double? fundsAdded,
    double? newBalance,
    double? stakeInput,
    BlocStatus? status,
    String? errorMessage,
    Failure? failure,
  }) {
    return StakeState(
      currentBalance: currentBalance ?? this.currentBalance,
      currentStaked: currentStaked ?? this.currentStaked,
      fundsAdded: fundsAdded ?? this.fundsAdded,
      newBalance: newBalance ?? this.newBalance,
      stakeInput: stakeInput ?? this.stakeInput,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }
}
