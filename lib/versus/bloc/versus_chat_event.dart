part of 'versus_chat_bloc.dart';

/// Base class for chat events
sealed class VersusChatEvent extends Equatable {
  const VersusChatEvent();

  @override
  List<Object?> get props => [];
}

/// Start watching chat messages for the matchup
final class WatchMessagesStarted extends VersusChatEvent {
  const WatchMessagesStarted();
}

/// Send a new chat message
final class SendMessageRequested extends VersusChatEvent {
  const SendMessageRequested({
    required this.walletAddress,
    required this.message,
    this.votedFor,
  });

  final String walletAddress;
  final String message;
  final int? votedFor;

  @override
  List<Object?> get props => [walletAddress, message, votedFor];
}

/// Like a chat message
final class LikeMessageRequested extends VersusChatEvent {
  const LikeMessageRequested({
    required this.messageId,
  });

  final String messageId;

  @override
  List<Object?> get props => [messageId];
}

/// Delete a chat message
final class DeleteMessageRequested extends VersusChatEvent {
  const DeleteMessageRequested({
    required this.messageId,
    required this.walletAddress,
  });

  final String messageId;
  final String walletAddress;

  @override
  List<Object?> get props => [messageId, walletAddress];
}
