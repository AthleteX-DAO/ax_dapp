import 'package:json_annotation/json_annotation.dart';

part 'player_ids.g.dart';

@JsonSerializable()
class PlayerIds {
  PlayerIds(this.playerIds);

  factory PlayerIds.fromJson(Map<String, dynamic> json) =>
      _$PlayerIdsFromJson(json);

  @JsonKey(name: 'ids')
  final List<int> playerIds;

  Map<String, dynamic> toJson() => _$PlayerIdsToJson(this);
}
