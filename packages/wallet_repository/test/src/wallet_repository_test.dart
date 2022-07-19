// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wallet_repository/wallet_repository.dart';

void main() {
  group('WalletRepository', () {
    test('can be instantiated', () {
      expect(WalletRepository(), isNotNull);
    });
  });
}
