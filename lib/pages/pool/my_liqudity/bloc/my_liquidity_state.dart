part of 'my_liquidity_bloc.dart';

class MyLiquidityState extends Equatable {
  const MyLiquidityState({
    required this.cards,
    required this.filteredCards,
    required this.status,
  });

  factory MyLiquidityState.initial() {
    return const MyLiquidityState(
      cards: [],
      filteredCards: [],
      status: BlocStatus.initial,
    );
  }

  final List<LiquidityPositionInfo> cards;
  final List<LiquidityPositionInfo> filteredCards;
  final BlocStatus status;

  MyLiquidityState copyWith({
    List<LiquidityPositionInfo>? cards,
    List<LiquidityPositionInfo>? filteredCards,
    BlocStatus? status,
  }) {
    return MyLiquidityState(
      cards: cards ?? this.cards,
      filteredCards: filteredCards ?? this.filteredCards,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [cards, status];

  @override
  String toString() => 'MyLiquidityState(cards: $cards, status: $status)';
}
