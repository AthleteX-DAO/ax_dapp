// TODO(Pearlson): confirm info
/// {@template ethereum_currency}
/// Holds data about an `Ethereum` currency.
/// {@endtemplate}
enum EthereumCurrency {
  /// Currency used with Polygon.
  matic(name: 'MATIC Token', symbol: 'MATIC'),

  /// Currency used with SX.
  sx(name: 'SportX Token', symbol: 'SX');

  /// {@macro ethereum_currency}
  const EthereumCurrency({
    required this.name,
    required this.symbol,
  });

  /// The name of the currency.
  final String name;

  /// The symbol for the currency.
  final String symbol;

  /// The no. of decimals used with this currency.
  final int decimals = 18;
}
