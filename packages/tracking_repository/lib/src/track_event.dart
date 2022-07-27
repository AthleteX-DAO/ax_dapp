/// Used to identify and track events
abstract class TrackEvent {
  /// Default constructor
  TrackEvent(
    this.name,
  );

  /// name of the event
  final String name;

  /// different tracking services may different event requirements
  /// may be extended to have type/(screen/action)/role/...
}
