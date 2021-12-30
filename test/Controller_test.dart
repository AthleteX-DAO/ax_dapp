@TestOn('browser')
import 'package:ax_dapp/service/Controller.dart';
import 'package:test/test.dart';

void main() {
  test('Testing Mainnet ChaID', () {

    expect(Controller.MAINNET_CHAIN_ID, 137);
  });
}
