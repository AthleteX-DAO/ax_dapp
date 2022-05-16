
import 'package:json_annotation/json_annotation.dart';

import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';

part 'LiquidityPosition.g.dart';

@JsonSerializable()
class LiquidityPosition {
  final String liquidityTokenBalance;
  final TokenPair pair;
  
  LiquidityPosition(
    this.pair,
    this.liquidityTokenBalance);

  Map<String, dynamic> toJson() => _$LiquidityPositionToJson(this);

  factory LiquidityPosition.fromJson(Map<String, dynamic> json) =>
      _$LiquidityPositionFromJson(json);

}
