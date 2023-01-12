import 'package:shared/shared.dart';

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
  
  final String id;
  final String object;
  final int created;
  final String model;
  final List<String> choices;

  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);

  static const empty = ChatResponse(
    id: '',
    object: '',
    created: 0,
    model: '',
    choices: [],
  );
}
