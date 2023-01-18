import 'dart:convert';
import 'package:ax_dapp/chat_box/models/chat_response.dart';
import 'package:ax_dapp/openai_key.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatGPTRepository {
  final baseUrl = 'https://api.openai.com/v1/completions';

  Future<ChatResponse> fetchBotResponse(String prompt) async {
    final uri = Uri.parse(baseUrl);
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': prompt,
          'temperature': 0,
          'max_tokens': 2000,
          'top_p': 1,
          'frequency_penalty': 0.0,
          'presence_penalty': 0.0,
        }),
      );
      final data = json.decode(response.body);
      final chatResponse = ChatResponse.fromJson(data as Map<String, dynamic>);
      return chatResponse;
    } catch (e) {
      debugPrint('Failed to fetch data -> $e');
      return ChatResponse.empty;
    }
  }
}
