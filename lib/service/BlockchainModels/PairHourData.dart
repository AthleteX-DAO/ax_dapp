import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PairHourData.g.dart';

@JsonSerializable()
class PairHourData {
  PairHourData(this.hourStartUnix, this.reserve0, this.reserve1, this.pair);

  factory PairHourData.fromJson(Map<String, dynamic> json) =>
      _$PairHourDataFromJson(json);

  final int hourStartUnix;
  final String reserve0;
  final String reserve1;
  final TokenPair pair;

  Map<String, dynamic> toJson() => _$PairHourDataToJson(this);
}
