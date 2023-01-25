import 'package:ax_dapp/chat_box/views/chat_box.dart';
import 'package:ax_dapp/live_chat_box/views/live_chat_box.dart';
import 'package:flutter/material.dart';

class ChatWrapper extends StatelessWidget {
  const ChatWrapper({
    required this.home,
    super.key,
  });

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          home,
          const ChatBox(),
          const LiveChatBox(),
        ],
      ),
    );
  }
}
