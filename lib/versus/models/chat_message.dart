import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Represents a chat message in a versus matchup
class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.walletAddress,
    required this.message,
    required this.timestamp,
    this.votedFor,
    this.likes = 0,
  });

  final String id;
  final String walletAddress;
  final String message;
  final DateTime timestamp;
  final int? votedFor; // null = no vote, otherwise athleteId voted for
  final int likes;

  /// Truncate wallet address for display (0x1234...5678)
  String get truncatedAddress {
    if (walletAddress.length <= 10) return walletAddress;
    return '${walletAddress.substring(0, 6)}...${walletAddress.substring(walletAddress.length - 4)}';
  }

  /// Format timestamp for display
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  ChatMessage copyWith({
    String? id,
    String? walletAddress,
    String? message,
    DateTime? timestamp,
    int? votedFor,
    int? likes,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      walletAddress: walletAddress ?? this.walletAddress,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      votedFor: votedFor ?? this.votedFor,
      likes: likes ?? this.likes,
    );
  }

  /// Create from Firestore document
  factory ChatMessage.fromJson(Map<String, dynamic> json, String docId) {
    return ChatMessage(
      id: docId,
      walletAddress: json['walletAddress'] as String,
      message: json['message'] as String,
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      votedFor: json['votedFor'] as int?,
      likes: json['likes'] as int? ?? 0,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'walletAddress': walletAddress,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'votedFor': votedFor,
      'likes': likes,
    };
  }

  @override
  List<Object?> get props => [
        id,
        walletAddress,
        message,
        timestamp,
        votedFor,
        likes,
      ];
}
