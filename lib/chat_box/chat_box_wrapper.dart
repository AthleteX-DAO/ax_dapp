import 'package:ax_dapp/chat_box/views/chat_box.dart';
import 'package:flutter/material.dart';

class ChatBoxWrapper extends StatelessWidget {
  const ChatBoxWrapper({
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
        ],
      ),
    );
  }
}
