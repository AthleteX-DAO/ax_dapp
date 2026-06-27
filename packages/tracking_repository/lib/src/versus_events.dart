import 'package:tracking_repository/src/track_event.dart';

/// Events for the Versus page
class VersusTrackingEvent extends TrackEvent {
  /// Tracks when a user views a versus matchup
  VersusTrackingEvent.onVersusMatchView(
    Map<String, dynamic> params,
  ) : super(name: 'versus_match_view', params: params);

  /// Tracks when a user casts a vote for an athlete
  VersusTrackingEvent.onVersusVoteCast(
    Map<String, dynamic> params,
  ) : super(name: 'versus_vote_cast', params: params);

  /// Tracks when a user sends a message in the versus chat
  VersusTrackingEvent.onVersusChatSent(
    Map<String, dynamic> params,
  ) : super(name: 'versus_chat_sent', params: params);

  /// Tracks when a user shares an athlete card
  VersusTrackingEvent.onVersusShareCard(
    Map<String, dynamic> params,
  ) : super(name: 'versus_share_card', params: params);
}
