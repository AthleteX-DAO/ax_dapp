import 'package:json_annotation/json_annotation.dart';

part 'choices.g.dart';

@JsonSerializable()
class Choice {
  Choice({
    required this.text,
    required this.index,
    required this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
  
  final String text;
  final int index;
  @JsonKey(name: 'finish_reason')
  final String finishReason;

  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}
