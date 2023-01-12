import 'package:ax_dapp/chat_box/bloc/chat_box_bloc.dart';
import 'package:ax_dapp/chat_box/widgets/message_box.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBoxBloc, ChatBoxState>(
      builder: (context, state) {
        final bloc = context.read<ChatBoxBloc>();
        final status = state.status;
        final chatResponse = state.chatResponse;
        final messages = state.messages;
        final messageType = state.messageType;
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 500,
            width: 250,
            decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
            child: Column(
              children: [
                Flexible(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageBox(
                        message: messages[index],
                        messageType: messageType,
                      );
                    },
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          onSubmitted: (value) {
                            bloc.add(SendMessage(prompt: value));
                            _inputController.clear();
                          },
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Ask AX!',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          bloc.add(SendMessage(prompt: _inputController.text));
                          _inputController.clear();
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
