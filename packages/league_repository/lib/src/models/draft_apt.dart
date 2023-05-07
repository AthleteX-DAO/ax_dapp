import 'package:equatable/equatable.dart';
import 'package:ethereum_api/tokens_api.dart';

/// {@template draft_apt}
/// Holds data related to a draft APT (athlete performance token).
/// {@endtemplate}
class DraftApt extends Equatable {
  /// {@macro draft_apt}
  const DraftApt({
    required this.id,
    required this.name,
    required this.team,
    required this.sport,
    required this.bookPrice,
    required this.bookPricePercent,
  });

  /// APT id.
  final int id;
  /// APT name.
  final String name;
  /// APT team.
  final String team;
  /// APT sport.
  final SupportedSport sport;
  /// APT book price.
  final double? bookPrice;
  /// APT book price percent change.
  final double? bookPricePercent;

  /// Represents an empty [DraftApt].
  static const empty = DraftApt(
    id: 0,
    name: '',
    team: '',
    sport: SupportedSport.all,
    bookPrice: 0,
    bookPricePercent: 0,
  );

  @override
  List<Object?> get props => [
        id,
        name,
        team,
        sport,
        bookPrice,
        bookPricePercent,
      ];
}

/// [DraftApt] extensions.
extension DraftAptListX on List<DraftApt> {
  /// returns the [DraftApt] that matches the [rosterIds] of each athlete.
  /// This will return the existing team.
  List<DraftApt> getExistingAptTeam(List<int> rosterIds) {
    final existingAptTeam =
        where((apt) => rosterIds.any((element) => element == apt.id)).toList();
    return existingAptTeam;
  }

  /// returns the [DraftApt] that matches the [rosterIds] of each athlete.
  /// This will return a list of available apts for the user to choose from.
  List<DraftApt> getAvailableOwnedApts(List<int> rosterIds) {
    final availableOwnedApts =
        where((apt) => !rosterIds.any((element) => element == apt.id)).toList();
    return availableOwnedApts;
  }
}
