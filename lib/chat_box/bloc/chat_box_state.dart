part of 'chat_box_bloc.dart';

class ChatBoxState extends Equatable {
  const ChatBoxState({
    this.status = BlocStatus.initial,
    this.chatResponse = '',
    this.messageType = MessageType.user,
    this.messages = const [],
  });

  final BlocStatus status;
  final String chatResponse;
  final MessageType messageType;
  final List<String> messages;

  ChatBoxState copyWith({
    BlocStatus? status,
    String? chatResponse,
    MessageType? messageType,
    List<String>? messages,
  }) {
    return ChatBoxState(
      status: status ?? this.status,
      chatResponse: chatResponse ?? this.chatResponse,
      messageType: messageType ?? this.messageType,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [status, chatResponse, messageType, messages];
}
