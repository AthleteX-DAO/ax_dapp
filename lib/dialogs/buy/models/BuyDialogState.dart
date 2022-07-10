part of 'package:ax_dapp/dialogs/buy/bloc/BuyDialogBloc.dart';


class BuyDialogState extends Equatable {
  final double balance;
  final double axInputAmount;
  final BlocStatus status;
  final bool canTrade;
  final String tokenAddress;
  final AptBuyInfo aptBuyInfo;
  BuyDialogState({
    required this.balance,
    required this.axInputAmount,
    required this.status,
    required this.canTrade,
    required this.tokenAddress,
    required this.aptBuyInfo,
  });

  factory BuyDialogState.initial() {
    return BuyDialogState(
        balance: 0,
        canTrade: true,
        axInputAmount: 0,
        status: BlocStatus.initial,
        tokenAddress: '',
        aptBuyInfo: AptBuyInfo.empty());
  }

  @override
  List<Object> get props {
    return [
      balance,
      axInputAmount,
      status,
      tokenAddress,
      aptBuyInfo,
      canTrade,
    ];
  }

  BuyDialogState copyWith({
    double? balance,
    double? axInputAmount,
    BlocStatus? status,
    String? tokenAddress,
    AptBuyInfo? aptBuyInfo,
    bool? canTrade,
  }) {
    return BuyDialogState(
      balance: balance ?? this.balance,
      canTrade: canTrade ?? this.canTrade,
      axInputAmount: axInputAmount ?? this.axInputAmount,
      status: status ?? this.status,
      tokenAddress: tokenAddress ?? this.tokenAddress,
      aptBuyInfo: aptBuyInfo ?? this.aptBuyInfo,
    );
  }
}
