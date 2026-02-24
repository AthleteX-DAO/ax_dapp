part of 'versus_chat_bloc.dart';

/// Status of chat state
enum ChatStatus {
  initial,
  loading,
  loaded,
  sending,
  error,
}

/// State for versus chat
final class VersusChatState extends Equatable {
  const VersusChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.errorMessage,
    this.lastMessageSent,
  });

  final ChatStatus status;
  final List<ChatMessage> messages;
  final String? errorMessage;
  final DateTime? lastMessageSent;

  VersusChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    String? errorMessage,
    DateTime? lastMessageSent,
  }) {
    return VersusChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
      lastMessageSent: lastMessageSent ?? this.lastMessageSent,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        errorMessage,
        lastMessageSent,
      ];
}
