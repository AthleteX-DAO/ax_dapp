import 'dart:math';

import 'package:ax_dapp/markets/crypto_markets/models/athlete_scout_model.dart';
import 'package:league_repository/league_repository.dart';
import 'package:tokens_repository/tokens_repository.dart';

class LeagueUseCase {
  double calculateTeamPerformance(
    Map<int, List<String>> roster,
    List<AthleteScoutModel> athletes,
  ) {
    final percentChanges = roster.entries.map((entry) {
      final initialPrice = double.parse(entry.value[1]);
      final athleteId = entry.key ~/ 10;
      final aptType = entry.value[0].split(' ').last;
      final athlete = athletes.findAthlete(athleteId);

      double price;
      double percentChange;

      if (aptType == 'Long') {
        price = athlete.longTokenBookPrice!;
        percentChange = (price - initialPrice) / initialPrice * 100;
      } else {
        price = athlete.shortTokenBookPrice!;
        percentChange = (initialPrice - price) / initialPrice * 100;
      }

      if (price == initialPrice || initialPrice == 0) {
        return 0.0;
      }

      return percentChange;
    }).toList();

    final teamPerformance = percentChanges.fold<double>(0, (a, b) => a + b);

    return teamPerformance;
  }

  List<DraftApt> ownedAptToList(
    List<Apt> response,
    List<AthleteScoutModel> athletes,
  ) {
    return response
        .where((apt) => athletes.any((element) => element.id == apt.athleteId))
        .map((e) {
      final athlete = athletes.findAthlete(e.athleteId);
      final bookPrice = e.type == AptType.long
          ? athlete.longTokenBookPrice
          : e.type == AptType.short
              ? athlete.shortTokenBookPrice
              : 0.0;
      final bookPricePercent = e.type == AptType.long
          ? athlete.longTokenBookPricePercent
          : e.type == AptType.short
              ? athlete.shortTokenBookPricePercent
              : 0.0;
      final aptName = e.name.replaceAll('APT', '').trim();
      final id = e.type == AptType.long
          ? int.parse('${athlete.id}1')
          : int.parse('${athlete.id}0');
      return DraftApt(
        id: id,
        name: aptName,
        team: athlete.team,
        sport: athlete.sport,
        bookPrice: bookPrice,
        bookPricePercent: bookPricePercent,
      );
    }).toList();
  }

  String generateLeagueID(int length) {
    const predefinedCharacters =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final random = Random();
    final generatedLeagueID = String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => predefinedCharacters.codeUnitAt(
          random.nextInt(
            predefinedCharacters.length,
          ),
        ),
      ),
    );
    return generatedLeagueID;
  }
}
