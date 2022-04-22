
import 'package:ax_dapp/service/BlockchainModels/Token.dart';
import 'package:json_annotation/json_annotation.dart';

part 'AptPair.g.dart';

@JsonSerializable()
class AptPair {
  final String id, name, reserve0, reserve1;
  final Token token0, token1;

  AptPair(this.id, this.name, this.reserve0, this.reserve1, this.token0, this.token1);

  Map<String, dynamic> toJson() => _$AptPairToJson(this);

  factory AptPair.fromJson(Map<String, dynamic> json) =>
      _$AptPairFromJson(json);

}