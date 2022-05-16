import 'package:json_annotation/json_annotation.dart';

part 'Token.g.dart';

@JsonSerializable()
class Token {
  final String id, name;
  final String? symbol;
  Token(this.id, this.name, this.symbol);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
}
