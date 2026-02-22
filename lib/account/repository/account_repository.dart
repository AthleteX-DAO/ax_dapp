import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/synthetix_core_service.dart';
import 'package:ax_dapp/service/synthetix_spot_service.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:ethereum_api/erc20_api.dart';
import 'package:shared/shared.dart' hide ERC20;

class AccountRepository {
  AccountRepository({
    SynthetixCoreService? synthetixCoreService,
    SynthetixSpotService? synthetixSpotService,
  })  : _synthetixCoreService = synthetixCoreService ?? SynthetixCoreService(),
        _synthetixSpotService = synthetixSpotService ?? SynthetixSpotService();

  Controller controller = Controller();
  final SynthetixCoreService _synthetixCoreService;
  final SynthetixSpotService _synthetixSpotService;

  Future<void> transerTokens({
    required String toAddress,
    required String tokenAddress,
    required double inputAmount,
    required int tokenDecimals,
  }) async {
    final to = EthereumAddress.fromHex(toAddress);
    final address = EthereumAddress.fromHex(tokenAddress);
    final tokenAmount = normalizeInput(inputAmount, decimal: tokenDecimals);
    final token = ERC20(address: address, client: controller.client.value);
    var transactionHash = '';
    try {
      transactionHash = await token.transfer(
        to,
        tokenAmount,
        credentials: controller.credentials,
      );
      controller.transactionHash = transactionHash;
    } catch (_) {
      controller.transactionHash = '';
    }
  }

  // ========== Synthetix V3 Account Operations ==========

  /// Get all Synthetix account IDs owned by a wallet
  Future<List<BigInt>> getSynthetixAccountIds(String walletAddress) async {
    print(
      'AccountRepository.getSynthetixAccountIds: wallet=$walletAddress',
    );
    final accounts = await _synthetixCoreService.getUserAccounts(walletAddress);
    print(
      'AccountRepository.getSynthetixAccountIds: count=${accounts.length}',
    );
    return accounts;
  }

  /// Get collateral information for a Synthetix account
  Future<Map<String, BigInt>> getSynthetixAccountCollateral({
    required int accountId,
    required String collateralAddress,
  }) async {
    return _synthetixCoreService.getAccountCollateral(
      accountId,
      collateralAddress,
    );
  }

  /// Get available (withdrawable) collateral for a Synthetix account
  Future<BigInt> getSynthetixAvailableCollateral({
    required int accountId,
    required String collateralAddress,
  }) async {
    return _synthetixCoreService.getAccountAvailableCollateral(
      accountId,
      collateralAddress,
    );
  }

  /// Get debt position for a Synthetix account in a pool
  Future<BigInt> getSynthetixPositionDebt({
    required int accountId,
    required int poolId,
    required String collateralAddress,
  }) async {
    return _synthetixCoreService.getPositionDebt(
      accountId,
      poolId,
      collateralAddress,
    );
  }

  /// Get collateralization ratio for a Synthetix account position
  Future<BigInt> getSynthetixCollateralRatio({
    required int accountId,
    required int poolId,
    required String collateralAddress,
  }) async {
    return _synthetixCoreService.getPositionCollateralRatio(
      accountId,
      poolId,
      collateralAddress,
    );
  }

  /// Deposit collateral to a Synthetix account
  Future<String> depositSynthetixCollateral({
    required int accountId,
    required String collateralAddress,
    required BigInt amount,
  }) async {
    final txHash = await _synthetixCoreService.depositCollateral(
      accountId: accountId,
      collateralAddress: collateralAddress,
      amount: amount,
      credentials: controller.credentials,
    );
    controller.transactionHash = txHash;
    return txHash;
  }

  /// Withdraw collateral from a Synthetix account
  Future<String> withdrawSynthetixCollateral({
    required int accountId,
    required String collateralAddress,
    required BigInt amount,
  }) async {
    final txHash = await _synthetixCoreService.withdrawCollateral(
      accountId: accountId,
      collateralAddress: collateralAddress,
      amount: amount,
      credentials: controller.credentials,
    );
    controller.transactionHash = txHash;
    return txHash;
  }

  /// Delegate collateral to a pool
  Future<String> delegateSynthetixCollateral({
    required int accountId,
    required int poolId,
    required String collateralAddress,
    required BigInt amount,
    BigInt? leverage,
  }) async {
    final txHash = await _synthetixCoreService.delegateCollateral(
      accountId: accountId,
      poolId: poolId,
      collateralAddress: collateralAddress,
      amount: amount,
      credentials: controller.credentials,
      leverage: leverage,
    );
    controller.transactionHash = txHash;
    return txHash;
  }

  /// Undelegate collateral from a pool
  Future<String> undelegateSynthetixCollateral({
    required int accountId,
    required int poolId,
    required String collateralAddress,
    required BigInt amount,
  }) async {
    final txHash = await _synthetixCoreService.undelegateCollateral(
      accountId: accountId,
      poolId: poolId,
      collateralAddress: collateralAddress,
      amount: amount,
      credentials: controller.credentials,
    );
    controller.transactionHash = txHash;
    return txHash;
  }

  /// Create a new Synthetix account (requires transaction)
  /// Account ID is auto-generated by Synthetix
  Future<String> createSynthetixAccount() async {
    print('AccountRepository.createSynthetixAccount: start');
    final txHash = await _synthetixCoreService.createAccount(
      controller.credentials,
    );
    print('AccountRepository.createSynthetixAccount: txHash=$txHash');
    controller.transactionHash = txHash;
    return txHash;
  }

  /// Mint axUSD against delegated collateral.
  ///
  /// [amount] is in 18-decimal wei units.  After minting, axUSD lands inside
  /// the CoreProxy account — call [withdrawAxUsd] to pull it into the wallet.
  Future<String> mintAxUsd({
    required int accountId,
    required int poolId,
    required String collateralAddress,
    required BigInt amount,
  }) async {
    final txHash = await _synthetixCoreService.mintUsd(
      accountId: accountId,
      poolId: poolId,
      collateralAddress: collateralAddress,
      amount: amount,
      credentials: controller.credentials,
    );
    controller.transactionHash = txHash;
    return txHash;
  }

  /// Withdraw axUSD from the CoreProxy account escrow to the connected wallet.
  ///
  /// Must be called after [mintAxUsd] — minted axUSD is NOT in the wallet
  /// until explicitly withdrawn.
  Future<String> withdrawAxUsd({
    required int accountId,
    required BigInt amount,
    required String usdProxyAddress,
  }) async {
    final txHash = await _synthetixCoreService.withdrawCollateral(
      accountId: accountId,
      collateralAddress: usdProxyAddress,
      amount: amount,
      credentials: controller.credentials,
    );
    controller.transactionHash = txHash;
    return txHash;
  }

  /// Approve [spenderAddress] to spend up to [amount] of [tokenAddress]
  /// on behalf of the connected wallet.
  ///
  /// Must be awaited before [depositSynthetixCollateral] (spender = CoreProxy)
  /// and before [wrapCollateral] (spender = SpotMarketProxy).
  Future<String> approveErc20({
    required String tokenAddress,
    required String spenderAddress,
    required BigInt amount,
  }) async {
    final token = ERC20(
      address: EthereumAddress.fromHex(tokenAddress),
      client: controller.client.value,
    );
    final txHash = await token.approve(
      EthereumAddress.fromHex(spenderAddress),
      amount,
      credentials: controller.credentials,
    );
    controller.transactionHash = txHash;
    return txHash;
  }

  /// Wrap a real token (USDC / USDT / WETH) into its synth equivalent.
  ///
  /// [marketId] is the SpotMarket market ID for the target synth.
  /// [wrapAmount] is the raw token amount (respects the token's own decimals).
  /// [minAmountReceived] protects against slippage — pass 0 to disable.
  Future<String> wrapCollateral({
    required int marketId,
    required String collateralAddress,
    required BigInt wrapAmount,
    BigInt? minAmountReceived,
  }) async {
    final txHash = await _synthetixSpotService.wrapCollateral(
      marketId: marketId,
      wrapAmount: wrapAmount,
      minAmountReceived: minAmountReceived ?? BigInt.zero,
      credentials: controller.credentials,
    );
    controller.transactionHash = txHash;
    return txHash;
  }
}
