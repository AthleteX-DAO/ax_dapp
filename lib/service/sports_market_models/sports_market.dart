import 'package:json_annotation/json_annotation.dart';

abstract class SportsMarket {
  const SportsMarket(
    this.id,
    this.name,
  );

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
}
