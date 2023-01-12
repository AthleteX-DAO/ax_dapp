import 'package:ax_dapp/chat_box/bloc/chat_box_bloc.dart';
import 'package:ax_dapp/chat_box/enums/message_type.dart';
import 'package:ax_dapp/chat_box/widgets/message_box.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final _inputController = TextEditingController();
  // final List<MessageBox> _messages = [];

  // final apiKey = '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';

  // Future<String> generateResponse(String prompt) async {
  //   final uri = Uri.parse('https://api.openai.com/v1/completions');
  //   final response = await http.post(
  //     uri,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $apiKey',
  //     },
  //     body: jsonEncode({
  //       'model': 'text-davinci-003',
  //       'prompt': prompt,
  //       'temperature': 0,
  //       'max_tokens': 2000,
  //       'top_p': 1,
  //       'frequency_penalty': 0.0,
  //       'presence_penalty': 0.0,
  //     }),
  //   );

  //   final result = jsonDecode(response.body);
  //   final botMessage = result['choices'][0]['text'];
  //   return botMessage.toString();
  // }

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
                      return MessageBox(message: messages[index], messageType: messageType);
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

  // Future<void> _sendMessage() async {
  //   final userMessage = MessageBox(
  //     message: _inputController.text,
  //     messageType: MessageType.user,
  //   );
  //   setState(() {
  //     _messages.insert(0, userMessage);
  //   });
  //   final input = _inputController.text;
  //   _inputController.clear();
  //   debugPrint(
  //     'This is the message that is being sent back to the user: $chatGPTresponse',
  //   );
  //   final botMessage = MessageBox(
  //     message: chatGPTresponse,
  //     messageType: MessageType.bot,
  //   );
  //   setState(() {
  //     _messages.insert(0, botMessage);
  //   });
  // }
}
