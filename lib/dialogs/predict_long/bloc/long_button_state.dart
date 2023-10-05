part of 'long_button_bloc.dart';

class LongButtonState extends Equatable {
  const LongButtonState({
    this.status = BlocStatus.initial,
    this.errorMessage = '',
    this.swapInfo = SwapInfo.empty,
    this.aptBuyInfo = AptBuyInfo.empty,
    this.aptSellInfo = AptSellInfo.empty,
  });

  final BlocStatus status;
  final String errorMessage;
  final SwapInfo swapInfo;
  final AptBuyInfo aptBuyInfo;
  final AptSellInfo aptSellInfo;

  @override
  List<Object?> get props => [
        status,
        aptBuyInfo,
        aptSellInfo,
        swapInfo,
        errorMessage,
      ];

  LongButtonState copyWith({
    BlocStatus? status,
    String? errorMessage,
    SwapInfo? swapInfo,
    AptBuyInfo? aptBuyInfo,
    AptSellInfo? aptSellInfo,
  }) {
    return LongButtonState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      swapInfo: swapInfo ?? this.swapInfo,
      aptBuyInfo: aptBuyInfo ?? this.aptBuyInfo,
      aptSellInfo: aptSellInfo ?? this.aptSellInfo,
    );
  }
}
