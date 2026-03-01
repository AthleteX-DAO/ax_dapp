// ignore_for_file: avoid_print

import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/repository/account_repository.dart';
import 'package:ax_dapp/config/athletex_synthetix_config.dart';
import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:ax_dapp/service/controller/earn/vault_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

import 'account_bloc_test.mocks.dart';

@GenerateMocks([
  AccountRepository,
  WalletRepository,
  TokensRepository,
  StreamAppDataChangesUseCase,
  VaultRepository,
])
void main() {
  // ─── Shared constants ───────────────────────────────────────────────────────

  const testWalletAddress = '0x1234567890123456789012345678901234567890';
  final testCollateralAddress = AthleteXSynthetixConfig.defaultCollateralAddress(
    EthereumChain.sepoliaTestnet.chainId,
  );
  const testAccountId = 42;

  final testWallet = const Wallet(
    status: WalletStatus.connected,
    address: testWalletAddress,
    chain: EthereumChain.sepoliaTestnet,
    assets: [],
  );

  // ─── Helpers ────────────────────────────────────────────────────────────────

  late MockAccountRepository mockAccountRepository;
  late MockWalletRepository mockWalletRepository;
  late MockTokensRepository mockTokensRepository;
  late MockStreamAppDataChangesUseCase mockStreamAppDataChanges;
  late MockVaultRepository mockVaultRepository;

  /// Builds a bloc with all mocks. Call after configuring any extra stubs.
  AccountBloc buildBloc() => AccountBloc(
        tokensRepository: mockTokensRepository,
        walletRepository: mockWalletRepository,
        streamAppDataChanges: mockStreamAppDataChanges,
        accountRepository: mockAccountRepository,
        vaultRepository: mockVaultRepository,
      );

  /// Stubs [mockTokensRepository] and [mockWalletRepository] with the
  /// minimum data the BLoC constructor needs.
  void stubDefaults() {
    when(mockWalletRepository.currentWallet).thenReturn(testWallet);
    when(mockWalletRepository.currentChain)
        .thenReturn(EthereumChain.sepoliaTestnet);
    when(mockWalletRepository.credentials)
        .thenReturn(null); // Credentials not exercised in unit tests

    when(mockTokensRepository.currentTokens).thenReturn([Token.empty]);

    when(mockStreamAppDataChanges.appDataChanges)
        .thenAnswer((_) => const Stream.empty());

    when(mockVaultRepository.fetchVaults()).thenAnswer((_) async => []);
  }

  setUp(() {
    mockAccountRepository = MockAccountRepository();
    mockWalletRepository = MockWalletRepository();
    mockTokensRepository = MockTokensRepository();
    mockStreamAppDataChanges = MockStreamAppDataChangesUseCase();
    mockVaultRepository = MockVaultRepository();

    stubDefaults();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // FetchSynthetixAccountRequested
  // ═══════════════════════════════════════════════════════════════════════════

  group('FetchSynthetixAccountRequested', () {
    final emptyCollateral = <String, BigInt>{
      'totalDeposited': BigInt.zero,
      'totalAssigned': BigInt.zero,
      'totalLocked': BigInt.zero,
    };

    blocTest<AccountBloc, AccountState>(
      'emits loading then populated state when account exists',
      setUp: () {
        when(mockAccountRepository.getSynthetixAccountIds(testWalletAddress))
            .thenAnswer((_) async => [BigInt.from(testAccountId)]);

        when(
          mockAccountRepository.getSynthetixAccountCollateral(
            accountId: testAccountId,
            collateralAddress: testCollateralAddress,
          ),
        ).thenAnswer(
          (_) async => {
            'totalDeposited': BigInt.from(100 * 1e18.toInt()),
            'totalAssigned': BigInt.from(100 * 1e18.toInt()),
            'totalLocked': BigInt.zero,
          },
        );

        when(
          mockAccountRepository.getSynthetixAvailableCollateral(
            accountId: testAccountId,
            collateralAddress: testCollateralAddress,
          ),
        ).thenAnswer((_) async => BigInt.zero);

        when(
          mockAccountRepository.getSynthetixPositionDebt(
            accountId: testAccountId,
            poolId: AthleteXSynthetixConfig.defaultPoolId,
            collateralAddress: testCollateralAddress,
          ),
        ).thenAnswer((_) async => BigInt.zero);

        when(
          mockAccountRepository.getSynthetixCollateralRatio(
            accountId: testAccountId,
            poolId: AthleteXSynthetixConfig.defaultPoolId,
            collateralAddress: testCollateralAddress,
          ),
        ).thenAnswer((_) async => BigInt.zero);

        // axUSD account collateral
        when(
          mockAccountRepository.getSynthetixAccountCollateral(
            accountId: testAccountId,
            collateralAddress: SynthetixConfig.usdProxy,
          ),
        ).thenAnswer((_) async => emptyCollateral);

        when(mockWalletRepository.getRawTokenBalance(SynthetixConfig.usdProxy))
            .thenAnswer((_) async => BigInt.zero);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const FetchSynthetixAccountRequested()),
      expect: () => [
        // Loading
        isA<AccountState>().having(
          (s) => s.isSynthetixAccountLoading,
          'isSynthetixAccountLoading',
          true,
        ),
        // Populated
        isA<AccountState>()
            .having(
              (s) => s.hasSynthetixAccount,
              'hasSynthetixAccount',
              true,
            )
            .having(
              (s) => s.synthetixAccountId,
              'synthetixAccountId',
              testAccountId,
            )
            .having(
              (s) => s.isSynthetixAccountLoading,
              'isSynthetixAccountLoading',
              false,
            ),
      ],
    );

    blocTest<AccountBloc, AccountState>(
      'emits no-account state when wallet has no Synthetix accounts',
      setUp: () {
        when(mockAccountRepository.getSynthetixAccountIds(testWalletAddress))
            .thenAnswer((_) async => []);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const FetchSynthetixAccountRequested()),
      expect: () => [
        isA<AccountState>().having(
          (s) => s.isSynthetixAccountLoading,
          'isSynthetixAccountLoading',
          true,
        ),
        isA<AccountState>()
            .having(
              (s) => s.hasSynthetixAccount,
              'hasSynthetixAccount',
              false,
            )
            .having(
              (s) => s.isSynthetixAccountLoading,
              'isSynthetixAccountLoading',
              false,
            ),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // DepositSynthetixCollateralRequested
  // ═══════════════════════════════════════════════════════════════════════════

  group('DepositSynthetixCollateralRequested', () {
    final depositAmount = BigInt.from(50 * 1e18.toInt());

    /// Returns a bloc seeded with a Synthetix account already loaded.
    AccountBloc blocWithAccount() {
      final bloc = buildBloc();
      // Manually seed hasSynthetixAccount=true via state
      bloc.emit(
        AccountState(
          chain: EthereumChain.sepoliaTestnet,
          walletAddress: testWalletAddress,
          synthetixAccountId: testAccountId,
          hasSynthetixAccount: true,
        ),
      );
      return bloc;
    }

    blocTest<AccountBloc, AccountState>(
      'deposits then auto-delegates, emits depositing → delegating → done',
      setUp: () {
        when(
          mockAccountRepository.depositSynthetixCollateral(
            accountId: testAccountId,
            collateralAddress: testCollateralAddress,
            amount: depositAmount,
          ),
        ).thenAnswer((_) async => '0xTxDeposit');

        when(
          mockAccountRepository.getSynthetixAccountCollateral(
            accountId: testAccountId,
            collateralAddress: testCollateralAddress,
          ),
        ).thenAnswer(
          (_) async => {
            'totalDeposited': depositAmount,
            'totalAssigned': BigInt.zero,
            'totalLocked': BigInt.zero,
          },
        );

        when(
          mockAccountRepository.delegateSynthetixCollateral(
            accountId: testAccountId,
            poolId: AthleteXSynthetixConfig.defaultPoolId,
            collateralAddress: testCollateralAddress,
            amount: depositAmount,
          ),
        ).thenAnswer((_) async => '0xTxDelegate');

        // Stub refresh call after deposit
        when(mockAccountRepository.getSynthetixAccountIds(testWalletAddress))
            .thenAnswer((_) async => [BigInt.from(testAccountId)]);
      },
      build: blocWithAccount,
      act: (bloc) => bloc.add(
        DepositSynthetixCollateralRequested(
          collateralAddress: testCollateralAddress,
          amount: depositAmount,
        ),
      ),
      expect: () => [
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.depositing,
        ),
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.delegating,
        ),
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.done,
        ),
        // FetchSynthetixAccountRequested loading + result
        isA<AccountState>().having(
          (s) => s.isSynthetixAccountLoading,
          'isSynthetixAccountLoading',
          true,
        ),
        // the fetch result can be loading=false (may vary based on stubs)
        isA<AccountState>(),
      ],
    );

    blocTest<AccountBloc, AccountState>(
      'emits error state when deposit throws',
      setUp: () {
        when(
          mockAccountRepository.depositSynthetixCollateral(
            accountId: anyNamed('accountId'),
            collateralAddress: anyNamed('collateralAddress'),
            amount: anyNamed('amount'),
          ),
        ).thenThrow(Exception('RPC error'));
      },
      build: blocWithAccount,
      act: (bloc) => bloc.add(
        DepositSynthetixCollateralRequested(
          collateralAddress: testCollateralAddress,
          amount: depositAmount,
        ),
      ),
      expect: () => [
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.depositing,
        ),
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.error,
        ),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // MintAxUsdRequested
  // ═══════════════════════════════════════════════════════════════════════════

  group('MintAxUsdRequested', () {
    // 100 tokens delegated (18 dec)
    final assignedCollateral = BigInt.from(100) * BigInt.from(10).pow(18);
    // c-ratio 400% (4 × 1e18)
    final cRatio400 = BigInt.from(400) * BigInt.from(10).pow(18);
    // No existing debt → safe-max path uses assignedCollateral / targetCRatio
    final existingDebt = BigInt.zero;
    // slider at 100% → mint the full safe-max
    const sliderValue = 1.0;

    AccountBloc blocWithCollateral() {
      final bloc = buildBloc();
      bloc.emit(
        AccountState(
          chain: EthereumChain.sepoliaTestnet,
          walletAddress: testWalletAddress,
          synthetixAccountId: testAccountId,
          hasSynthetixAccount: true,
          synthetixCollateralAssigned: assignedCollateral,
          synthetixCollateralRatio: cRatio400,
        ),
      );
      return bloc;
    }

    blocTest<AccountBloc, AccountState>(
      'mints axUSD then withdraws to wallet, emits minting → done',
      setUp: () {
        when(
          mockAccountRepository.getSynthetixPositionDebt(
            accountId: testAccountId,
            poolId: AthleteXSynthetixConfig.defaultPoolId,
            collateralAddress: testCollateralAddress,
          ),
        ).thenAnswer((_) async => existingDebt);

        when(
          mockAccountRepository.mintAxUsd(
            accountId: anyNamed('accountId'),
            poolId: anyNamed('poolId'),
            collateralAddress: anyNamed('collateralAddress'),
            amount: anyNamed('amount'),
          ),
        ).thenAnswer((_) async => '0xTxMint');

        when(
          mockAccountRepository.withdrawAxUsd(
            accountId: anyNamed('accountId'),
            amount: anyNamed('amount'),
            usdProxyAddress: anyNamed('usdProxyAddress'),
          ),
        ).thenAnswer((_) async => '0xTxWithdraw');

        // Stub the FetchSynthetixAccountRequested that fires after mint
        when(mockAccountRepository.getSynthetixAccountIds(testWalletAddress))
            .thenAnswer((_) async => [BigInt.from(testAccountId)]);
      },
      build: blocWithCollateral,
      act: (bloc) => bloc.add(
        const MintAxUsdRequested(
          collateralAddress: testCollateralAddress,
          sliderValue: sliderValue,
        ),
      ),
      expect: () => [
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.minting,
        ),
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.done,
        ),
        // FetchSynthetixAccountRequested loading
        isA<AccountState>().having(
          (s) => s.isSynthetixAccountLoading,
          'isSynthetixAccountLoading',
          true,
        ),
        isA<AccountState>(),
      ],
      verify: (_) {
        // mintAxUsd must have been called at least once
        verify(
          mockAccountRepository.mintAxUsd(
            accountId: anyNamed('accountId'),
            poolId: anyNamed('poolId'),
            collateralAddress: testCollateralAddress,
            amount: anyNamed('amount'),
          ),
        ).called(1);
        // withdrawAxUsd must be called to pull minted axUSD to wallet
        verify(
          mockAccountRepository.withdrawAxUsd(
            accountId: anyNamed('accountId'),
            amount: anyNamed('amount'),
            usdProxyAddress: SynthetixConfig.usdProxy,
          ),
        ).called(1);
      },
    );

    blocTest<AccountBloc, AccountState>(
      'does nothing when no collateral is delegated',
      build: () {
        final bloc = buildBloc();
        bloc.emit(
          AccountState(
            chain: EthereumChain.sepoliaTestnet,
            walletAddress: testWalletAddress,
            synthetixAccountId: testAccountId,
            hasSynthetixAccount: true,
            // synthetixCollateralAssigned defaults to BigInt.zero
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const MintAxUsdRequested(
          collateralAddress: testCollateralAddress,
          sliderValue: sliderValue,
        ),
      ),
      // No state changes expected — early return due to zero collateral
      expect: () => <AccountState>[],
    );

    blocTest<AccountBloc, AccountState>(
      'emits error state when mintAxUsd throws',
      setUp: () {
        when(
          mockAccountRepository.getSynthetixPositionDebt(
            accountId: anyNamed('accountId'),
            poolId: anyNamed('poolId'),
            collateralAddress: anyNamed('collateralAddress'),
          ),
        ).thenAnswer((_) async => existingDebt);

        when(
          mockAccountRepository.mintAxUsd(
            accountId: anyNamed('accountId'),
            poolId: anyNamed('poolId'),
            collateralAddress: anyNamed('collateralAddress'),
            amount: anyNamed('amount'),
          ),
        ).thenThrow(Exception('insufficient debt issuance'));
      },
      build: blocWithCollateral,
      act: (bloc) => bloc.add(
        const MintAxUsdRequested(
          collateralAddress: testCollateralAddress,
          sliderValue: sliderValue,
        ),
      ),
      expect: () => [
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.minting,
        ),
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.error,
        ),
      ],
    );
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // WrapCollateralRequested
  // ═══════════════════════════════════════════════════════════════════════════

  group('WrapCollateralRequested', () {
    // 1 USDC = 1_000_000 (6 dec)
    final wrapAmount = BigInt.from(1_000_000);
    const testMarketId = 1;
    // testCollateralAddress is AX; use USDC for wrap test
    const usdcAddress = '0xC2567853F68299DeaFcB5B5c3b00a5a6bCA88f42';

    blocTest<AccountBloc, AccountState>(
      'wraps collateral with 0.5% slippage by default',
      setUp: () {
        when(
          mockAccountRepository.wrapCollateral(
            marketId: anyNamed('marketId'),
            collateralAddress: anyNamed('collateralAddress'),
            wrapAmount: anyNamed('wrapAmount'),
            minAmountReceived: anyNamed('minAmountReceived'),
          ),
        ).thenAnswer((_) async => '0xTxWrap');

        // Stub the refresh
        when(mockAccountRepository.getSynthetixAccountIds(testWalletAddress))
            .thenAnswer((_) async => []);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        WrapCollateralRequested(
          marketId: testMarketId,
          collateralAddress: usdcAddress,
          amount: wrapAmount,
          // slippageBps defaults to 50 (0.5%)
        ),
      ),
      expect: () => [
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.depositing,
        ),
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.done,
        ),
        isA<AccountState>().having(
          (s) => s.isSynthetixAccountLoading,
          'isSynthetixAccountLoading',
          true,
        ),
        isA<AccountState>(),
      ],
      verify: (_) {
        // minAmountReceived should be amount × (10000-50) / 10000 = 99.5%
        final expectedMin =
            wrapAmount * BigInt.from(9950) ~/ BigInt.from(10000);
        verify(
          mockAccountRepository.wrapCollateral(
            marketId: testMarketId,
            collateralAddress: usdcAddress,
            wrapAmount: wrapAmount,
            minAmountReceived: expectedMin,
          ),
        ).called(1);
      },
    );

    blocTest<AccountBloc, AccountState>(
      'respects custom slippageBps',
      setUp: () {
        when(
          mockAccountRepository.wrapCollateral(
            marketId: anyNamed('marketId'),
            collateralAddress: anyNamed('collateralAddress'),
            wrapAmount: anyNamed('wrapAmount'),
            minAmountReceived: anyNamed('minAmountReceived'),
          ),
        ).thenAnswer((_) async => '0xTxWrap');

        when(mockAccountRepository.getSynthetixAccountIds(testWalletAddress))
            .thenAnswer((_) async => []);
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        WrapCollateralRequested(
          marketId: testMarketId,
          collateralAddress: usdcAddress,
          amount: wrapAmount,
          slippageBps: 100, // 1%
        ),
      ),
      verify: (_) {
        final expectedMin =
            wrapAmount * BigInt.from(9900) ~/ BigInt.from(10000);
        verify(
          mockAccountRepository.wrapCollateral(
            marketId: testMarketId,
            collateralAddress: usdcAddress,
            wrapAmount: wrapAmount,
            minAmountReceived: expectedMin,
          ),
        ).called(1);
      },
    );

    blocTest<AccountBloc, AccountState>(
      'emits error state when wrapCollateral throws',
      setUp: () {
        when(
          mockAccountRepository.wrapCollateral(
            marketId: anyNamed('marketId'),
            collateralAddress: anyNamed('collateralAddress'),
            wrapAmount: anyNamed('wrapAmount'),
            minAmountReceived: anyNamed('minAmountReceived'),
          ),
        ).thenThrow(Exception('wrap reverted: InsufficientAmountReceived'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(
        WrapCollateralRequested(
          marketId: testMarketId,
          collateralAddress: usdcAddress,
          amount: wrapAmount,
        ),
      ),
      expect: () => [
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.depositing,
        ),
        isA<AccountState>().having(
          (s) => s.synthetixTxStatus,
          'status',
          SynthetixTxStatus.error,
        ),
      ],
    );
  });
}
