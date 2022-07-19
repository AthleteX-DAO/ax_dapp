import 'package:ax_dapp/pages/pool/my_liqudity/bloc/my_liquidity_bloc.dart';
import 'package:ax_dapp/pages/pool/my_liqudity/models/my_liquidity_item_info.dart';
import 'package:ax_dapp/repositories/usecases/get_all_liquidity_info_use_case.dart';
import 'package:ax_dapp/service/controller/usecases/get_wallet_address_use_case.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'my_liquidity_bloc_test.mocks.dart';

@GenerateMocks([GetAllLiquidityInfoUseCase, GetWalletAddressUseCase])
void main() {
  var mockRepoUseCase = MockGetAllLiquidityInfoUseCase();
  var mockWalletAddressUseCase = MockGetWalletAddressUseCase();
  var myLiquidityBloc = MyLiquidityBloc(
    repo: mockRepoUseCase,
    controller: mockWalletAddressUseCase,
  );
  const testWalletAddress = 'testWalletAddress';
  final testMyLiquidityItemInfo = <LiquidityPositionInfo>[
    const LiquidityPositionInfo(
      token0Name: 'testToken0Name',
      token1Name: 'testToken1Name',
      token0Symbol: 'testToken0Symbol',
      token1Symbol: 'testToken1Symbol',
      token0Address: 'testToken0Address',
      token1Address: 'testToken1Address',
      lpTokenPairAddress: 'testLpTokenPairAddress',
      lpTokenPairBalance: 'testLpTokenPairBalance',
      token0LpAmount: 'testToken0LpAmount',
      token1LpAmount: 'testToken1LpAmount',
      shareOfPool: 'testShareOfPool',
      apy: 'testApy',
    )
  ];

  setUp(() {
    mockRepoUseCase = MockGetAllLiquidityInfoUseCase();
    mockWalletAddressUseCase = MockGetWalletAddressUseCase();
    myLiquidityBloc = MyLiquidityBloc(
      repo: mockRepoUseCase,
      controller: mockWalletAddressUseCase,
    );

    when(
      mockRepoUseCase.fetchAllLiquidityPositions(
        walletAddress: testWalletAddress,
      ),
    ).thenAnswer((_) async => Either.left(Success(testMyLiquidityItemInfo)));
  });

  test('Should updata MyLiquidity State successfully ', () async {
    when(mockWalletAddressUseCase.getWalletAddress())
        .thenReturn(testWalletAddress);
    myLiquidityBloc.add(LoadEvent());
    await expectLater(
      myLiquidityBloc.stream,
      emitsInOrder([
        isA<MyLiquidityState>(),
        predicate<MyLiquidityState>(
          (state) => state.cards == testMyLiquidityItemInfo,
        )
      ]),
    );
  });
}
