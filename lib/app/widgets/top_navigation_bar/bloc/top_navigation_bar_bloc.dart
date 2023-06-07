import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'top_navigation_bar_event.dart';
part 'top_navigation_bar_state.dart';

class TopNavigationBarBloc
    extends Bloc<TopNavigationBarEvent, TopNavigationBarState> {
  TopNavigationBarBloc() : super(TopNavigationBarInitial()) {
    on<SelectButtonEvent>(_onSelectButtonEvent);
  }

  Future<void> _onSelectButtonEvent(
    SelectButtonEvent event,
    Emitter<TopNavigationBarState> emit,
  ) async {
    final buttonName = event.buttonName;
    emit(ButtonSelectedState(selectedButton: buttonName));
  }
}
