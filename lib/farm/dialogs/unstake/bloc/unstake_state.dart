part of 'unstake_bloc.dart';

class UnStakeState extends Equatable {
  const UnStakeState({
    this.status = BlocStatus.initial,
    this.currentStaked = 0,
    this.fundsRemoved = 0,
    this.newBalance = 0,
    this.currentBalance = 0,
    this.stakeInput = 0,
    this.stakedSymbol = '',
    this.stakedAlias = '',
    this.errorMessage = '',
    this.failure = Failure.none,
  });

  final double currentBalance;
  final double currentStaked;
  final double fundsRemoved;
  final double newBalance;
  final double stakeInput;
  final String stakedSymbol;
  final String stakedAlias;
  final BlocStatus status;
  final String errorMessage;
  final Failure failure;

  @override
  List<Object> get props => [
        currentBalance,
        currentStaked,
        fundsRemoved,
        newBalance,
        stakeInput,
        stakedSymbol,
        stakedAlias,
        status,
        errorMessage,
        failure,
      ];

  UnStakeState copyWith({
    double? currentBalance,
    double? currentStaked,
    double? fundsRemoved,
    double? newBalance,
    double? stakeInput,
    String? stakedSymbol,
    String? stakedAlias,
    BlocStatus? status,
    String? errorMessage,
    Failure? failure,
  }) {
    return UnStakeState(
      currentBalance: currentBalance ?? this.currentBalance,
      currentStaked: currentStaked ?? this.currentStaked,
      fundsRemoved: fundsRemoved ?? this.fundsRemoved,
      newBalance: newBalance ?? this.newBalance,
      stakeInput: stakeInput ?? this.stakeInput,
      stakedSymbol: stakedSymbol ?? this.stakedSymbol,
      stakedAlias: stakedAlias ?? this.stakedAlias,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }
}
