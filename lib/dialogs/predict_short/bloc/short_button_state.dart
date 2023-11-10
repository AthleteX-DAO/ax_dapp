part of 'short_button_bloc.dart';

class ShortButtonState extends Equatable {
  const ShortButtonState({
    this.status = BlocStatus.initial,
    this.errorMessage = '',
    this.aptBuyInfo = AptBuyInfo.empty,
    this.aptSellInfo = AptSellInfo.empty,
  });

  final BlocStatus status;
  final String errorMessage;
  final AptBuyInfo aptBuyInfo;
  final AptSellInfo aptSellInfo;

  @override
  List<Object?> get props => [
        status,
        aptBuyInfo,
        aptSellInfo,
        errorMessage,
      ];

  ShortButtonState copyWith({
    BlocStatus? status,
    String? errorMessage,
    AptBuyInfo? aptBuyInfo,
    AptSellInfo? aptSellInfo,
  }) {
    return ShortButtonState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      aptBuyInfo: aptBuyInfo ?? this.aptBuyInfo,
      aptSellInfo: aptSellInfo ?? this.aptSellInfo,
    );
  }
}
