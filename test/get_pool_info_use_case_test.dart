import 'package:ax_dapp/repositories/subgraph/usecases/get_pool_info_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetPoolInfoUseCase placeholder', () {
    test('returns empty PoolPairInfo', () async {
      final useCase = GetPoolInfoUseCase();
      final result = await useCase();
      expect(result, PoolPairInfo.empty);
    });
  });
}
