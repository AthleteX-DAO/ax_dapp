// TODO: Fix ethereum object mock errors

// import 'package:ax_dapp/service/Controller/usecases/GetChainChangesUseCase.dart';
// import 'package:ax_dapp/util/EthereumChainWrapper.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:test/test.dart';
// import 'package:ax_dapp/util/CurrentChain.dart';
// import 'GetChainChangesUseCase_test.mocks.dart';

// @GenerateMocks([EthereumWebChainWrapper])
// void main() {
//   late GetChainChangesUseCase getChainChangesUseCase;
//   late MockEthereumWebChainWrapper mockEthereumChainWrapper;
//   late Stream activeChainStream;

//   setUp(() {
//     mockEthereumChainWrapper = MockEthereumWebChainWrapper();
//     getChainChangesUseCase = GetChainChangesUseCase(mockEthereumChainWrapper);
//     activeChainStream = getChainChangesUseCase.stream;
//   });

//   // test('should return a stream whenever we call the getter method', () {
//   //   when(getChainChangesUseCase.stream);
//   // });

//   test('should emit CurrentChain.POLYGON enum value when network id is 137',
//       () {
//     when(mockEthereumChainWrapper.onChainChanged(any)).thenAnswer((_) =>
//         // print("Test Worked"));
//         getChainChangesUseCase.addCurrentChainToStream(137));
//     expect(activeChainStream, emits(CurrentChain.POLYGON));
//   });
// }
