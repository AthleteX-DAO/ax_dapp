import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_navigation_bar_event.dart';
part 'bottom_navigation_bar_state.dart';

class BottomNavigationBarBloc
    extends Bloc<BottomNavigationBarEvent, BottomNavigationBarState> {
  BottomNavigationBarBloc() : super(BottomNavigationBarInitial()) {
    on<SelectItemEvent>(_onSelectItemEvent);
  }

  Future<void> _onSelectItemEvent(
    SelectItemEvent event,
    Emitter<BottomNavigationBarState> emit,
  ) async {
    final itemIndex = event.itemIndex;
    emit(ItemSelectedState(selectedItem: itemIndex));
  }
}
