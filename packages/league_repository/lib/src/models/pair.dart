/// {@template pair}
/// Holds a `League`|`LeagueTeam` pair.
/// {@endtemplate}
class Pair<F, S> {
  /// {@macro pair}
  Pair({required this.first, required this.second});

  /// Represents the `League`
  final F first;

  /// Represents the `LeagueTeam`
  final S second;
}
