import 'package:shared/shared.dart';

/// {@template wallet_credentials}
/// Holds [Credentials] for the connected wallet.
/// {@endtemplate}
class WalletCredentials extends Equatable {
  /// {@macro wallet_credentials}
  const WalletCredentials(CredentialsWithKnownAddress credentials)
      : _credentials = credentials;

  /// {@template _credentials}
  /// [Credentials] obtained from `MetaMask` through `requestAccount()`.
  /// {@endtemplate}
  final CredentialsWithKnownAddress _credentials;

  @override
  List<Object?> get props => [_credentials.address];
}

/// [WalletCredentials] extensions.
extension WalletCredentialsX on WalletCredentials {
  /// {@macro _credentials}
  CredentialsWithKnownAddress get value => _credentials;

  /// Returns the wallet address obtained from [CredentialsWithKnownAddress].
  String get walletAddress => value.address.hex.toLowerCase();
}
