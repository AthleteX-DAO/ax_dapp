import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bottom_navigation_bar_event.dart';
part 'bottom_navigation_bar_state.dart';

class BottomNavigationBarBloc
    extends Bloc<BottomNavigationBarEvent, BottomNavigationBarState> {
  BottomNavigationBarBloc() : super(BottomNavigationBarInitial()) {
    on<SelectItemEvent>(_onSelectItemEvent);
    on<LoadSelectedItemEvent>(_onLoadSelectedItemEvent);

    add(LoadSelectedItemEvent());
  }

  Future<void> _onSelectItemEvent(
    SelectItemEvent event,
    Emitter<BottomNavigationBarState> emit,
  ) async {
    final itemIndex = event.itemIndex;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedIndex', itemIndex);
    emit(ItemSelectedState(selectedItem: itemIndex));
  }

  Future<void> _onLoadSelectedItemEvent(
    LoadSelectedItemEvent event,
    Emitter<BottomNavigationBarState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedIndex = prefs.getInt('selectedIndex') ?? 0;
    add(SelectItemEvent(itemIndex: selectedIndex));
  }
}
