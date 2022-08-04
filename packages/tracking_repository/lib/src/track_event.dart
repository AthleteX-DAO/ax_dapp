/// Used to identify and track events
abstract class TrackEvent {
  /// Default constructor
  TrackEvent({
    required this.name,
    required this.params,
  });

  /// name of the event
  final String name;

  /// name of the parameters for each event
  final Map<String, dynamic> params;

/// different tracking services may different event requirements
/// may be extended to have type/(screen/action)/role/...
}
