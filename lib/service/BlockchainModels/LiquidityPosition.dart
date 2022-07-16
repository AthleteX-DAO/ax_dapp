import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:json_annotation/json_annotation.dart';

part 'LiquidityPosition.g.dart';

@JsonSerializable()
class LiquidityPosition {
  LiquidityPosition(this.pair, this.liquidityTokenBalance);

  factory LiquidityPosition.fromJson(Map<String, dynamic> json) =>
      _$LiquidityPositionFromJson(json);

  final String liquidityTokenBalance;
  final TokenPair pair;

  Map<String, dynamic> toJson() => _$LiquidityPositionToJson(this);
}
