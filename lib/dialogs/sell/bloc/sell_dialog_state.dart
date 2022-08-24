part of 'sell_dialog_bloc.dart';

class SellDialogState extends Equatable {
  const SellDialogState({
    this.status = BlocStatus.initial,
    this.aptTypeSelection = AptType.long,
    this.longApt = const Apt.empty(),
    this.shortApt = const Apt.empty(),
    this.balance = 0,
    this.aptInputAmount = 0,
    this.aptSellInfo = AptSellInfo.empty,
    this.errorMessage = '',
  });

  final AptType aptTypeSelection;
  final Apt longApt;
  final Apt shortApt;
  final double balance;
  final double aptInputAmount;
  final BlocStatus status;
  final AptSellInfo aptSellInfo;
  final String errorMessage;

  @override
  List<Object> get props {
    return [
      aptTypeSelection,
      longApt,
      shortApt,
      balance,
      aptInputAmount,
      status,
      aptSellInfo,
      errorMessage,
    ];
  }

  SellDialogState copyWith({
    AptType? aptTypeSelection,
    Apt? longApt,
    Apt? shortApt,
    double? balance,
    double? aptInputAmount,
    BlocStatus? status,
    String? tokenAddress,
    AptSellInfo? aptSellInfo,
    String? errorMessage,
  }) {
    return SellDialogState(
      aptTypeSelection: aptTypeSelection ?? this.aptTypeSelection,
      longApt: longApt ?? this.longApt,
      shortApt: shortApt ?? this.shortApt,
      balance: balance ?? this.balance,
      aptInputAmount: aptInputAmount ?? this.aptInputAmount,
      status: status ?? this.status,
      aptSellInfo: aptSellInfo ?? this.aptSellInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

extension BuyDialogStateX on SellDialogState {
  String get selectedAptAddress =>
      aptTypeSelection.isLong ? longApt.address : shortApt.address;
}
