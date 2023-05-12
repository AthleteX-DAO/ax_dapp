part of 'no_button_bloc.dart';

abstract class NoButtonEvent extends Equatable {
  const NoButtonEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends NoButtonEvent {
  const WatchAppDataChangesStarted();
}

class NoButtonPressed extends NoButtonEvent {
  const NoButtonPressed({
    required this.eventMarketAddress,
    required this.shortTokenAddress,
  });

  final String eventMarketAddress, shortTokenAddress;
  @override
  List<Object?> get props => [eventMarketAddress, shortTokenAddress];
}
