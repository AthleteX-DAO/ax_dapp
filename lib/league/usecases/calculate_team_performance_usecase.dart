import 'package:ax_dapp/scout/models/athlete_scout_model.dart';

class CalculateTeamPerformanceUseCase {
  double calculateTeamPerformance(
    Map<String, double> roster,
    List<AthleteScoutModel> athletes,
  ) {
    final percentChanges = roster.entries.map((entry) {
      final athleteName = entry.key;
      final initialPrice = entry.value;
      final nameParts = athleteName.split(' ');
      final athleteId = int.parse(nameParts.last);
      final aptType = nameParts[nameParts.length - 2];
      final athlete = athletes.firstWhere(
        (a) => a.id == athleteId,
        orElse: () => AthleteScoutModel.empty,
      );

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

    final teamPerformance = percentChanges.reduce((a, b) => a + b);

    return teamPerformance;
  }
}
