import 'package:ethereum_api/tokens_api.dart';
import 'package:shared/shared.dart';
import 'package:wallet_repository/src/models/wallet_status.dart';

/// {@template wallet}
/// Holds wallet related data.
/// {@endtemplate}
class Wallet extends Equatable {
  /// {@macro wallet}
  const Wallet({
    required this.status,
    required this.balance,
    required this.assets,
    required this.address,
    required this.chain,
  });

  /// Represents a disconnected [Wallet].
  const Wallet.disconnected()
      : this(
          status: WalletStatus.disconnected,
          balance: 0,
          assets: const [
            Token.usdc(EthereumChain.none),
            Token.weth(EthereumChain.none),
            Token.ax(EthereumChain.none),
          ],
          address: kEmptyAddress,
          chain: EthereumChain.none,
        );

  /// Wallet status.
  final WalletStatus status;

  /// Wallet address.
  final String address;

  /// Wallet chain.
  final EthereumChain chain;

  /// Cross-chain Wallet Balance
  final double balance;

  /// Wallet Assets
  final List<Token> assets;

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
