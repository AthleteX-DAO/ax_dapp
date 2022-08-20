import 'package:equatable/equatable.dart';

abstract class RemoveLiquidityEvent extends Equatable {
  const RemoveLiquidityEvent();

  @override
  List<Object> get props => [];
}

class PageRefreshEvent extends RemoveLiquidityEvent {}

class RemoveInput extends RemoveLiquidityEvent {
  const RemoveInput({
    required this.removeInput,
  });

  final double removeInput;

  @override
  List<Object> get props => [removeInput];
}
