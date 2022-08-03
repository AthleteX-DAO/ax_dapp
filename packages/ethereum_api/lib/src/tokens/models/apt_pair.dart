part of 'token.dart';

/// {@template athlete_performance_token_pair}
/// Represents a pair of [Apt]s.
/// {@endtemplate}
class AptPair extends Equatable {
  /// {@macro athlete_performance_token_pair}
  const AptPair({
    required this.longApt,
    required this.shortApt,
  });

  /// Represents [Apt.long].
  final Apt longApt;

  /// Represents [Apt.short].
  final Apt shortApt;

  /// Represents an empty [AptPair].
  static const empty = AptPair(longApt: Apt.empty(), shortApt: Apt.empty());

  @override
  List<Object?> get props => [longApt, shortApt];
}

/// [AptPair] extensions
extension AptPairX on AptPair {
  /// Returns `true` if any of the [AptPair.longApt] or [AptPair.shortApt] is
  /// empty, because it doesn't make sense to have operations involving a
  /// compromised pair.
  bool get isEmpty => longApt.isEmpty || shortApt.isEmpty;

  /// Represents [AptPair] address for an [Apt.long] and [Apt.short] pair of
  /// tokens.
  ///
  /// The `pairAddress` returned by the [Apt.long] and [Apt.short] are the same.
  String get address => longApt.pairAddress;
}
