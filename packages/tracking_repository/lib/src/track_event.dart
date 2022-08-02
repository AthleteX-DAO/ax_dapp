/// Used to identify and track events
abstract class TrackEvent {
  /// Default constructor
  TrackEvent(
    this.name,
    Map<String, dynamic>? params,
  ) : params = params ?? {};

  /// name of the event
  final String name;
  /// name of the parameters for each event
  Map<String, dynamic> params;

  /// different tracking services may different event requirements
  /// may be extended to have type/(screen/action)/role/...
}
