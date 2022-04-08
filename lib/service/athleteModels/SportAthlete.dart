import 'package:json_annotation/json_annotation.dart';

abstract class SportAthlete {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "team")
  final String team;
  @JsonKey(name: "position")
  final String position;
  @JsonKey(name: "price")
  final double price;
  @JsonKey(name: "timeStamp")
  final String timeStamp;

  const SportAthlete(
       this.id,
       this.name,
       this.team,
       this.position,
       this.price,
       this.timeStamp);
}
