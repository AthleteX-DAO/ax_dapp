part of 'long_button_bloc.dart';

abstract class LongButtonEvent extends Equatable {
  const LongButtonEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends LongButtonEvent {
  const WatchAppDataChangesStarted();
}

class LongButtonPressed extends LongButtonEvent {
  const LongButtonPressed({
    required this.eventMarketAddress,
    required this.longTokenAddress,
  });

  final String eventMarketAddress, longTokenAddress;
  @override
  List<Object?> get props => [eventMarketAddress, longTokenAddress];
}

class FetchSwapInfoRequested extends LongButtonEvent {
  const FetchSwapInfoRequested({
    required this.longTokenAddress,
  });

  final String longTokenAddress;

  @override
  List<Object?> get props => [longTokenAddress];
}

class BuyButtonPressed extends LongButtonEvent {
  const BuyButtonPressed({
    required this.eventMarketAddress,
    required this.longTokenAddress,
  });

  final String eventMarketAddress, longTokenAddress;
  @override
  List<Object?> get props => [eventMarketAddress, longTokenAddress];
}

class SellButtonPressed extends LongButtonEvent {
  const SellButtonPressed({
    required this.eventMarketAddress,
    required this.longTokenAddress,
  });

  final String eventMarketAddress, longTokenAddress;
  @override
  List<Object?> get props => [eventMarketAddress, longTokenAddress];
}
