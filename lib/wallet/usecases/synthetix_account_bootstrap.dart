import 'dart:math';

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
    if (walletAddress.isEmpty) return null;

    final existing = await _coreService.getUserAccounts(walletAddress);
    if (existing.isNotEmpty) {
      // Account already exists, notify callback
      onAccountReady?.call(existing.first.toInt());
      return null;
    }

    final credentials = walletRepository.credentials.value;
    final accountId = _deriveAccountId(walletAddress);
    final txHash = await _coreService.createAccount(accountId, credentials);
    
    // Notify that account was created
    onAccountReady?.call(accountId);
    
    return txHash;
  }

  /// Deterministic, bounded accountId derived from wallet address.
  int _deriveAccountId(String walletAddress) {
    final normalized = walletAddress.toLowerCase().replaceFirst('0x', '');
    final trimmed = normalized.padLeft(8, '0').substring(0, min(20, normalized.length));
    final hash = BigInt.parse(trimmed, radix: 16);
    // Keep well within uint128, but unique enough for our use case.
    final mod = BigInt.from(1000000000000); // 1e12
    return (hash % mod).toInt();
  }
}
