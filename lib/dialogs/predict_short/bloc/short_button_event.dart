part of 'short_button_bloc.dart';

abstract class ShortButtonEvent extends Equatable {
  const ShortButtonEvent();

  @override
  List<Object?> get props => [];
}

class WatchAppDataChangesStarted extends ShortButtonEvent {
  const WatchAppDataChangesStarted();
}

class ShortButtonPressed extends ShortButtonEvent {
  const ShortButtonPressed({
    required this.eventMarketAddress,
    required this.shortTokenAddress,
  });

  final String eventMarketAddress, shortTokenAddress;
  @override
  List<Object?> get props => [eventMarketAddress, shortTokenAddress];
}

class FetchBuyInfoRequested extends ShortButtonEvent {
  const FetchBuyInfoRequested({required this.shortTokenAddress});
  final String shortTokenAddress;
  @override
  List<Object?> get props => [shortTokenAddress];
}

class BuyButtonPressed extends ShortButtonEvent {
  const BuyButtonPressed({
    required this.eventMarketAddress,
    required this.shortTokenAddress,
  });

  final String eventMarketAddress, shortTokenAddress;
  @override
  List<Object?> get props => [eventMarketAddress, shortTokenAddress];
}

class SellButtonPressed extends ShortButtonEvent {
  const SellButtonPressed({
    required this.eventMarketAddress,
    required this.shortTokenAddress,
  });

  final String eventMarketAddress, shortTokenAddress;
  @override
  List<Object?> get props => [eventMarketAddress, shortTokenAddress];
}
