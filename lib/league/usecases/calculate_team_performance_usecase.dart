import 'package:ax_dapp/scout/models/athlete_scout_model.dart';

class CalculateTeamPerformanceUseCase {
  double calculateTeamPerformance(
    Map<String, double> roster,
    List<AthleteScoutModel> athletes,
  ) {
    var percentChange = 0.0;
    var teamPerformance = 0.0;
    final percentChangeList = <double>[];
    roster.forEach((athlete, price) {
      final name =
          roster.keys.firstWhere((element) => roster[element] == price);
      final athleteStringList = name.split(' ');
      final aptType = athleteStringList[athleteStringList.length - 2];
      final athleteName = athleteStringList
          .getRange(0, athleteStringList.length - 2)
          .toList()
          .join(' ')
          .trim();
      final initialPrice = roster[name];
      final athleteScoutModel = athletes.firstWhere(
        (athlete) =>
            athlete.name.trim().toLowerCase() ==
            athleteName.trim().toLowerCase(),
        orElse: () => AthleteScoutModel.empty,
      );
      if (aptType == 'Long') {
        if (athleteScoutModel.longTokenBookPrice != roster[name]) {
          percentChange =
              ((athleteScoutModel.longTokenBookPrice! - initialPrice!) /
                      initialPrice) *
                  100;
          percentChangeList.add(percentChange);
          teamPerformance = percentChangeList.reduce((a, b) => a + b);
        }
      } else {
        if (athleteScoutModel.shortTokenBookPrice != roster[name]) {
          percentChange =
              ((initialPrice! - athleteScoutModel.shortTokenBookPrice!) /
                      initialPrice) *
                  100;
          percentChangeList.add(percentChange);
          teamPerformance = percentChangeList.reduce((a, b) => a + b);
        }
      }
    });
    return double.parse(teamPerformance.toStringAsFixed(2));
  }
}
