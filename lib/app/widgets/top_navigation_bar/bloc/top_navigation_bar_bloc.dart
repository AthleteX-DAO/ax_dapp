import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'top_navigation_bar_event.dart';
part 'top_navigation_bar_state.dart';

class TopNavigationBarBloc
    extends Bloc<TopNavigationBarEvent, TopNavigationBarState> {
  TopNavigationBarBloc() : super(TopNavigationBarInitial()) {
    on<SelectButtonEvent>(_onSelectButtonEvent);
    on<LoadSelectedButton>(_onLoadSelectedButton);
    
    add(LoadSelectedButton());
  }

  Future<void> _onSelectButtonEvent(
    SelectButtonEvent event,
    Emitter<TopNavigationBarState> emit,
  ) async {
    final buttonName = event.buttonName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedButton', buttonName);
    emit(ButtonSelectedState(selectedButton: buttonName));
  }

  Future<void> _onLoadSelectedButton(
    LoadSelectedButton event,
    Emitter<TopNavigationBarState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedButton = prefs.getString('selectedButton') ?? '';
    add(SelectButtonEvent(buttonName: selectedButton));
  }
}
