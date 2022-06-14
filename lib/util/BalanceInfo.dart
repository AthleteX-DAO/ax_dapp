import 'package:ax_dapp/util/UserInputNorm.dart';

class BalanceInfo {
  final BigInt nWeiAmount;
  final double dFloorEthAmount;
  final String strFloorEthAmount;

  BalanceInfo(BigInt weiAmount)
      : this.nWeiAmount = weiAmount,
        this.dFloorEthAmount = getEtherValue(weiAmount),
        this.strFloorEthAmount = getEtherValue(weiAmount).toString();
}
