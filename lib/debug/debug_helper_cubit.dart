import 'package:flutter_bloc/flutter_bloc.dart';

class DebugHelperCubit extends Cubit<bool> {
  DebugHelperCubit({
    bool? expanded,
  }) : super(expanded ?? false);

  void toggleExpanded() {
    emit(!state);
  }
}
