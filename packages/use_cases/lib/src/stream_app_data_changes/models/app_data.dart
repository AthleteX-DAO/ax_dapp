import 'package:config_repository/config_repository.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// {@template app_data}
/// Holds app related data: [EthereumChain], [WalletStatus], [Wallet] address,
/// [Token]s.
/// {@endtemplate}
class AppData extends Equatable {
  /// {@macro app_data}
  const AppData({
    required this.chain,
    required this.walletStatus,
    required this.walletAddress,
    required this.tokens,
    required this.appConfig,
  });

  /// Current [EthereumChain].
  final EthereumChain chain;

  /// Current [Wallet] status.
  final WalletStatus walletStatus;

  /// Current [Wallet] address.
  final String walletAddress;

  /// Current [Token]s.
  final List<Token> tokens;

  /// Current [AppConfig].
  final AppConfig appConfig;

  @override
  List<Object?> get props => [
        chain,
        walletStatus,
        walletAddress,
        tokens,
        appConfig,
      ];
}
