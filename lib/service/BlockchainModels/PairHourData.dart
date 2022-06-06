import 'package:json_annotation/json_annotation.dart';
import 'package:ax_dapp/service/BlockchainModels/TokenPair.dart';

part 'PairHourData.g.dart';

@JsonSerializable()
class PairHourData {
  final int hourStartUnix;
  final TokenPair pair;
  PairHourData(this.hourStartUnix, this.pair);

  Map<String, dynamic> toJson() => _$PairHourDataToJson(this);

  factory PairHourData.fromJson(Map<String, dynamic> json) =>
      _$PairHourDataFromJson(json);
}