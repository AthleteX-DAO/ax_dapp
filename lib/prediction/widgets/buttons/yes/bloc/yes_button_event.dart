part of 'yes_button_bloc.dart';

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

class SwapEvent extends YesButtonEvent {
  const SwapEvent({
    required this.tokenTo,
    required this.tokenFrom,
  });

  final String tokenTo, tokenFrom;

  @override
  List<Object?> get props => [tokenTo, tokenFrom];
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
