part of 'redeem_dialog_bloc.dart';

class RedeemDialogState extends Equatable {
  const RedeemDialogState({
    this.aptPair = AptPair.empty,
    this.longApt = const Apt.empty(),
    this.shortApt = const Apt.empty(),
    this.longBalance = 0,
    this.shortBalance = 0,
    this.shortRedeemInput = 0,
    this.longRedeemInput = 0,
    this.receiveAmount = 0,
    this.status = BlocStatus.initial,
    this.errorMessage = '',
    this.failure = Failure.none,
    this.spendAmount = 0,
    this.collateralPerPair = 0,
    this.smallestBalance = 0,
  });

  final AptPair aptPair;
  final Apt longApt;
  final Apt shortApt;
  final double longBalance;
  final double shortBalance;
  final double shortRedeemInput;
  final double longRedeemInput;
  final double receiveAmount;
  final BlocStatus status;
  final String errorMessage;
  final Failure failure;
  final double spendAmount;
  final int collateralPerPair;
  final double smallestBalance;

  @override
  List<Object> get props {
    return [
      aptPair,
      longApt,
      shortApt,
      longBalance,
      shortBalance,
      shortRedeemInput,
      longRedeemInput,
      receiveAmount,
      status,
      errorMessage,
      failure,
      spendAmount,
      collateralPerPair,
      smallestBalance,
    ];
  }

  RedeemDialogState copyWith({
    AptPair? aptPair,
    Apt? longApt,
    Apt? shortApt,
    double? longBalance,
    double? shortBalance,
    double? shortRedeemInput,
    double? longRedeemInput,
    double? receiveAmount,
    BlocStatus? status,
    String? errorMessage,
    Failure? failure,
    double? spendAmount,
    int? collateralPerPair,
    double? smallestBalance,
  }) {
    return RedeemDialogState(
      aptPair: aptPair ?? this.aptPair,
      longApt: longApt ?? this.longApt,
      shortApt: shortApt ?? this.shortApt,
      longBalance: longBalance ?? this.longBalance,
      shortBalance: shortBalance ?? this.shortBalance,
      shortRedeemInput: shortRedeemInput ?? this.shortRedeemInput,
      longRedeemInput: longRedeemInput ?? this.longRedeemInput,
      receiveAmount: receiveAmount ?? this.receiveAmount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      spendAmount: spendAmount ?? this.spendAmount,
      collateralPerPair: collateralPerPair ?? this.collateralPerPair,
      smallestBalance: smallestBalance ?? this.smallestBalance,
    );
  }
}
