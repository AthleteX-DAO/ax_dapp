part of 'token.dart';

/// {@template athlete_performance_token}
/// Represents an `Athlete Performance` [Token], aka `APT`.
/// {@endtemplate}
class Apt extends Token {
  /// {@template long_athlete_performance_token}
  /// Creates a long [Apt].
  /// {@endtemplate}
  Apt.long(
    EthereumChain chain, {
    required AptConfig aptConfig,
  })  : type = AptType.long,
        _aptConfig = aptConfig,
        super(
          name: aptConfig.aptName(AptType.long),
          ticker: aptConfig.longTicker,
          sport: aptConfig.sport,
          addressConfig: aptConfig.longAddressConfig,
          chain: chain,
          currency: EthereumCurrency.apt,
        );

  /// {@template short_athlete_performance_token}
  /// Creates a short [Apt].
  /// {@endtemplate}
  Apt.short(
    EthereumChain chain, {
    required AptConfig aptConfig,
  })  : type = AptType.short,
        _aptConfig = aptConfig,
        super(
          name: aptConfig.aptName(AptType.short),
          ticker: aptConfig.shortTicker,
          sport: aptConfig.sport,
          addressConfig: aptConfig.shortAddressConfig,
          chain: chain,
          currency: EthereumCurrency.apt,
        );

  /// Represents an empty [Apt]. Useful as default value.
  const Apt.empty()
      : type = AptType.none,
        _aptConfig = AptConfig.empty,
        super(
          name: '',
          ticker: '',
          addressConfig: const TokenAddressConfig.empty(),
          chain: EthereumChain.none,
          currency: EthereumCurrency.none,
        );

  /// Represents the type of [Apt] (long or short).
  final AptType type;
  final AptConfig _aptConfig;

  @override
  List<Object?> get props => super.props..add(_aptConfig);
}

/// [Apt] extensions.
extension AptX on Apt {
  /// Returns `true` for an empty [Apt].
  bool get isEmpty => this == const Apt.empty();

  /// {@macro athlete_id}
  int get athleteId => _aptConfig.athleteId;

  /// {@macro athlete_name}
  String get athleteName => _aptConfig.athleteName;

  /// Returns [Apt]'s pair address.
  String get pairAddress => _aptConfig.pairAddressConfig.address(_chain);
}
