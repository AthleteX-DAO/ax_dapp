import 'package:ax_dapp/service/blockchain_models/token_pair.dart';
import 'package:json_annotation/json_annotation.dart';

part 'liquidity_position.g.dart';

@JsonSerializable()
class LiquidityPosition {
  LiquidityPosition(this.pair, this.liquidityTokenBalance);

  factory LiquidityPosition.fromJson(Map<String, dynamic> json) =>
      _$LiquidityPositionFromJson(json);

  final String liquidityTokenBalance;
  final TokenPair pair;

  Map<String, dynamic> toJson() => _$LiquidityPositionToJson(this);
}
