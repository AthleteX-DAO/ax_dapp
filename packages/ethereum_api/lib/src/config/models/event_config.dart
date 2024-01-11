import 'dart:core';

import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/config/models/events/baseball_events_list.dart';
import 'package:ethereum_api/src/config/models/events/basketball_events_list.dart';
import 'package:ethereum_api/src/config/models/events/college_events_list.dart';
import 'package:ethereum_api/src/config/models/events/exotic_events_list.dart';
import 'package:ethereum_api/src/config/models/events/football_events_list.dart';
import 'package:ethereum_api/src/config/models/events/hockey_events_list.dart';
import 'package:ethereum_api/src/config/models/events/soccer_events_list.dart';
import 'package:ethereum_api/src/ethereum/models/models.dart';
import 'package:ethereum_api/src/tokens/tokens.dart';
import 'package:shared/shared.dart';

/// {@template athlete_performane_token_config}
/// Configures an [Apt] Prediction Market
/// {@endtemplate}

class EventConfig extends Equatable {
  /// {@macro athlete_events_markets_config}
  const EventConfig({
    required this.eventId,
    required this.eventName,
    required this.eventTicker,
    required this.eventMarketAddressConfig,
    required this.longAddressConfig,
    required this.shortAddressConfig,
  });

  /// {@template market_id}
  /// Represents market's ID.
  /// {@endtemplate}
  final int eventId;

  /// {@template marketName}
  /// Represents event market's name
  /// {@endtemplate}
  final String eventName;

  /// Represents the [Event] market's ticker.
  final String eventTicker;

  /// Represent the [Event] market's address configuration.
  final EthereumAddressConfig eventMarketAddressConfig;

  /// Represents [Apt.long]'s address configuration.
  final EthereumAddressConfig longAddressConfig;

  /// Represents [Apt.short]'s address configuration.
  final EthereumAddressConfig shortAddressConfig;

  @override
  // TODO: implement props
  List<Object?> get props => [
        eventId,
        eventName,
        eventTicker,
        eventMarketAddressConfig,
        longAddressConfig,
        shortAddressConfig,
      ];

  /// Represents an empty [EventConfig]. Useful as default value.
  static const empty = EventConfig(
    eventId: 0,
    eventName: '',
    eventTicker: '',
    eventMarketAddressConfig: EthereumAddressConfig.empty(),
    longAddressConfig: EthereumAddressConfig.empty(),
    shortAddressConfig: EthereumAddressConfig.empty(),
  );
}

/// Static list of [EventConfig]s used to generate token lists
List<EventConfig> getAllEventMarkets() {
  final allEvents = List<EventConfig>.from(baseballEvents)
    ..addAll(basketballEvents)
    ..addAll(collegeEvents)
    ..addAll(exoticEvents)
    ..addAll(footballEvents)
    ..addAll(hockeyEvents)
    ..addAll(soccerEvents);
  return allEvents;
}

/// [EventConfig] extensions.
extension EventConfigX on EventConfig {
  String eventName(EventType eventType) =>
      '$eventName ${eventType.name.capitalize()} Event';
}
