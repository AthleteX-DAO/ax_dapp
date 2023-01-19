import 'package:ax_dapp/chat_box/enums/message_type.dart';
import 'package:ax_dapp/chat_box/widgets/message_box.dart';
import 'package:ax_dapp/live_chat_box/bloc/live_chat_box_bloc.dart';
import 'package:ax_dapp/live_chat_box/repository/live_chat_repository.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveChatBox extends StatefulWidget {
  const LiveChatBox({super.key});

  @override
  State<LiveChatBox> createState() => _LiveChatBoxState();
}

class _LiveChatBoxState extends State<LiveChatBox> {
  final _inputController = TextEditingController();

  double get _size => 45;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => LiveChatBoxBloc(
          liveChatRepository: context.read<LiveChatRepository>(),
        ),
        child: BlocBuilder<LiveChatBoxBloc, LiveChatBoxState>(
          builder: (context, state) {
            final bloc = context.read<LiveChatBoxBloc>();
            final toggle = state.toggle;
            return Positioned(
              left: 10,
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('livechat')
                            .doc('1')
                            .collection('comments')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return Container(
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
                                    itemCount: snapshot.data?.docs.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return MessageBox(
                                        message: snapshot.data?.docs[index]
                                            ['message'] as String,
                                        messageType: MessageType.user,
                                      );
                                    },
                                  ),
                                ),
                                const Divider(
                                  thickness: 2,
                                  color: Colors.white,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: _inputController,
                                          onSubmitted: (value) {
                                            bloc.add(
                                              SendMessage(
                                                message: _inputController.text,
                                              ),
                                            );
                                            _inputController.clear();
                                          },
                                          decoration:
                                              const InputDecoration.collapsed(
                                            hintText:
                                                'Chat with the community!',
                                            hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        color: Colors.white,
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          bloc.add(
                                            SendMessage(
                                              message: _inputController.text,
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
                          );
                        },
                      ),
                    ),
                  Positioned(
                    left: 0,
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
                          onPressed: () => bloc.add(ToggleLiveChat()),
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
