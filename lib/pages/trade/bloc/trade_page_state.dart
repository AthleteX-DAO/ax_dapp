part of 'trade_page_bloc.dart';

class TradePageState extends Equatable {
  const TradePageState({
    required this.tokenToBalance,
    required this.tokenFromBalance,
    required this.tokenInputFromAmount,
    required this.tokenInputToAmount,
    required this.status,
    required this.tokenFrom,
    required this.tokenTo,
    required this.swapInfo,
  });

  // ignore: avoid_positional_boolean_parameters
  factory TradePageState.initial(Controller controller, bool isBuyAX) {
    final networkID = controller.networkID.value;
    var tokenFrom = TokenList.tokenList[TokenIndex.ax];
    var tokenTo = TokenList.tokenList[TokenIndex.weth];
    if (isBuyAX) {
      if (networkID == Controller.mainnetChainId) {
        tokenFrom = TokenList.tokenList[TokenIndex.matic];
        tokenTo = TokenList.tokenList[TokenIndex.ax];
      } else if (networkID == Controller.mainnetSXChainId) {
        tokenFrom = TokenList.tokenList[TokenIndex.sx];
        tokenTo = TokenList.tokenList[TokenIndex.ax];
      }
    }
    return TradePageState(
      tokenToBalance: 0,
      tokenFromBalance: 0,
      tokenInputFromAmount: 0,
      tokenInputToAmount: 0,
      status: BlocStatus.initial,
      tokenFrom: tokenFrom,
      tokenTo: tokenTo,
      swapInfo: TokenSwapInfo.empty(),
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
