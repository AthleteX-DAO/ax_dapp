import 'package:ax_dapp/service/Controller/createWallet/web.dart';
import 'package:ax_dapp/service/Controller/usecases/GetChainChangesUseCase.dart';
import 'package:ax_dapp/util/CurrentChain.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'GetChainChangesUseCase_test.mocks.dart';

// class MockWebWallet extends Mock implements WebWallet {}

@GenerateMocks([WebWallet, GetChainChangesUseCase])
void main() {
  late MockWebWallet mockWebWallet;
  late MockGetChainChangesUseCase mockGetChainChangesUseCase;

  setUp(() {
    MockWebWallet mockWebWallet = MockWebWallet();
    MockGetChainChangesUseCase mockGetChainChangesUseCase =
        MockGetChainChangesUseCase();
  });

  // test('should return a stream whenever we call the getter method', () {
  //   when(getChainChangesUseCase.stream);
  // });

  test('should emit CurrentChain.POLYGON enum value when network id is 137',
      () {
    mockGetChainChangesUseCase.addCurrentChainToStream(137);
    expect(mockGetChainChangesUseCase.stream, emits(CurrentChain.POLYGON));
  });
}
