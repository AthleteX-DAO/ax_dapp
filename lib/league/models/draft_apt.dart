import 'package:equatable/equatable.dart';
import 'package:ethereum_api/tokens_api.dart';

class DraftApt extends Equatable {
  const DraftApt({
    required this.id,
    required this.name,
    required this.team,
    required this.sport,
    required this.bookPrice,
    required this.bookPricePercent,
  });

  final int id;
  final String name;
  final String team;
  final SupportedSport sport;
  final double? bookPrice;
  final double? bookPricePercent;

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

extension DraftAptListX on List<DraftApt> {
  List<DraftApt> getExistingAptTeam(List<int> rosterIds) {
    final existingAptTeam =
        where((apt) => rosterIds.any((element) => element == apt.id)).toList();
    return existingAptTeam;
  }

  List<DraftApt> getAvailableOwnedApts(List<int> rosterIds) {
    final availableOwnedApts =
        where((apt) => !rosterIds.any((element) => element == apt.id)).toList();
    return availableOwnedApts;
  }
}
