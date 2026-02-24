import 'package:ax_dapp/versus/models/chat_message.dart';
import 'package:ax_dapp/versus/repository/versus_chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'versus_chat_event.dart';
part 'versus_chat_state.dart';

/// BLoC for managing versus matchup chat
class VersusChatBloc extends Bloc<VersusChatEvent, VersusChatState> {
  VersusChatBloc({
    required VersusChatRepository chatRepository,
    required String matchId,
  })  : _chatRepository = chatRepository,
        _matchId = matchId,
        super(const VersusChatState()) {
    on<WatchMessagesStarted>(_onWatchMessagesStarted);
    on<SendMessageRequested>(_onSendMessageRequested);
    on<LikeMessageRequested>(_onLikeMessageRequested);
    on<DeleteMessageRequested>(_onDeleteMessageRequested);
  }

  final VersusChatRepository _chatRepository;
  final String _matchId;

  Future<void> _onWatchMessagesStarted(
    WatchMessagesStarted event,
    Emitter<VersusChatState> emit,
  ) async {
    print('[VersusChatBloc] WatchMessagesStarted (matchId=$_matchId -> global chat)');
    emit(state.copyWith(status: ChatStatus.loading));

    try {
      await emit.onEach<List<ChatMessage>>(
        _chatRepository.getChatMessages(_matchId),
        onData: (messages) {
          print('[VersusChatBloc] Received ${messages.length} messages from global chat');
          emit(
            state.copyWith(
              status: ChatStatus.loaded,
              messages: messages,
            ),
          );
        },
        onError: (error, stackTrace) {
          print('[VersusChatBloc] Error loading messages: $error');
          emit(
            state.copyWith(
              status: ChatStatus.error,
              errorMessage: error.toString(),
            ),
          );
        },
      );
    } catch (e) {
      print('[VersusChatBloc] Stream subscription failed: $e');
      emit(
        state.copyWith(
          status: ChatStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<VersusChatState> emit,
  ) async {
    print('[VersusChatBloc] SendMessage requested: wallet=${event.walletAddress.isEmpty ? "(not connected)" : event.walletAddress}, msg="${event.message}"');

    // Require wallet connection to chat
    if (event.walletAddress.isEmpty) {
      print('[VersusChatBloc] Send blocked — no wallet connected');
      emit(
        state.copyWith(
          status: ChatStatus.error,
          errorMessage: 'Connect your wallet to chat',
        ),
      );
      await Future<void>.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: ChatStatus.loaded, errorMessage: null));
      return;
    }

    // Check rate limiting (1 message per 3 seconds)
    final now = DateTime.now();
    if (state.lastMessageSent != null) {
      final timeSinceLastMessage = now.difference(state.lastMessageSent!);
      if (timeSinceLastMessage.inSeconds < 3) {
        final waitSeconds = 3 - timeSinceLastMessage.inSeconds;
        print('[VersusChatBloc] Rate limited — wait ${waitSeconds}s');
        emit(
          state.copyWith(
            status: ChatStatus.error,
            errorMessage:
                'Please wait $waitSeconds seconds before sending another message',
          ),
        );
        // Clear error after delay
        await Future<void>.delayed(const Duration(seconds: 2));
        emit(state.copyWith(status: ChatStatus.loaded, errorMessage: null));
        return;
      }
    }

    print('[VersusChatBloc] Sending message to global chat...');
    emit(state.copyWith(status: ChatStatus.sending));

    try {
      await _chatRepository.sendMessage(
        matchId: _matchId,
        walletAddress: event.walletAddress,
        message: event.message,
        votedFor: event.votedFor,
      );

      print('[VersusChatBloc] Message sent successfully');
      emit(
        state.copyWith(
          status: ChatStatus.loaded,
          lastMessageSent: now,
        ),
      );
    } catch (e) {
      print('[VersusChatBloc] Failed to send message: $e');
      emit(
        state.copyWith(
          status: ChatStatus.error,
          errorMessage: 'Failed to send message: $e',
        ),
      );
      
      // Clear error after delay
      await Future<void>.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: ChatStatus.loaded, errorMessage: null));
    }
  }

  Future<void> _onLikeMessageRequested(
    LikeMessageRequested event,
    Emitter<VersusChatState> emit,
  ) async {
    print('[VersusChatBloc] Like requested for message ${event.messageId}');
    try {
      await _chatRepository.likeMessage(
        matchId: _matchId,
        messageId: event.messageId,
      );
      print('[VersusChatBloc] Like succeeded for message ${event.messageId}');
    } catch (e) {
      print('[VersusChatBloc] Like failed (silent): $e');
      // Silently fail likes
    }
  }

  Future<void> _onDeleteMessageRequested(
    DeleteMessageRequested event,
    Emitter<VersusChatState> emit,
  ) async {
    print('[VersusChatBloc] Delete requested for message ${event.messageId} by wallet=${event.walletAddress}');
    try {
      await _chatRepository.deleteMessage(
        matchId: _matchId,
        messageId: event.messageId,
        walletAddress: event.walletAddress,
      );
      print('[VersusChatBloc] Message ${event.messageId} deleted');
    } catch (e) {
      print('[VersusChatBloc] Delete failed: $e');
      emit(
        state.copyWith(
          status: ChatStatus.error,
          errorMessage: 'Failed to delete message',
        ),
      );
      
      // Clear error after delay
      await Future<void>.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: ChatStatus.loaded, errorMessage: null));
    }
  }
}
