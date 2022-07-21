// TODO(Pearlson): confirm info
import 'package:flutter_web3/ethereum.dart';

/// {@template ethereum_currency}
/// Holds data about an `Ethereum` currency.
/// {@endtemplate}
enum EthereumCurrency {
  /// Currency used with Polygon.
  matic(currencyName: 'MATIC Token', symbol: 'MATIC'),

  /// Currency used with SX.
  sx(currencyName: 'SportX Token', symbol: 'SX');

  /// {@macro ethereum_currency}
  const EthereumCurrency({
    required this.currencyName,
    required this.symbol,
  });

  /// The name of the currency.
  final String currencyName;

  /// The symbol for the currency.
  final String symbol;

  /// The no. of decimals used with this currency.
  final int decimals = 18;
}

/// `EthereumCurrency` extensions.
extension EthereumCurrencyX on EthereumCurrency {
  /// Converts an `EthereumCurrency` to native `CurrencyParams`.
  CurrencyParams get toCurrencyParams => CurrencyParams(
        name: currencyName,
        symbol: symbol,
        decimals: decimals,
      );
}
