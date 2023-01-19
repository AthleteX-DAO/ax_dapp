part of 'live_chat_box_bloc.dart';

abstract class LiveChatBoxEvent extends Equatable {
  const LiveChatBoxEvent();

  @override
  List<Object> get props => [];
}

class SendMessage extends LiveChatBoxEvent {
  const SendMessage({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

class ToggleLiveChat extends LiveChatBoxEvent {}
