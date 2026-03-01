import 'package:web3dart/web3dart.dart';

/// Validates and safely parses Ethereum addresses.
///
/// Centralizes all address validation logic to prevent:
/// - Invalid addresses causing transaction failures
/// - Zero-address fund loss
/// - Typo-based misdirected transactions
class EthereumAddressValidator {
  EthereumAddressValidator._();

  static final _hexRegExp = RegExp(r'^0x[a-fA-F0-9]{40}$');

  /// Zero address — used as a safe null/empty fallback.
  static const String kZeroAddressHex =
      '0x0000000000000000000000000000000000000000';
  static final EthereumAddress kZeroAddress =
      EthereumAddress.fromHex(kZeroAddressHex);

  /// Returns true if [address] is a structurally valid 20-byte hex address.
  static bool isValid(String? address) {
    if (address == null || address.isEmpty) return false;
    return _hexRegExp.hasMatch(address);
  }

  /// Returns true if [address] is the zero address.
  static bool isZero(String address) =>
      address.toLowerCase() == kZeroAddressHex;

  /// Parses [address] to [EthereumAddress] after validation.
  ///
  /// Throws [ArgumentError] for structurally invalid addresses.
  static EthereumAddress parse(String address) {
    if (!isValid(address)) {
      throw ArgumentError(
        'Invalid Ethereum address: "$address". '
        'Expected 0x-prefixed 40 hex characters.',
      );
    }
    return EthereumAddress.fromHex(address);
  }

  /// Parses [address] if valid, otherwise returns [fallback].
  ///
  /// [fallback] defaults to the zero address.
  static EthereumAddress parseOrFallback(
    String? address, {
    EthereumAddress? fallback,
  }) {
    if (!isValid(address)) return fallback ?? kZeroAddress;
    return EthereumAddress.fromHex(address!);
  }

  /// Parses a nullable [address] that is truly required for a transaction.
  ///
  /// Throws [StateError] when address is empty/missing (not just invalid),
  /// so the caller knows a configuration value is missing.
  static EthereumAddress parseRequired(String? address, {String? fieldName}) {
    final label = fieldName ?? 'address';
    if (address == null || address.isEmpty) {
      throw StateError(
        'Required $label is not configured. '
        'Check SynthetixConfig or EthereumAddressConfig for this chain.',
      );
    }
    return parse(address);
  }
}
