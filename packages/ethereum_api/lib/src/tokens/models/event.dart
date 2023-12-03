part of 'token.dart';

/// {@template athlete_event_token}
/// Represents an 'Athlete Performance Event' [Token]
/// {@endtemplate}

class Event extends Token {
  /// Represents a 'yes' prediction event
  Event.yes(
    EthereumChain chain, {
    required EventConfig eventConfig,
  })  : eventType = EventType.yes,
        _eventConfig = eventConfig,
        super(
          name: '',
          ticker: eventConfig.eventTicker,
          addressConfig: eventConfig.eventMarketAddressConfig,
          chain: chain,
          currency: EthereumCurrency.apt,
        );

  /// Represents an 'no' prediction event
  Event.no(
    EthereumChain chain, {
    required EventConfig eventConfig,
  })  : eventType = EventType.no,
        _eventConfig = eventConfig,
        super(
          name: '',
          ticker: eventConfig.eventTicker,
          addressConfig: eventConfig.eventMarketAddressConfig,
          chain: chain,
          currency: EthereumCurrency.apt,
        );

  /// Represents an empty [Event].  Useful as a default value.
  const Event.empty()
      : eventType = EventType.none,
        _eventConfig = EventConfig.empty,
        super(
          name: '',
          ticker: '',
          addressConfig: const EthereumAddressConfig.empty(),
          chain: EthereumChain.none,
          currency: EthereumCurrency.none,
        );

  /// Represents the type of [Event] outcome (yes or no).
  final EventConfig _eventConfig;
  final EventType eventType;

  @override
  List<Object?> get props => super.props..addAll([eventType, _eventConfig]);
}
