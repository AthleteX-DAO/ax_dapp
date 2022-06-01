part of 'MyLiquidityBloc.dart';

class MyLiquidityState extends Equatable {
  final List<LiquidityPositionInfo> cards;
  final BlocStatus status;

  MyLiquidityState({
    required this.cards,
    required this.status,
  });

  factory MyLiquidityState.initial() {
    return MyLiquidityState(cards: [], status: BlocStatus.initial);
  }

  


  MyLiquidityState copyWith({
    List<LiquidityPositionInfo>? cards,
    BlocStatus? status,
  }) {
    return MyLiquidityState(
      cards: cards ?? this.cards,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [cards, status];

  @override
  String toString() => 'MyLiquidityState(cards: $cards, status: $status)';
}
