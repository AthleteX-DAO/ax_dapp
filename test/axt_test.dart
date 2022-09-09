@TestOn('browser')

import 'package:flutter_test/flutter_test.dart';
import 'package:tokens_repository/tokens_repository.dart';

void main() {
  test('verify ax mainnet address on polygon', () {
    expect(
      const Token.ax(EthereumChain.polygonMainnet).address,
      '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df',
    );
  });
}
