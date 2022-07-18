import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  Token(this.id, this.name, this.symbol);

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  final String id, name;
  final String? symbol;

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
