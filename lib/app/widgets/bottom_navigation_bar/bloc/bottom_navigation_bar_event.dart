part of 'bottom_navigation_bar_bloc.dart';

abstract class BottomNavigationBarEvent extends Equatable {
  const BottomNavigationBarEvent();

  @override
  List<Object> get props => [];
}

class SelectItemEvent extends BottomNavigationBarEvent {
  const SelectItemEvent({required this.itemIndex});
  final int itemIndex;

  @override
  List<Object> get props => [itemIndex];
}
