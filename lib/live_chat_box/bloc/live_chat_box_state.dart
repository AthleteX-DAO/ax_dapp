part of 'live_chat_box_bloc.dart';

class LiveChatBoxState extends Equatable {
  const LiveChatBoxState({
    this.status = BlocStatus.initial,
    this.chatResponse = '',
    this.messages = const [],
    this.toggle = false,
  });

  final BlocStatus status;
  final String chatResponse;
  final List<ChatMessage> messages;
  final bool toggle;

  LiveChatBoxState copyWith({
    BlocStatus? status,
    String? chatResponse,
    List<ChatMessage>? messages,
    bool? toggle,
  }) {
    return LiveChatBoxState(
      status: status ?? this.status,
      chatResponse: chatResponse ?? this.chatResponse,
      messages: messages ?? this.messages,
      toggle: toggle ?? this.toggle,
    );
  }

  @override
  List<Object> get props =>
      [status, chatResponse, messages, toggle];
}
