part of 'mint_dialog_bloc.dart';

class MintDialogState extends Equatable {
  const MintDialogState({
    this.aptPair = AptPair.empty,
    this.longApt = const Apt.empty(),
    this.shortApt = const Apt.empty(),
    this.balance = 0,
    this.mintInputAmount = 0,
    this.shortReceiveAmount = 0,
    this.longReceiveAmount = 0,
    this.status = BlocStatus.initial,
    this.errorMessage = '',
    this.failure = Failure.none,
    this.spendAmount = 0,
    this.collateralPerPair = 0,
  });

  final AptPair aptPair;
  final Apt longApt;
  final Apt shortApt;
  final double balance;
  final double mintInputAmount;
  final double shortReceiveAmount;
  final double longReceiveAmount;
  final BlocStatus status;
  final String errorMessage;
  final Failure failure;
  final double spendAmount;
  final int collateralPerPair;

  @override
  List<Object> get props {
    return [
      aptPair,
      longApt,
      shortApt,
      balance,
      mintInputAmount,
      shortReceiveAmount,
      longReceiveAmount,
      status,
      errorMessage,
      failure,
      spendAmount,
      collateralPerPair,
    ];
  }

  MintDialogState copyWith({
    AptPair? aptPair,
    Apt? longApt,
    Apt? shortApt,
    double? balance,
    double? mintInputAmount,
    double? shortReceiveAmount,
    double? longReceiveAmount,
    BlocStatus? status,
    String? errorMessage,
    Failure? failure,
    double? spendAmount,
    int? collateralPerPair,
  }) {
    return MintDialogState(
      aptPair: aptPair ?? this.aptPair,
      longApt: longApt ?? this.longApt,
      shortApt: shortApt ?? this.shortApt,
      balance: balance ?? this.balance,
      mintInputAmount: mintInputAmount ?? this.mintInputAmount,
      shortReceiveAmount: shortReceiveAmount ?? this.shortReceiveAmount,
      longReceiveAmount: longReceiveAmount ?? this.longReceiveAmount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      spendAmount: spendAmount ?? this.spendAmount,
      collateralPerPair: collateralPerPair ?? this.collateralPerPair,
    );
  }
}

class InsufficientFailure extends Failure {
  /// {macro temp_failure}
  InsufficientFailure()
      : super(Exception('Insufficient Failure'), StackTrace.empty);
}
