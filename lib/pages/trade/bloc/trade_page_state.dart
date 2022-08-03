part of 'trade_page_bloc.dart';

class TradePageState extends Equatable {
  const TradePageState({
    this.status = BlocStatus.initial,
    this.tokenToBalance = 0,
    this.tokenFromBalance = 0,
    this.tokenInputFromAmount = 0,
    this.tokenInputToAmount = 0,
    required this.tokenFrom,
    required this.tokenTo,
    this.swapInfo = TokenSwapInfo.empty,
  });

  factory TradePageState.initial({
    required bool isBuyAX,
    required EthereumChain chain,
  }) {
    final tradeTokens = chain.computeTradeTokens(isBuyAX: isBuyAX);
    return TradePageState(
      tokenFrom: tradeTokens.tokenFrom,
      tokenTo: tradeTokens.tokenTo,
    );
  }

  final double tokenToBalance;
  final double tokenFromBalance;
  final double tokenInputFromAmount;
  final double tokenInputToAmount;
  final BlocStatus status;
  final Token tokenFrom;
  final Token tokenTo;
  final TokenSwapInfo swapInfo;

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
    TokenSwapInfo? swapInfo,
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
