import 'package:ax_dapp/util/user_input_norm.dart';

class UserInputInfo {
  UserInputInfo(this.rawAmount, this.viewAmount);

  factory UserInputInfo.fromInput({
    required String inputAmount,
    required int decimals,
  }) {
    final rawAmount = getRawAmount(inputAmount, decimals);
    return UserInputInfo(rawAmount, inputAmount);
  }

  factory UserInputInfo.fromBalance({
    required BigInt rawAmount,
    required int decimals,
  }) {
    final viewAmount = getViewAmount(rawAmount, decimals);
    return UserInputInfo(rawAmount, viewAmount);
  }

  final BigInt rawAmount;
  final String viewAmount;
}
