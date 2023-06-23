part of 'top_navigation_bar_bloc.dart';

abstract class TopNavigationBarEvent extends Equatable {
  const TopNavigationBarEvent();

  @override
  List<Object> get props => [];
}

class SelectButtonEvent extends TopNavigationBarEvent {
  const SelectButtonEvent({required this.buttonName});
  final String buttonName;

  @override
  List<Object> get props => [buttonName];
}
