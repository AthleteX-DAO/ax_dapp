part of 'buy_dialog_bloc.dart';

class BuyDialogState extends Equatable {
  const BuyDialogState({
    required this.balance,
    required this.axInputAmount,
    required this.status,
    required this.tokenAddress,
    required this.aptBuyInfo,
    required this.errorMessage,
  });

  factory BuyDialogState.initial() {
    return BuyDialogState(
      balance: 0,
      axInputAmount: 0,
      status: BlocStatus.initial,
      tokenAddress: '',
      aptBuyInfo: AptBuyInfo.empty(),
      errorMessage: '',
    );
  }
  final double balance;
  final double axInputAmount;
  final BlocStatus status;
  final String tokenAddress;
  final AptBuyInfo aptBuyInfo;
  final String errorMessage;

  @override
  List<Object> get props {
    return [
      balance,
      axInputAmount,
      status,
      tokenAddress,
      aptBuyInfo,
      errorMessage
    ];
  }

  BuyDialogState copyWith({
    double? balance,
    double? axInputAmount,
    BlocStatus? status,
    String? tokenAddress,
    AptBuyInfo? aptBuyInfo,
    String? errorMessage,
  }) {
    return BuyDialogState(
      balance: balance ?? this.balance,
      axInputAmount: axInputAmount ?? this.axInputAmount,
      status: status ?? this.status,
      tokenAddress: tokenAddress ?? this.tokenAddress,
      aptBuyInfo: aptBuyInfo ?? this.aptBuyInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
