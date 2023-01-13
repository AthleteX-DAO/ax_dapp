import 'package:ax_dapp/chat_box/bloc/chat_box_bloc.dart';
import 'package:ax_dapp/chat_box/repository/chat_gpt_repository.dart';
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

  double get _size => 45;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) =>
            ChatBoxBloc(chatGPTRepository: context.read<ChatGPTRepository>()),
        child: BlocBuilder<ChatBoxBloc, ChatBoxState>(
          builder: (context, state) {
            final bloc = context.read<ChatBoxBloc>();
            final messages = state.messages;
            final toggle = state.toggle;
            return Positioned(
              right: 10,
              bottom: 10,
              width: toggle ? 250 : _size,
              height: toggle ? 600 : _size,
              child: Stack(
                children: [
                  if (toggle)
                    Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        height: 500,
                        width: 250,
                        decoration: boxDecoration(
                          Colors.grey[900]!,
                          30,
                          0,
                          Colors.black,
                        ),
                        child: Column(
                          children: [
                            Flexible(
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                reverse: true,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return MessageBox(
                                    message: messages[index].message,
                                    messageType: messages[index].messageType,
                                  );
                                },
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                              color: Colors.white,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      controller: _inputController,
                                      onSubmitted: (value) {
                                        bloc.add(SendMessage(prompt: value));
                                        _inputController.clear();
                                      },
                                      decoration:
                                          const InputDecoration.collapsed(
                                        hintText: 'Ask AX!',
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      bloc.add(
                                        SendMessage(
                                          prompt: _inputController.text,
                                        ),
                                      );
                                      _inputController.clear();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    width: _size,
                    height: _size,
                    child: Center(
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.amber,
                        child: IconButton(
                          color: Colors.black,
                          onPressed: () => bloc.add(const ToggleChatBox()),
                          icon: toggle
                              ? const Icon(Icons.close)
                              : const Icon(Icons.chat),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
