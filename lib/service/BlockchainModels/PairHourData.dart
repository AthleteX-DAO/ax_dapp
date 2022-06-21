import 'package:json_annotation/json_annotation.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';

part 'PairHourData.g.dart';

@JsonSerializable()
class PairHourData {
  final int hourStartUnix;
  final String reserve0;
  final String reserve1;
  final TokenPair pair;
  PairHourData(this.hourStartUnix, this.reserve0, this.reserve1, this.pair);

  Map<String, dynamic> toJson() => _$PairHourDataToJson(this);

  factory PairHourData.fromJson(Map<String, dynamic> json) =>
      _$PairHourDataFromJson(json);
}
