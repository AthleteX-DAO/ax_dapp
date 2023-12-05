part of 'token.dart';

/// {@template event_market_pairs}
/// Represents an event market pair
/// {@endtemplate}
class EventPair extends Equatable {
  /// {@macro event_performance_pair}
  const EventPair({
    required this.yes,
    required this.no,
  });

  /// Represents [Event.yes].
  final Event yes;

  /// Represents [Event.no].
  final Event no;

  /// Represents an empty [EventPair].
  static const empty = EventPair(yes: Event.empty(), no: Event.empty());

  @override
  List<Object?> get props => [yes, no];
}
