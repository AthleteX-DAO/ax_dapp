import 'package:ax_dapp/scout/models/athlete_scout_model.dart';

class CalculateTeamPerformanceUseCase {
  double calculateTeamPerformance(
    Map<String, double> roster,
    List<AthleteScoutModel> athletes,
  ) {
    final percentChanges = <double>[];
    roster.forEach(
      (athlete, price) {
        final name =
            roster.keys.firstWhere((element) => roster[element] == price);
        final athleteNameParts = name.split(' ');
        final aptType = athleteNameParts[athleteNameParts.length - 2];
        final athleteName = athleteNameParts
            .getRange(0, athleteNameParts.length - 2)
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
            final percentChange =
                ((athleteScoutModel.longTokenBookPrice! - initialPrice!) /
                        initialPrice) *
                    100;
            percentChanges.add(percentChange);
          }
        } else {
          if (athleteScoutModel.shortTokenBookPrice != roster[name]) {
            final percentChange =
                ((initialPrice! - athleteScoutModel.shortTokenBookPrice!) /
                        initialPrice) *
                    100;
            percentChanges.add(percentChange);
          }
        }
      },
    );

    final teamPerformance =
        double.parse(percentChanges.reduce((a, b) => a + b).toStringAsFixed(2));

    return teamPerformance;
  }
}
