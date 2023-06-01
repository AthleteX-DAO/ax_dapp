part of 'top_navigation_bar_bloc.dart';

abstract class TopNavigationBarState extends Equatable {
  const TopNavigationBarState();

  @override
  List<Object> get props => [];
}

class TopNavigationBarInitial extends TopNavigationBarState {}

class ButtonSelectedState extends TopNavigationBarState {
  const ButtonSelectedState({required this.selectedButton});
  final String selectedButton;

  @override
  List<Object> get props => [selectedButton];
}
