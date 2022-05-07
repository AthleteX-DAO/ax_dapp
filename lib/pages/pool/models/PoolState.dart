import 'package:ax_dapp/pages/pool/models/PoolPairInfo.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/TokenList.dart' show TokenList, tokenList;
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:equatable/equatable.dart';

class PoolState extends Equatable {
  final PoolPairInfo pairInfo;
  final double shareOfPoolPercentage;
  final double expectedYield;
  final double balance0;
  final double balance1;
  final Token? token0;
  final Token? token1;
  final BlocStatus status;

  PoolState(
      {this.status = BlocStatus.initial,
      Token? token0,
      Token? token1,
      PoolPairInfo? pairInfo,
      double? balance0,
      double? balance1,
      double? shareOfPoolPercentage,
      double? expectedYield})
      : pairInfo = pairInfo ?? PoolPairInfo(),
        token0 = token0 ?? TokenList.tokenList[0],
        token1 = token1 ?? TokenList.tokenList[1],
        balance0 = balance0 ?? 0.0,
        balance1 = balance1 ?? 0.0,
        shareOfPoolPercentage = shareOfPoolPercentage ?? 0.0,
        expectedYield = expectedYield ?? 0.0;

  @override
  List<Object?> get props =>
      [pairInfo, token0, token1, shareOfPoolPercentage, expectedYield, status];

  PoolState copy(
      {BlocStatus? status,
      Token? token0,
      Token? token1,
      PoolPairInfo? pairInfo,
      double? shareOfPoolPercentage,
      double? expectedYield,
      double? balance0,
      double? balance1}) {
    return PoolState(
      status: status ?? BlocStatus.initial,
      token0: token0 ?? this.token0,
      token1: token1 ?? this.token1,
      pairInfo: pairInfo ?? this.pairInfo,
      shareOfPoolPercentage:
          shareOfPoolPercentage ?? this.shareOfPoolPercentage,
      expectedYield: expectedYield ?? this.expectedYield,
      balance0: balance0 ?? this.balance0,
      balance1: balance1 ?? this.balance1,
    );
  }
}
