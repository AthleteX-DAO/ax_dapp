part of 'package:ax_dapp/dialogs/sell/bloc/SellDialogBloc.dart';


class SellDialogState extends Equatable {
  final double balance;
  final double aptInputAmount;
  final BlocStatus status;
  final String tokenAddress;
  final AptSellInfo aptSellInfo;
  SellDialogState({
    required this.balance,
    required this.aptInputAmount,
    required this.status,
    required this.tokenAddress,
    required this.aptSellInfo,
  });

  factory SellDialogState.initial() {
    return SellDialogState(
        balance: 0,
        aptInputAmount: 0,
        status: BlocStatus.initial,
        tokenAddress: '',
        aptSellInfo: AptSellInfo.empty());
  }

  @override
  List<Object> get props {
    return [
      balance,
      aptInputAmount,
      status,
      tokenAddress,
      aptSellInfo,
    ];
  }

  SellDialogState copyWith({
    double? balance,
    double? aptInputAmount,
    BlocStatus? status,
    String? tokenAddress,
    AptSellInfo? aptSellInfo,
  }) {
    return SellDialogState(
      balance: balance ?? this.balance,
      aptInputAmount: aptInputAmount ?? this.aptInputAmount,
      status: status ?? this.status,
      tokenAddress: tokenAddress ?? this.tokenAddress,
      aptSellInfo: aptSellInfo ?? this.aptSellInfo,
    );
  }
}
