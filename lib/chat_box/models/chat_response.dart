import 'package:ax_dapp/chat_box/models/choices.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_response.g.dart';

@JsonSerializable()
class ChatResponse {
  const ChatResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) => _$ChatResponseFromJson(json);

  static const empty = ChatResponse(
    id: '',
    object: '',
    created: 0,
    model: '',
    choices: [],
  );
  
  final String id;
  final String object;
  final int created;
  final String model;
  final List<Choice> choices;

  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);
}
