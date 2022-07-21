/// Used to identify and track events
class TrackEvent {
  /// Constructor
  TrackEvent({
    required this.name,
  });

  /// name of the event
  final String name;

  /// different tracking services may different event requirements
  /// may be extended to have type/(screen/action)/role/...   
}

// /// Should be deleted after first events are implemented.
// /// Only for demo.
// class SomeFeature extends Event { 
//   SomeFeature.screenA() : super(name: 'Event name A');
//   SomeFeature.screenB() : super(name: 'Event name B');
// }
