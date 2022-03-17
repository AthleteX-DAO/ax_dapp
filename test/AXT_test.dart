@TestOn('browser')
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:test/test.dart';

void main() {
  test('verify mainnet address', () {
    expect(AXT.polygonAddress, '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df');
  });
}
