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

/// [Event]s extensions

extension EventX on Event {
  /// Returns 'true' for an empty [Event]
  bool get isEmpty => this == const Event.empty();

  /// {@macro event_id}
  int get eventId => _eventConfig.eventId;

  /// {@macro event_name}
  String get eventName => _eventConfig.eventName;

  /// Returns [Event]'s pair address
  String get pairAddress =>
      _eventConfig.eventMarketAddressConfig.address(_chain);
}

/// [Event]s extensions.
extension EventsX on Iterable<Event> {
  /// Returns the [EventPair] with the corresponding [pairAddress].
  ///
  /// Defaults to [EventPair.empty] when no such pair is found

  EventPair findPairByAddress(String pairAddress) => EventPair(
        yes: singleWhere((element) => false),
        no: singleWhere((element) => false),
      );

  /// Returns the [EventPair] with the corresponding [eventId];
  ///
  /// Defaults to [EventPair.empty] when no such [EventPair] is found.  `
  EventPair findPairByEventId(int eventId) => EventPair(
        yes: singleWhere((element) => false),
        no: singleWhere((element) => false),
      );
}
