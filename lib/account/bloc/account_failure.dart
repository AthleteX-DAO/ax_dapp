import 'package:equatable/equatable.dart';

/// Error handler and failure types for account operations
abstract class AccountFailure extends Equatable {
  const AccountFailure();

  String get userFriendlyMessage;

  bool get isRetryable;
}

/// RPC/Network related failures
class RpcFailure extends AccountFailure {
  const RpcFailure({
    required this.message,
    required this.errorCode,
  });

  final String message;
  final int? errorCode;

  @override
  String get userFriendlyMessage {
    if (errorCode == null) {
      return 'Network error: ${message.replaceAll('Error: ', '')}';
    }
    
    final code = errorCode!;
    if (code == -32700) return 'Network error: Invalid request format';
    if (code == -32600) return 'Network error: Request failed';
    if (code == -32601) return 'Network error: Method not found';
    if (code == -32602) return 'Network error: Invalid parameters';
    if (code == -32603) return 'Network error: Internal error';
    if (code == -32000) return 'Network error: Server error';
    
    return 'Network error: ${message.replaceAll('Error: ', '')}';
  }

  @override
  bool get isRetryable => true;

  @override
  List<Object?> get props => [message, errorCode];
}

/// Smart contract transaction failed
class TransactionFailure extends AccountFailure {
  const TransactionFailure({
    required this.reason,
    this.revertReason,
  });

  final String reason;

  /// Decoded revert reason from smart contract
  final String? revertReason;

  @override
  String get userFriendlyMessage {
    if (revertReason != null && revertReason!.isNotEmpty) {
      return 'Transaction failed: $revertReason';
    }
    return 'Transaction failed: $reason';
  }

  @override
  bool get isRetryable => reason.contains('nonce') || reason.contains('gas');

  @override
  List<Object?> get props => [reason, revertReason];
}

/// Insufficient collateral for operation
class InsufficientCollateralFailure extends AccountFailure {
  const InsufficientCollateralFailure({
    required this.available,
    required this.required,
  });

  final BigInt available;
  final BigInt required;

  @override
  String get userFriendlyMessage {
    final availDecimal = available / BigInt.from(1000000);
    final reqDecimal = required / BigInt.from(1000000);
    return 'Insufficient collateral. Available: $availDecimal USDC, Required: $reqDecimal USDC';
  }

  @override
  bool get isRetryable => false;

  @override
  List<Object?> get props => [available, required];
}

/// Account would become undercollateralized
class UndercollateralizationFailure extends AccountFailure {
  const UndercollateralizationFailure({
    required this.currentRatio,
    required this.minimumRatio,
  });

  final double currentRatio;
  final double minimumRatio;

  @override
  String get userFriendlyMessage =>
      'Withdrawal would undercollateralize account. Current ratio: ${currentRatio.toStringAsFixed(2)}x, Minimum: ${minimumRatio.toStringAsFixed(2)}x';

  @override
  bool get isRetryable => false;

  @override
  List<Object?> get props => [currentRatio, minimumRatio];
}

/// Approval/allowance related failure
class ApprovalFailure extends AccountFailure {
  const ApprovalFailure({
    required this.tokenAddress,
    required this.reason,
  });

  final String tokenAddress;
  final String reason;

  @override
  String get userFriendlyMessage =>
      'Failed to approve collateral: $reason. Please try again.';

  @override
  bool get isRetryable => true;

  @override
  List<Object?> get props => [tokenAddress, reason];
}

/// Synthetix account not found or doesn't exist
class AccountNotFoundFailure extends AccountFailure {
  const AccountNotFoundFailure({required this.walletAddress});

  final String walletAddress;

  @override
  String get userFriendlyMessage =>
      'No AthleteX account found. Create one to get started.';

  @override
  bool get isRetryable => false;

  @override
  List<Object?> get props => [walletAddress];
}

/// Account is being created, operation not yet available
class AccountCreatingFailure extends AccountFailure {
  const AccountCreatingFailure();

  @override
  String get userFriendlyMessage =>
      'Account is being created. Please wait a moment.';

  @override
  bool get isRetryable => true;

  @override
  List<Object?> get props => [];
}

/// Generic timeout failure
class TimeoutFailure extends AccountFailure {
  const TimeoutFailure({required this.operation});

  final String operation;

  @override
  String get userFriendlyMessage =>
      '$operation timed out. Please check your connection and try again.';

  @override
  bool get isRetryable => true;

  @override
  List<Object?> get props => [operation];
}

/// Unknown/unexpected failure
class UnknownFailure extends AccountFailure {
  const UnknownFailure({required this.message});

  final String message;

  @override
  String get userFriendlyMessage => 'An unexpected error occurred: $message';

  @override
  bool get isRetryable => false;

  @override
  List<Object?> get props => [message];
}

/// Error handler utility for converting exceptions to user-friendly messages
class AccountErrorHandler {
  /// Convert any exception to AccountFailure
  static AccountFailure handleError(dynamic error) {
    if (error is AccountFailure) {
      return error;
    }

    final message = error.toString();

    // RPC errors
    if (message.contains('JSON-RPC')) {
      if (message.contains('-32000') || message.contains('execution reverted')) {
        return TransactionFailure(reason: message);
      }
      return RpcFailure(message: message, errorCode: _extractErrorCode(message));
    }

    // Network/Connection errors
    if (message.contains('SocketException') ||
        message.contains('Connection refused') ||
        message.contains('No internet')) {
      return RpcFailure(message: message, errorCode: null);
    }

    // Insufficient balance
    if (message.contains('insufficient') &&
        message.contains('balance')) {
      return InsufficientCollateralFailure(
        available: BigInt.zero,
        required: BigInt.one,
      );
    }

    // Approval failures
    if (message.contains('approve') || message.contains('allowance')) {
      return ApprovalFailure(
        tokenAddress: '',
        reason: message,
      );
    }

    // Timeout
    if (message.contains('TimeoutException') ||
        message.contains('deadline exceeded')) {
      return const TimeoutFailure(operation: 'Operation');
    }

    // Default
    return UnknownFailure(message: message);
  }

  /// Extract error code from RPC error message
  static int? _extractErrorCode(String message) {
    final regex = RegExp(r'-\d+');
    final match = regex.firstMatch(message);
    return match != null ? int.tryParse(match.group(0) ?? '') : null;
  }

  /// Determine if error should trigger a retry
  static bool shouldRetry(AccountFailure failure) {
    return failure.isRetryable;
  }

  /// Get user-friendly error message
  static String getMessage(AccountFailure failure) {
    return failure.userFriendlyMessage;
  }
}
