import 'package:json_annotation/json_annotation.dart';

part 'PlayerIds.g.dart';

@JsonSerializable()
class PlayerIds {
  @JsonKey(name: "ids")
  final List<int> playerIds;

  factory PlayerIds.fromJson(Map<String, dynamic> json) =>
      _$PlayerIdsFromJson(json);

  PlayerIds(this.playerIds);

  Map<String, dynamic> toJson() => _$PlayerIdsToJson(this);
}
