@TestOn('browser')
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:test/test.dart';

void main() async {
  Controller controller = Controller();
  String aValidMnemonic =
      "update elbow source spin squeeze horror world become oak assist bomb nuclear";
  String anInvalidMnemonic = "potatoe kendrick sparks";

  test('Testing if valid native connection is made', () {
    expect(controller.networkID.value, 80001);
  });
}
