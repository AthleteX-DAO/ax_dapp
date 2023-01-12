import 'dart:async';

import 'package:ax_dapp/chat_box/enums/message_type.dart';
import 'package:ax_dapp/chat_box/repository/chat_gpt_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';

part 'chat_box_event.dart';
part 'chat_box_state.dart';

class ChatBoxBloc extends Bloc<ChatBoxEvent, ChatBoxState> {
  ChatBoxBloc({
    required ChatGPTRepository chatGPTRepository,
  })  : _chatGPTRepository = chatGPTRepository,
        super(const ChatBoxState()) {
    on<SendMessage>(_onSendMessage);
  }

  final ChatGPTRepository _chatGPTRepository;

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatBoxState> emit,
  ) async {
    final input = event.prompt.trim();
    final List<String> messages;
    try {
      messages = List.from(state.messages)..insert(0, input);
      emit(
        state.copyWith(
          status: BlocStatus.loading,
          messageType: MessageType.user,
          messages: messages,
        ),
      );
      final botMessage = await _chatGPTRepository.fetchBotResponse(input);
      messages.insert(0, botMessage);
      emit(
        state.copyWith(
          status: BlocStatus.success,
          chatResponse: botMessage,
          messageType: MessageType.bot,
          messages: messages,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.noData));
    }
  }
}
