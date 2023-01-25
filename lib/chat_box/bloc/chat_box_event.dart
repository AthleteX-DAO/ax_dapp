part of 'chat_box_bloc.dart';

abstract class ChatBoxEvent extends Equatable {
  const ChatBoxEvent();

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatBoxEvent {
  const SendMessage({
    required this.prompt,
  });

  final String prompt;

  @override
  List<Object> get props => [prompt];
}

class ToggleChatBox extends ChatBoxEvent {
  const ToggleChatBox();
}
