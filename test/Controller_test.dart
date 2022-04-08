@TestOn('browser')
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:test/test.dart';

void main() async {
  Controller controller = Controller();

  test('Testing if valid native connection is made', () {
    expect(controller.networkID.value, 80001);
  });
}
