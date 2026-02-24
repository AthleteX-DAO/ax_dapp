import 'package:ax_dapp/versus/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for managing versus matchup chat messages
class VersusChatRepository {
  const VersusChatRepository({
    required FirebaseFirestore fireStore,
  }) : _fireStore = fireStore;

  final FirebaseFirestore _fireStore;

  static const String _chatCollection = 'versus_chat';
  static const int _messageLimit = 100;

  /// Single global chat room ID — all markets share one chat
  static const String _globalChatId = 'global';

  /// Ensure global chat document exists in Firestore
  Future<void> _ensureMatchupDocExists(String matchId) async {
    try {
      print('[VersusChatRepo] Ensuring global chat doc exists (using id: $_globalChatId)');
      final docRef = _fireStore.collection(_chatCollection).doc(_globalChatId);
      final doc = await docRef.get();
      if (!doc.exists) {
        print('[VersusChatRepo] Creating global chat doc');
        await docRef.set({
          'createdAt': FieldValue.serverTimestamp(),
          'chatId': _globalChatId,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('[VersusChatRepo] Failed to ensure doc exists: $e');
      // Silent fail - if document creation fails, let message send fail instead
    }
  }

  /// Get chat messages from the global chat room
  Stream<List<ChatMessage>> getChatMessages(String matchId) {
    print('[VersusChatRepo] Subscribing to global chat messages (ignoring matchId: $matchId)');
    // Always use global chat room regardless of matchId
    _ensureMatchupDocExists(_globalChatId);
    
    return _fireStore
        .collection(_chatCollection)
        .doc(_globalChatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(_messageLimit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatMessage.fromJson(doc.data(), doc.id),
              )
              .toList(),
        );
  }

  /// Send a chat message
  Future<void> sendMessage({
    required String matchId,
    required String walletAddress,
    required String message,
    int? votedFor,
  }) async {
    try {
      // Validate message
      if (message.trim().isEmpty) {
        throw Exception('Message cannot be empty');
      }

      if (message.length > 280) {
        throw Exception('Message too long (max 280 characters)');
      }

      print('[VersusChatRepo] Sending message to global chat: wallet=$walletAddress, msg=${message.trim()}');

      // Always write to global chat room
      await _ensureMatchupDocExists(_globalChatId);

      final chatMessage = ChatMessage(
        id: '', // Firestore will generate
        walletAddress: walletAddress,
        message: message.trim(),
        timestamp: DateTime.now(),
        votedFor: votedFor,
      );

      await _fireStore
          .collection(_chatCollection)
          .doc(_globalChatId)
          .collection('messages')
          .add(chatMessage.toJson());
      print('[VersusChatRepo] Message sent successfully to global chat');
    } catch (e) {
      print('[VersusChatRepo] Failed to send message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  /// Like a message (increment like count)
  Future<void> likeMessage({
    required String matchId,
    required String messageId,
  }) async {
    try {
      print('[VersusChatRepo] Liking message $messageId in global chat');
      final messageRef = _fireStore
          .collection(_chatCollection)
          .doc(_globalChatId)
          .collection('messages')
          .doc(messageId);

      await _fireStore.runTransaction((transaction) async {
        final snapshot = await transaction.get(messageRef);
        if (!snapshot.exists) {
          throw Exception('Message not found');
        }

        final currentLikes = snapshot.data()?['likes'] as int? ?? 0;
        transaction.update(messageRef, {'likes': currentLikes + 1});
      });
    } catch (e) {
      throw Exception('Failed to like message: $e');
    }
  }

  /// Delete a message (only if user owns it)
  Future<void> deleteMessage({
    required String matchId,
    required String messageId,
    required String walletAddress,
  }) async {
    try {
      print('[VersusChatRepo] Deleting message $messageId from global chat (wallet=$walletAddress)');
      final messageRef = _fireStore
          .collection(_chatCollection)
          .doc(_globalChatId)
          .collection('messages')
          .doc(messageId);

      final snapshot = await messageRef.get();
      if (!snapshot.exists) {
        throw Exception('Message not found');
      }

      final messageData = snapshot.data();
      if (messageData?['walletAddress'] != walletAddress) {
        throw Exception('Cannot delete another user\'s message');
      }

      await messageRef.delete();
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  /// Get message count from the global chat room
  Future<int> getMessageCount(String matchId) async {
    try {
      print('[VersusChatRepo] Getting global chat message count');
      final snapshot = await _fireStore
          .collection(_chatCollection)
          .doc(_globalChatId)
          .collection('messages')
          .count()
          .get();

      final count = snapshot.count ?? 0;
      print('[VersusChatRepo] Global chat message count: $count');
      return count;
    } catch (e) {
      print('[VersusChatRepo] Failed to get message count: $e');
      return 0;
    }
  }
}
