import 'package:ax_dapp/chat_box/enums/message_type.dart';
import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.message,
    required this.messageType,
  });

  final String message;
  final MessageType messageType;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xff343541);
    const botBackgroundColor = Color(0xff444654);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      color:
          messageType == MessageType.bot ? botBackgroundColor : backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (messageType == MessageType.bot)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Image.asset(
                  'assets/images/x.png',
                  color: Colors.amber,
                  scale: 1.5,
                ),
              ),
            )
          else
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: const CircleAvatar(
                child: Icon(
                  Icons.person,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
