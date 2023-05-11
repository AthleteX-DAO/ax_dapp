part of 'mint_button_bloc.dart';

abstract class MintButtonEvent extends Equatable {
  const MintButtonEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends MintButtonEvent {
  const WatchAppDataChangesStarted();
}

class MintButtonPressed extends MintButtonEvent {
  const MintButtonPressed();
}
