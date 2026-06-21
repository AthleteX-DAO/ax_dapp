part of 'swap_page_bloc.dart';

class SwapPageState extends Equatable {
  const SwapPageState({
    this.status = BlocStatus.initial,
    this.tokenToBalance = 0,
    this.tokenFromBalance = 0,
    this.tokenInputFromAmount = 0,
    this.tokenInputToAmount = 0,
    required this.tokenFrom,
    required this.tokenTo,
    this.swapInfo = TokenSwapInfo.empty,
    this.failure = Failure.none,
  });

  factory SwapPageState.initial({
    required bool isBuyAX,
    required EthereumChain chain,
  }) {
    final tradeTokens = chain.computeTradeTokens(isBuyAX: isBuyAX);
    return SwapPageState(
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
  final Failure failure;

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
      failure,
    ];
  }

  SwapPageState copyWith({
    double? tokenToBalance,
    double? tokenFromBalance,
    double? tokenInputFromAmount,
    double? tokenInputToAmount,
    BlocStatus? status,
    Token? tokenFrom,
    Token? tokenTo,
    TokenSwapInfo? swapInfo,
    Failure? failure,
  }) {
    return SwapPageState(
      tokenToBalance: tokenToBalance ?? this.tokenToBalance,
      tokenFromBalance: tokenFromBalance ?? this.tokenFromBalance,
      tokenInputFromAmount: tokenInputFromAmount ?? this.tokenInputFromAmount,
      tokenInputToAmount: tokenInputToAmount ?? this.tokenInputToAmount,
      status: status ?? this.status,
      tokenFrom: tokenFrom ?? this.tokenFrom,
      tokenTo: tokenTo ?? this.tokenTo,
      swapInfo: swapInfo ?? this.swapInfo,
      failure: failure ?? this.failure,
    );
  }
}

/// {@template temp_failure}
/// Temporary failure, this should come from the bottom most layer.
/// {@endtemplate}
class NoSwapInfoFailure extends Failure {
  /// {@macro temp_failure}
  NoSwapInfoFailure() : super(Exception('No swap info'), StackTrace.empty);
}

/// {@macro temp_failure}
class UnknownTradeFailure extends Failure {
  /// {@macro temp_failure}
  UnknownTradeFailure()
      : super(Exception('Something went wrong'), StackTrace.empty);
}

class InSufficientFailure extends Failure {
  /// {@macro temp_failure}
  InSufficientFailure()
      : super(Exception('InSufficent Failure'), StackTrace.empty);
}

/// {@macro temp_failure}
class GraphQLFailure extends Failure {
  /// {@macro temp_failure}
  GraphQLFailure({String? message})
      : super(
          Exception(message ?? 'GraphQL service unavailable'),
          StackTrace.empty,
        );
}

/// {@macro temp_failure}
class NoLiquidityPoolFailure extends Failure {
  /// {@macro temp_failure}
  NoLiquidityPoolFailure()
      : super(
          Exception('No liquidity pool found for this token pair'),
          StackTrace.empty,
        );
}

/// {@macro temp_failure}
class NetworkFailure extends Failure {
  /// {@macro temp_failure}
  NetworkFailure()
      : super(Exception('Network connectivity issue'), StackTrace.empty);
}
