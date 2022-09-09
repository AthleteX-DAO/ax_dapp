import 'package:ethereum_api/wallet_api.dart';
import 'package:shared/shared.dart';
import 'package:wallet_repository/src/models/wallet_status.dart';

/// {@template wallet}
/// Holds wallet related data.
/// {@endtemplate}
class Wallet extends Equatable {
  /// {@macro wallet}
  const Wallet({
    required this.status,
    required this.address,
    required this.chain,
  });

  /// Represents a disconnected [Wallet].
  const Wallet.disconnected()
      : this(
          status: WalletStatus.disconnected,
          address: kEmptyAddress,
          chain: EthereumChain.none,
        );

  /// Wallet status.
  final WalletStatus status;

  /// Wallet address.
  final String address;

  /// Wallet chain.
  final EthereumChain chain;

  @override
  List<Object?> get props => [status, address, chain];
}

/// [Wallet] extensions.
extension WalletX on Wallet {
  /// Returns `true` when this [Wallet] is connected.
  bool get isConnected => status.isConnected;

  /// Returns `true` when this [Wallet] is disconnected.
  bool get isDisconnected => !isConnected;
}
