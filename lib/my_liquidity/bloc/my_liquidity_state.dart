part of 'my_liquidity_bloc.dart';

class MyLiquidityState extends Equatable {
  const MyLiquidityState({
    this.status = BlocStatus.initial,
    this.cards = const [],
    this.filteredCards = const [],
    this.searchTerm = '',
    this.failure = Failure.none,
  });

  final BlocStatus status;
  final List<LiquidityPositionInfo> cards;
  final List<LiquidityPositionInfo> filteredCards;
  final String searchTerm;
  final Failure failure;

  MyLiquidityState copyWith({
    BlocStatus? status,
    List<LiquidityPositionInfo>? cards,
    List<LiquidityPositionInfo>? filteredCards,
    String? searchTerm,
    Failure? failure,
  }) {
    return MyLiquidityState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      filteredCards: filteredCards ?? this.filteredCards,
      searchTerm: searchTerm ?? this.searchTerm,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props => [status, cards, filteredCards, searchTerm, failure];

  @override
  String toString() => 'MyLiquidityState(cards: $cards, status: $status)';
}
