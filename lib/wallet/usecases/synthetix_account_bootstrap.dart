import 'package:ax_dapp/service/synthetix_core_service.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// Silently ensures a Synthetix V3 core account exists for a wallet.
class SynthetixAccountBootstrap {
  SynthetixAccountBootstrap(this._coreService);

  final SynthetixCoreService _coreService;

  /// Returns the tx hash when an account is created, otherwise null.
  /// Calls onAccountReady with accountId when account exists or is created.
  Future<String?> ensureAccount({
    required String walletAddress,
    required WalletRepository walletRepository,
    void Function(int accountId)? onAccountReady,
  }) async {
    if (walletAddress.isEmpty) {
      return null;
    }

    final existing = await _coreService.getUserAccounts(walletAddress);
    if (existing.isNotEmpty) {
      onAccountReady?.call(existing.first.toInt());
      return null;
    }

    final credentials = walletRepository.credentials.value;
    final txHash = await _coreService.createAccount(credentials);
    // Account ID will be fetched after transaction confirms
    // Caller should query getUserAccounts to get the new account ID
    return txHash;
  }
}
