import 'package:ax_dapp/chat_box/bloc/chat_box_bloc.dart';
import 'package:ax_dapp/chat_box/chat_box.dart';
import 'package:ax_dapp/chat_box/repository/chat_gpt_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectWalletButton extends StatelessWidget {
  const ConnectWalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var width = 180.0;
    var text = 'Connect Wallet';
    if (_width < 565) {
      width = 110;
      text = 'Connect';
    }

    return Container(
      height: 37.5,
      width: width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.amber[400]!, width: 2),
      ),
      child: TextButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (_) => BlocProvider(
              create: (context) => ChatBoxBloc(
                chatGPTRepository: context.read<ChatGPTRepository>(),),
                child: const ChatBox(),
            ),
          );
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.amber[400],
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
