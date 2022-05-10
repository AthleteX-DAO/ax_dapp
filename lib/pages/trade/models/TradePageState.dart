part of 'package:ax_dapp/pages/trade/bloc/TradePageBloc.dart';


class TradePageState extends Equatable {
  final double tokenToBalance;
  final double tokenFromBalance;
  final double tokenInputFromAmount;
  final double tokenInputToAmount;
  final BlocStatus status;
  final Token tokenFrom;
  final Token tokenTo;
  final SwapInfo swapInfo;

  TradePageState({
    required this.tokenToBalance,
    required this.tokenFromBalance,
    required this.tokenInputFromAmount,
    required this.tokenInputToAmount,
    required this.status,
    required this.tokenFrom,
    required this.tokenTo,
    required this.swapInfo,
  });

  factory TradePageState.initial() {
    return TradePageState(
        tokenToBalance: 0,
        tokenFromBalance: 0,
        tokenInputFromAmount: 0,
        tokenInputToAmount: 0,
        status: BlocStatus.initial,
        tokenFrom: TokenList.tokenList[0],
        tokenTo: TokenList.tokenList[3],
        swapInfo: SwapInfo.empty());
  }

  @override
  List<Object> get props {
    return [
      tokenToBalance,
      tokenFromBalance,
      tokenInputFromAmount,
      tokenInputToAmount,
      status,
      tokenFrom,
      tokenTo,
      swapInfo,
    ];
  }

  TradePageState copyWith({
    double? tokenToBalance,
    double? tokenFromBalance,
    double? tokenInputFromAmount,
    double? tokenInputToAmount,
    BlocStatus? status,
    Token? tokenFrom,
    Token? tokenTo,
    SwapInfo? swapInfo,
  }) {
    return TradePageState(
      tokenToBalance: tokenToBalance ?? this.tokenToBalance,
      tokenFromBalance: tokenFromBalance ?? this.tokenFromBalance,
      tokenInputFromAmount: tokenInputFromAmount ?? this.tokenInputFromAmount,
      tokenInputToAmount: tokenInputToAmount ?? this.tokenInputToAmount,
      status: status ?? this.status,
      tokenFrom: tokenFrom ?? this.tokenFrom,
      tokenTo: tokenTo ?? this.tokenTo,
      swapInfo: swapInfo ?? this.swapInfo,
    );
  }
}
