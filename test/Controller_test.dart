import 'package:ax_dapp/service/Controller.dart';
import 'package:test/test.dart';

void main() {
  test('Testing Mainnet ChaID', () {
    final controller = Controller();

    expect(controller.MAINNET_CHAIN_ID, 137);
  });
}
