part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class WatchChainChangesStarted extends AppEvent {
  const WatchChainChangesStarted();
}

// class WatchAptsChangesStarted extends AppEvent {
//   const WatchAptsChangesStarted();
// }
