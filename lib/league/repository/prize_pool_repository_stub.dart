import 'package:ax_dapp/service/controller/controller.dart';
import 'package:get/get.dart';

/// Stubbed implementation for non-web platforms.
class PrizePoolRepository {
  PrizePoolRepository();

  Controller controller = Controller();

  RxString adminAddress = ''.obs;
  RxString prizePoolAddress = ''.obs;
  RxString winnerAddress = ''.obs;
  RxDouble entryFeeAmount = 0.0.obs;
  RxInt decimalA = 0.obs;

  double get entryAmount => entryFeeAmount.value;
  String get admin => adminAddress.value;
  String get contractAddress => prizePoolAddress.value;
  String get winner => winnerAddress.value;
  int get tokenDecimals => decimalA.value;

  set tokenDecimals(int decimal) => decimalA.value = decimal;
  set entryAmount(double newAmount) => entryFeeAmount.value = newAmount;
  set admin(String address) => adminAddress.value = address;
  set contractAddress(String newAddress) => prizePoolAddress.value = newAddress;
  set winner(String newWinnerAddress) => winnerAddress.value = newWinnerAddress;

  Future<T> _unsupported<T>() async {
    throw UnsupportedError('PrizePoolRepository is only available on web.');
  }

  Future<void> approve() => _unsupported();

  Future<bool> joinLeague() => _unsupported();

  Future<void> withdrawBeforeLeagueStarts() => _unsupported();

  Future<String> createLeague({
    required int entryFeeAmount,
    required int leagueStartTime,
    required int leagueEndTime,
  }) => _unsupported();

  Future<void> distributePrize() => _unsupported();
}
