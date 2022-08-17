// ignore_for_file: prefer_const_constructors
import 'package:config_repository/config_repository.dart';
import 'package:ethereum_api/config_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockConfigApiClient extends Mock implements ConfigApiClient {}

void main() {
  late ConfigApiClient configApiClient;

  group('ConfigRepository', () {
    setUp(() {
      configApiClient = MockConfigApiClient();
    });

    test('can be instantiated', () {
      expect(ConfigRepository(configApiClient: configApiClient), isNotNull);
    });
  });
}
