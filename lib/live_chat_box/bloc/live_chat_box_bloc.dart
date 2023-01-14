import 'dart:async';

import 'package:ax_dapp/live_chat_box/models/chat_message.dart';
import 'package:ax_dapp/live_chat_box/repository/live_chat_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'live_chat_box_event.dart';
part 'live_chat_box_state.dart';

class LiveChatBoxBloc extends Bloc<LiveChatBoxEvent, LiveChatBoxState> {
  LiveChatBoxBloc({
    required LiveChatRepository liveChatRepository,
  })  : _liveChatRepository = liveChatRepository,
        super(const LiveChatBoxState()) {
    on<SendMessage>(_onSendMessage);
    on<ToggleLiveChat>(_onToggleLiveChat);
  }

  final LiveChatRepository _liveChatRepository;

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<LiveChatBoxState> emit,
  ) async {
    final input = event.message;
    try {
      await _liveChatRepository.sendMessage(input);
      emit(state.copyWith(status: BlocStatus.success));
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.noData));
    }
  }

  Future<void> _onToggleLiveChat(
    ToggleLiveChat event,
    Emitter<LiveChatBoxState> emit,
  ) async {
    emit(state.copyWith(toggle: !state.toggle));
  }
}
