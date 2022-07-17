@TestOn('browser')
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:test/test.dart';

void main() async {
  final controller = Controller();

  test('Testing if valid native connection is made', () {
    expect(controller.networkID.value, 80001);
  });
}
