import 'package:ax_dapp/util/UserInputNorm.dart';

class UserInputInfo {
  final BigInt rawAmount;
  final String viewAmount;

  UserInputInfo(BigInt rawAmount, String viewAmount)
      : this.rawAmount = rawAmount,
        this.viewAmount = viewAmount;

  factory UserInputInfo.fromBalance(
      {required BigInt rawAmount, required int decimals}) {
    final String viewAmount = getViewAmount(rawAmount, decimals);
    return UserInputInfo(rawAmount, viewAmount);
  }

  factory UserInputInfo.fromInput(
      {required String inputAmount, required int decimals}) {
    final BigInt rawAmount = getRawAmount(inputAmount, decimals);
    return UserInputInfo(rawAmount, inputAmount);
  }
}
