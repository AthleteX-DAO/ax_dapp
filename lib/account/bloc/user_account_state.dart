import 'package:equatable/equatable.dart';

/// User account lifecycle state machine
/// Transitions: walletNotConnected → walletConnected → synthetixAccountMissing → synthetixAccountCreated → readyToTrade
abstract class UserAccountState extends Equatable {
  const UserAccountState();

  /// Returns true if wallet is connected
  bool get isWalletConnected;

  /// Returns true if ready to perform protocol operations
  bool get isReadyToTrade;

  /// Returns true if account creation is in progress
  bool get isCreatingAccount;

  /// Get human-readable state description
  String get description;
}

/// Wallet is not connected yet
class WalletNotConnectedState extends UserAccountState {
  const WalletNotConnectedState();

  @override
  bool get isWalletConnected => false;

  @override
  bool get isReadyToTrade => false;

  @override
  bool get isCreatingAccount => false;

  @override
  String get description => 'Connect your wallet to get started';

  @override
  List<Object?> get props => [];
}

/// Wallet is connected but no Synthetix account exists
class SynthetixAccountMissingState extends UserAccountState {
  const SynthetixAccountMissingState({required this.walletAddress});

  final String walletAddress;

  @override
  bool get isWalletConnected => true;

  @override
  bool get isReadyToTrade => false;

  @override
  bool get isCreatingAccount => false;

  @override
  String get description =>
      'Create an AthleteX account to deposit collateral and trade';

  @override
  List<Object?> get props => [walletAddress];
}

/// Synthetix account is being created
class SynthetixAccountCreatingState extends UserAccountState {
  const SynthetixAccountCreatingState({
    required this.walletAddress,
    required this.transactionHash,
  });

  final String walletAddress;
  final String transactionHash;

  @override
  bool get isWalletConnected => true;

  @override
  bool get isReadyToTrade => false;

  @override
  bool get isCreatingAccount => true;

  @override
  String get description =>
      'Creating your AthleteX account... This may take a moment.';

  @override
  List<Object?> get props => [walletAddress, transactionHash];
}

/// Synthetix account exists and is ready to use
class ReadyToTradeState extends UserAccountState {
  const ReadyToTradeState({
    required this.walletAddress,
    required this.synthetixAccountId,
  });

  final String walletAddress;
  final BigInt synthetixAccountId;

  @override
  bool get isWalletConnected => true;

  @override
  bool get isReadyToTrade => true;

  @override
  bool get isCreatingAccount => false;

  @override
  String get description => 'Account ready. You can deposit and trade.';

  @override
  List<Object?> get props => [walletAddress, synthetixAccountId];
}

/// An error occurred during account setup
class AccountErrorState extends UserAccountState {
  const AccountErrorState({
    required this.message,
    required this.previousState,
  });

  final String message;

  /// Previous state before error (for recovery/retry)
  final String? previousState;

  @override
  bool get isWalletConnected => false;

  @override
  bool get isReadyToTrade => false;

  @override
  bool get isCreatingAccount => false;

  @override
  String get description => 'Error: $message';

  @override
  List<Object?> get props => [message, previousState];
}
