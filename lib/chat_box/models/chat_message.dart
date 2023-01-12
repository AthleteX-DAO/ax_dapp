import 'package:ax_dapp/chat_box/enums/message_type.dart';

class ChatMessage {
  ChatMessage({
    required this.message,
    required this.messageType,
  });

  final String message;
  final MessageType messageType;
}
