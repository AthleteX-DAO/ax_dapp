import 'package:wallet_repository/wallet_repository.dart';

/// Minimal stub for Across bridging integration.
class AcrossBridgeService {
  AcrossBridgeService({required WalletRepository walletRepository})
      : _walletRepository = walletRepository;

  final WalletRepository _walletRepository;

}
