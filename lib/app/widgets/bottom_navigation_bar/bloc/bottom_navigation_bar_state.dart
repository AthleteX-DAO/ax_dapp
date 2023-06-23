part of 'bottom_navigation_bar_bloc.dart';

abstract class BottomNavigationBarState extends Equatable {
  const BottomNavigationBarState();

  @override
  List<Object> get props => [];
}

class BottomNavigationBarInitial extends BottomNavigationBarState {}

class ItemSelectedState extends BottomNavigationBarState {
  const ItemSelectedState({required this.selectedItem});
  final int selectedItem;

  @override
  List<Object> get props => [selectedItem];
}
