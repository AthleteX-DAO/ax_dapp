import 'package:ethereum_api/src/config/models/apts/mlb_apt_list.dart';
import 'package:ethereum_api/src/config/models/apts/nfl_apt_list.dart';
import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/ethereum/models/models.dart';
import 'package:ethereum_api/src/tokens/tokens.dart';
import 'package:shared/shared.dart';

/// {@template athlete_performance_token_config}
/// Configures an [Apt].
/// {@endtemplate}
class AptConfig extends Equatable {
  /// {@macro athlete_performance_token_config}
  const AptConfig({
    required this.athleteId,
    required this.athleteName,
    required this.longTicker,
    required this.shortTicker,
    required this.pairAddressConfig,
    required this.longAddressConfig,
    required this.shortAddressConfig,
    required this.sport,
  });

  /// {@template athlete_id}
  /// Represents athelete's ID.
  /// {@endtemplate}
  final int athleteId;

  /// {@template athlete_name}
  /// Represents athlete's name.
  /// {@endtemplate}
  final String athleteName;

  /// Represents [Apt.long]'s ticker.
  final String longTicker;

  /// Represents [Apt.short]'s ticker.
  final String shortTicker;

  /// Represents [Apt]'s pair address configuration.
  final EthereumAddressConfig pairAddressConfig;

  /// Represents [Apt.long]'s address configuration.
  final EthereumAddressConfig longAddressConfig;

  /// Represents [Apt.short]'s address configuration.
  final EthereumAddressConfig shortAddressConfig;

  /// Represents athlete's [SupportedSport].
  final SupportedSport sport;

  @override
  List<Object?> get props => [
        athleteId,
        athleteName,
        longTicker,
        shortTicker,
        pairAddressConfig,
        longAddressConfig,
        shortAddressConfig,
        sport,
      ];

  /// Represents an empty [AptConfig]. Useful as default value.
  static const empty = AptConfig(
    athleteId: 0,
    athleteName: '',
    longTicker: '',
    shortTicker: '',
    pairAddressConfig: EthereumAddressConfig.empty(),
    longAddressConfig: EthereumAddressConfig.empty(),
    shortAddressConfig: EthereumAddressConfig.empty(),
    sport: SupportedSport.all,
  );
}

/// Static list of [AptConfig]s used to generate [Token.shortApt]s and
/// [Token.longApt]s.
List<AptConfig> getAllApts() {
  final allApts = List<AptConfig>.from(mlbApts)..addAll(nflApts);
  return allApts;
}

/// [AptConfig] extensions.
extension AptConfigX on AptConfig {
  /// Returns [Apt]'s name based on [AptType], e.g.: `Aaron Judge Long APT`.
  String aptName(AptType aptType) =>
      '$athleteName ${aptType.name.capitalize()} APT';
}
