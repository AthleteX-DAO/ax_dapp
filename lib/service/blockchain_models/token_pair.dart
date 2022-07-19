import 'package:ax_dapp/service/blockchain_models/pair_hour_data.dart';
import 'package:ax_dapp/service/blockchain_models/token.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_pair.g.dart';

@JsonSerializable()
class TokenPair {
  TokenPair(
    this.id,
    this.name,
    this.reserve0,
    this.reserve1,
    this.token0,
    this.token1,
    this.token0Price,
    this.token1Price,
    this.totalSupply,
    this.pairHourData,
  );

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);

  final String id, name, token0Price, token1Price, reserve0, reserve1;
  final String? totalSupply;
  final Token token0, token1;
  final List<PairHourData>? pairHourData;

  Map<String, dynamic> toJson() => _$TokenPairToJson(this);
}
