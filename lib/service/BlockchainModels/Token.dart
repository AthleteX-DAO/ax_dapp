import 'package:json_annotation/json_annotation.dart';

part 'Token.g.dart';

@JsonSerializable()
class Token {
  final String id, name;
  Token(this.id, this.name);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  factory Token.fromJson(Map<String, dynamic> json) =>
      _$TokenFromJson(json);
}