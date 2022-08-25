part of 'my_liquidity_bloc.dart';

class MyLiquidityState extends Equatable {
  const MyLiquidityState({
    this.status = BlocStatus.initial,
    this.cards = const [],
    this.filteredCards = const [],
    this.searchTerm = '',
  });

  final BlocStatus status;
  final List<LiquidityPositionInfo> cards;
  final List<LiquidityPositionInfo> filteredCards;
  final String searchTerm;

  MyLiquidityState copyWith({
    BlocStatus? status,
    List<LiquidityPositionInfo>? cards,
    List<LiquidityPositionInfo>? filteredCards,
    String? searchTerm,
  }) {
    return MyLiquidityState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      filteredCards: filteredCards ?? this.filteredCards,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }

  @override
  List<Object> get props => [status, cards, filteredCards, searchTerm];
}
