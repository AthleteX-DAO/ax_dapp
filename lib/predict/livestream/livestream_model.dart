import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum StreamSource { youtube, twitch, custom }

class LiveStreamModel extends Equatable {
  const LiveStreamModel({
    required this.id,
    required this.title,
    required this.url,
    required this.source,
    required this.sport,
    this.thumbnailUrl,
    this.isLive = false,
    this.isFeatured = false,
    this.scheduledAt,
    this.marketId,
    this.metadata = const {},
  });

  final String id;
  final String title;
  final String url;
  final StreamSource source;
  final String sport;
  final String? thumbnailUrl;
  final bool isLive;
  final bool isFeatured;
  final DateTime? scheduledAt;
  final String? marketId;
  final Map<String, String> metadata;

  /// Converts a raw YouTube/Twitch URL to an embeddable URL.
  String get embedUrl {
    switch (source) {
      case StreamSource.youtube:
        // Handle youtube.com/watch?v=ID, youtu.be/ID, youtube.com/live/ID
        final uri = Uri.tryParse(url);
        if (uri == null) return url;
        String? videoId;
        if (uri.host.contains('youtu.be')) {
          videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
        } else if (uri.queryParameters.containsKey('v')) {
          videoId = uri.queryParameters['v'];
        } else if (uri.pathSegments.contains('live') &&
            uri.pathSegments.length > 1) {
          videoId = uri.pathSegments.last;
        } else if (uri.pathSegments.contains('embed') &&
            uri.pathSegments.length > 1) {
          return url; // Already embed URL
        }
        if (videoId != null) {
          return 'https://www.youtube.com/embed/$videoId?autoplay=1&mute=1';
        }
        return url;
      case StreamSource.twitch:
        final uri = Uri.tryParse(url);
        if (uri == null) return url;
        // Handle twitch.tv/channelName
        if (uri.host.contains('twitch.tv') && uri.pathSegments.isNotEmpty) {
          final channel = uri.pathSegments.first;
          return 'https://player.twitch.tv/?channel=$channel&parent=${Uri.base.host}&muted=true';
        }
        return url;
      case StreamSource.custom:
        return url;
    }
  }

  /// Auto-generate thumbnail for YouTube if none provided.
  String? get effectiveThumbnail {
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) return thumbnailUrl;
    if (source == StreamSource.youtube) {
      final uri = Uri.tryParse(url);
      if (uri == null) return null;
      String? videoId;
      if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      } else if (uri.queryParameters.containsKey('v')) {
        videoId = uri.queryParameters['v'];
      }
      if (videoId != null) {
        return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
      }
    }
    return null;
  }

  factory LiveStreamModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return LiveStreamModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      url: data['url'] as String? ?? '',
      source: StreamSource.values.firstWhere(
        (s) => s.name == (data['source'] as String? ?? 'custom'),
        orElse: () => StreamSource.custom,
      ),
      sport: data['sport'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String?,
      isLive: data['isLive'] as bool? ?? false,
      isFeatured: data['isFeatured'] as bool? ?? false,
      scheduledAt: (data['scheduledAt'] as Timestamp?)?.toDate(),
      marketId: data['marketId'] as String?,
      metadata: (data['metadata'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          const {},
    );
  }

  static const empty = LiveStreamModel(
    id: '',
    title: '',
    url: '',
    source: StreamSource.custom,
    sport: '',
  );

  @override
  List<Object?> get props => [
        id,
        title,
        url,
        source,
        sport,
        thumbnailUrl,
        isLive,
        isFeatured,
        scheduledAt,
        marketId,
        metadata,
      ];
}
