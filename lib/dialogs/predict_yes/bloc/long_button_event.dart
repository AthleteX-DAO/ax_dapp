part of 'long_button_bloc.dart';

abstract class YesButtonEvent extends Equatable {
  const YesButtonEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends YesButtonEvent {
  const WatchAppDataChangesStarted();
}

class YesButtonPressed extends YesButtonEvent {
  const YesButtonPressed({
    required this.eventMarketAddress,
    required this.longTokenAddress,
  });

  final String eventMarketAddress, longTokenAddress;
  @override
  List<Object?> get props => [eventMarketAddress, longTokenAddress];
}

class FetchSwapInfoRequested extends YesButtonEvent {
  const FetchSwapInfoRequested({
    required this.longTokenAddress,
  });

  final String longTokenAddress;

  @override
  List<Object?> get props => [longTokenAddress];
}

class BuyButtonPressed extends YesButtonEvent {
  const BuyButtonPressed({
    required this.eventMarketAddress,
    required this.longTokenAddress,
  });

  final String eventMarketAddress, longTokenAddress;
  @override
  List<Object?> get props => [eventMarketAddress, longTokenAddress];
}

class SellButtonPressed extends YesButtonEvent {
  const SellButtonPressed({
    required this.eventMarketAddress,
    required this.longTokenAddress,
  });

  final String eventMarketAddress, longTokenAddress;
  @override
  List<Object?> get props => [eventMarketAddress, longTokenAddress];
}
