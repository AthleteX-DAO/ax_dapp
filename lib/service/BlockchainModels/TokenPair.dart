
import 'package:ax_dapp/service/BlockchainModels/Token.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TokenPair.g.dart';

@JsonSerializable()
class TokenPair {
  final String id, name, reserve0, reserve1, token0Price, token1Price;
  final Token token0, token1;

  TokenPair(this.id, this.name, this.reserve0, this.reserve1, this.token0, this.token1, this.token0Price, this.token1Price);

  Map<String, dynamic> toJson() => _$TokenPairToJson(this);

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);

}