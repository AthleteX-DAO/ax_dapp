@TestOn('browser')
import 'package:ax_dapp/service/Controller/AXT.dart';
import 'package:test/test.dart';

void main() {
  test('verify mainnet address', () {
    final axt = AXT("AthleteX", "AX");
    expect(axt.polygonAddress, '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df');
  });
}
