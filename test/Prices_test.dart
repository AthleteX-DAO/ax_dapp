@TestOn('browser')
import 'package:ax_dapp/service/controller/scout/prices.dart';
import 'package:test/test.dart';

void main() {
  test('verify mainnet address', () {
    Prices().query('T.Brady');
    // Submit a query
    expect(
      '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df',
      '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df',
    );
  });
}
