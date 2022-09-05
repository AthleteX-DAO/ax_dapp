import 'package:ethereum_api/src/config/models/apt_config.dart';
import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/ethereum/models/models.dart';
import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:shared/shared.dart';

part 'apt.dart';
part 'apt_pair.dart';
part 'apt_type.dart';

/// {@template token}
/// Represents an `Ethereum` token.
/// {@endtemplate}
class Token extends Equatable {
  /// {@macro token}
  const Token({
    required this.name,
    required this.ticker,
    this.sport = SupportedSport.all,
    required EthereumAddressConfig addressConfig,
    required EthereumChain chain,
    required this.currency,
  })  : _addressConfig = addressConfig,
        _chain = chain;

  /// Represents an `AthleteX` [Token].
  const Token.ax(EthereumChain chain)
      : this(
          name: 'AthleteX',
          ticker: 'AX',
          addressConfig: const EthereumAddressConfig.axt(),
          chain: chain,
          currency: EthereumCurrency.ax,
        );

  /// Represents a `SportX` [Token].
  const Token.sx(EthereumChain chain)
      : this(
          name: 'SportX',
          ticker: 'SX',
          addressConfig: const EthereumAddressConfig.sxt(),
          chain: chain,
          currency: EthereumCurrency.sx,
        );

  /// Represents a `Wrapped SportX` [Token].
  const Token.wsx(EthereumChain chain)
      : this(
          name: 'Wrapped SportX',
          ticker: 'WSX',
          addressConfig: const EthereumAddressConfig.wsxt(),
          chain: chain,
          currency: EthereumCurrency.wsx,
        );

  /// Represents a `Matic` [Token].
  const Token.matic(EthereumChain chain)
      : this(
          name: 'Matic/Polygon',
          ticker: 'Matic',
          addressConfig: const EthereumAddressConfig.matic(),
          chain: chain,
          currency: EthereumCurrency.matic,
        );

  /// Represents a `Wrapped Ether` [Token].
  const Token.weth(EthereumChain chain)
      : this(
          name: 'WETH',
          ticker: 'WETH',
          addressConfig: const EthereumAddressConfig.weth(),
          chain: chain,
          currency: EthereumCurrency.weth,
        );

  /// Represents an `USD Coin` [Token].
  const Token.usdc(EthereumChain chain)
      : this(
          name: 'USDC',
          ticker: 'USDC',
          addressConfig: const EthereumAddressConfig.usdc(),
          chain: chain,
          currency: EthereumCurrency.usdc,
        );

  /// {@macro athlete_performance_token}
  ///
  /// {@macro long_athlete_performance_token}
  factory Token.longApt(
    EthereumChain chain, {
    required AptConfig aptConfig,
  }) = Apt.long;

  /// {@macro athlete_performance_token}
  ///
  /// {@macro short_athlete_performance_token}
  factory Token.shortApt(
    EthereumChain chain, {
    required AptConfig aptConfig,
  }) = Apt.short;

  /// Represents [Token]'s name.
  final String name;

  /// Represents a [Token]'s ticker, e.g.: `AX` for `AthleteX` [Token].
  final String ticker;

  /// The [SupportedSport] for this [Token].
  final SupportedSport sport;

  /// {@macro ethereum_address_config}
  final EthereumAddressConfig _addressConfig;

  /// Represents current [EthereumChain].
  final EthereumChain _chain;

  /// Represents [Token]'s currency.
  final EthereumCurrency currency;

  /// Represents an empty [Token].
  static const empty = Token(
    name: '__empty__',
    ticker: '',
    addressConfig: EthereumAddressConfig.empty(),
    chain: EthereumChain.none,
    currency: EthereumCurrency.none,
  );

  @override
  List<Object?> get props => [
        name,
        ticker,
        sport,
        _addressConfig,
        _chain,
      ];
}

/// [Token] extensions.
extension TokenX on Token {
  /// Returns `true` for an empty [Token].
  bool get isEmpty => this == Token.empty;

  /// Returns the correspondent [Token]'s address based on the current
  /// [EthereumChain].
  /// - for [EthereumChain.none] and [EthereumChain.unsupported] it will return
  /// [kEmptyAddress];
  /// - for [Token.empty] it will also return [kEmptyAddress].
  String get address => _addressConfig.address(_chain);

  /// Returns the [EthereumChain] to which this [Token] is attached to.
  EthereumChain get chain => _chain;
}

/// [Token]s extensions.
extension TokensX on List<Token> {
  /// Returns the current [Token.ax].
  Token get axt => singleWhere(
        (token) => token.currency == EthereumCurrency.ax,
        orElse: () => Token.empty,
      );

  /// Returns the current [Token.sx].
  Token get sxt => singleWhere(
        (token) => token.currency == EthereumCurrency.sx,
        orElse: () => Token.empty,
      );

  /// Returns the current [Token.matic].
  Token get matic => singleWhere(
        (token) => token.currency == EthereumCurrency.matic,
        orElse: () => Token.empty,
      );

  /// Returns the current [Token.weth].
  Token get weth => singleWhere(
        (token) => token.currency == EthereumCurrency.weth,
        orElse: () => Token.empty,
      );

  /// Returns the current [Token.usdc].
  Token get usdc => singleWhere(
        (token) => token.currency == EthereumCurrency.usdc,
        orElse: () => Token.empty,
      );

  /// Finds and returns the [Token] with the corresponding [address].
  Token byAddress(String address) {
    return singleWhere(
      (token) =>
          token.address.trim().toLowerCase() == address.trim().toLowerCase(),
      orElse: () => Token.empty,
    );
  }
}
