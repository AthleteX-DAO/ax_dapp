part of 'MyLiquidityBloc.dart';

class MyLiquidityState extends Equatable {
  final List<LiquidityPositionInfo> cards;
  final List<LiquidityPositionInfo> filteredCards;
  final BlocStatus status;

  MyLiquidityState({
    required this.cards,
    required this.filteredCards,
    required this.status,
  });

  factory MyLiquidityState.initial() {
    return MyLiquidityState(
        cards: [], filteredCards: [], status: BlocStatus.initial);
  }

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
