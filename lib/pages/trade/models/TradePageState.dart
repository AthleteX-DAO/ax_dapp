part of 'package:ax_dapp/pages/trade/bloc/TradePageBloc.dart';

class TOKENS {
  static int get AX => 0;
  static int get SX => 1;
  static int get MATIC => 2;
  static int get WETH => 3;
}

class TradePageState extends Equatable {
  final double tokenToBalance;
  final double tokenFromBalance;
  final double tokenInputFromAmount;
  final double tokenInputToAmount;
  final BlocStatus status;
  final Token tokenFrom;
  final Token tokenTo;
  final TokenSwapInfo swapInfo;

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

  factory TradePageState.initial(Controller controller, bool isBuyAX) {
    final int networkID = controller.networkID.value;
    Token tokenFrom = TokenList.tokenList[TOKENS.AX];
    Token tokenTo = TokenList.tokenList[TOKENS.WETH];
    if (isBuyAX) {
      if (networkID == Controller.MAINNET_CHAIN_ID) {
        tokenFrom = TokenList.tokenList[TOKENS.MATIC];
        tokenTo = TokenList.tokenList[TOKENS.AX];
      } else if (networkID == Controller.MAINNET_SX_CHAIN_ID) {
        tokenFrom = TokenList.tokenList[TOKENS.SX];
        tokenTo = TokenList.tokenList[TOKENS.AX];
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
        swapInfo: TokenSwapInfo.empty());
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
