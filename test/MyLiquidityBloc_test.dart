import 'package:ax_dapp/pages/pool/MyLiqudity/bloc/MyLiquidityBloc.dart';
import 'package:ax_dapp/pages/pool/MyLiqudity/models/MyLiquidityItemInfo.dart';
import 'package:ax_dapp/repositories/usecases/GetAllLiquidityInfoUseCase.dart';
import 'package:ax_dapp/service/Controller/usecases/GetWalletAddressUseCase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'MyLiquidityBloc_test.mocks.dart';

@GenerateMocks([GetAllLiquidityInfoUseCase, GetWalletAddressUseCase])
void main() {
  var mockRepoUseCase = MockGetAllLiquidityInfoUseCase();
  var mockWalletAddressUseCase = MockGetWalletAddressUseCase();
  var myLiquidityBloc = MyLiquidityBloc(
      repo: mockRepoUseCase, controller: mockWalletAddressUseCase);
  final testWalletAddress = "testWalletAddress";
  final List<LiquidityPositionInfo> testMyLiquidityItemInfo = [
    LiquidityPositionInfo(
        token0Name: "testToken0Name",
        token1Name: "testToken1Name",
        token0Symbol: "testToken0Symbol",
        token1Symbol: "testToken1Symbol",
        token0Address: "testToken0Address",
        token1Address: "testToken1Address",
        lpTokenPairAddress: "testLpTokenPairAddress",
        lpTokenPairBalance: "testLpTokenPairBalance",
        token0LpAmount: "testToken0LpAmount",
        token1LpAmount: "testToken1LpAmount",
        shareOfPool: "testShareOfPool",
        apy: "testApy")
  ];

  setUp(() {
    mockRepoUseCase = MockGetAllLiquidityInfoUseCase();
    mockWalletAddressUseCase = MockGetWalletAddressUseCase();
    myLiquidityBloc = MyLiquidityBloc(
        repo: mockRepoUseCase, controller: mockWalletAddressUseCase);

    when(mockRepoUseCase.fetchAllLiquidityPositions(
            walletAddress: testWalletAddress))
        .thenAnswer((_) async => Either.left(Success(testMyLiquidityItemInfo)));
  });

  test("Should updata MyLiquidity State successfully ", () async {
    when(mockWalletAddressUseCase.getWalletAddress())
        .thenReturn(testWalletAddress);
    myLiquidityBloc.add(LoadEvent());
    expectLater(
        myLiquidityBloc.stream,
        emitsInOrder([
          isA<MyLiquidityState>(),
          predicate<MyLiquidityState>(
              (state) => state.cards == testMyLiquidityItemInfo)
        ]));
  });
}
