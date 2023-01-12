import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatGPTRepository {

  final baseUrl = 'https://api.openai.com/v1/completions';
  final apiKey = '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';

  Future<String> fetchBotResponse(String prompt) async {
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
      final res = jsonDecode(response.body);
      final botMessage =  res['choices'][0]['text'];
      return botMessage.toString();
      } catch(e) {
        debugPrint('Failed to fetch data -> $e');
        return '';
      }
  }
}
