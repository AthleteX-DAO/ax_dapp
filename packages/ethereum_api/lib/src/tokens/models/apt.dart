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
          addressConfig: const EthereumAddressConfig.empty(),
          chain: EthereumChain.none,
          currency: EthereumCurrency.none,
        );

  /// Represents the type of [Apt] (long or short).
  final AptType type;
  final AptConfig _aptConfig;

  @override
  List<Object?> get props => super.props..addAll([type, _aptConfig]);
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

/// [Apt]s extensions.
extension AptsX on Iterable<Apt> {
  /// Returns the [AptPair] with the corresponding [pairAddress].
  ///
  /// Defaults to [AptPair.empty] when no such [AptPair] is found.
  AptPair findPairByAddress(String pairAddress) => AptPair(
        longApt: singleWhere(
          (apt) =>
              apt.pairAddress.trim().toLowerCase() ==
                  pairAddress.trim().toLowerCase() &&
              apt.type.isLong,
          orElse: () => const Apt.empty(),
        ),
        shortApt: singleWhere(
          (apt) =>
              apt.pairAddress.trim().toLowerCase() ==
                  pairAddress.trim().toLowerCase() &&
              apt.type.isShort,
          orElse: () => const Apt.empty(),
        ),
      );

  /// Returns the [AptPair] with the corresponding [athleteId].
  ///
  /// Defaults to [AptPair.empty] when no such [AptPair] is found.
  AptPair findPairByAthleteId(int athleteId) => AptPair(
        longApt: singleWhere(
          (apt) => apt.athleteId == athleteId && apt.type.isLong,
          orElse: () => const Apt.empty(),
        ),
        shortApt: singleWhere(
          (apt) => apt.athleteId == athleteId && apt.type.isShort,
          orElse: () => const Apt.empty(),
        ),
      );

  /// Returns the [Apt] name with the corresponding [stakingAlias].
  ///
  /// Defaults to `null` when [stakingAlias] is empty.
  String? findAptNameByAlias(String stakingAlias) {
    // returns athlete token name, returns null if stakingAlias is empty
    // stakingToken alias example: 'AJLT1010-AX' or 'AX-CCST1010' or ''
    if (stakingAlias.isEmpty) return null;
    final tickers = stakingAlias.split('-');
    //we want athlete ticker not 'AX'
    final ticker = tickers[0] == 'AX' ? tickers[1] : tickers[0];
    return firstWhereOrNull(
          (apt) =>
              apt.ticker.trim().toLowerCase() == ticker.trim().toLowerCase(),
        )?.name ??
        '';
  }

  /// Returns the [Apt] sport with the corresponding [stakingAlias].
  ///
  /// Defaults to [SupportedSport.all] when [stakingAlias] is empty.
  SupportedSport findAptSportByAlias(String stakingAlias) {
    if (stakingAlias.isEmpty) return SupportedSport.all;
    final tickers = stakingAlias.split('-');
    final ticker = tickers[0] == 'AX' ? tickers[1] : tickers[0];
    return firstWhereOrNull(
          (apt) =>
              apt.ticker.trim().toLowerCase() == ticker.trim().toLowerCase(),
        )?.sport ??
        SupportedSport.all;
  }
}
