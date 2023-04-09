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
        final athleteId = int.parse(athleteNameParts.last);
        final initialPrice = roster[name];
        final athleteScoutModel = athletes.firstWhere(
          (athlete) => athlete.id == athleteId,
          orElse: () => AthleteScoutModel.empty,
        );
        if (aptType == 'Long') {
          if (athleteScoutModel.longTokenBookPrice != roster[name]) {
            final percentChange = initialPrice == 0.0
                ? 0.0
                : ((athleteScoutModel.longTokenBookPrice! - initialPrice!) /
                        initialPrice) *
                    100;

            percentChanges.add(percentChange);
          }
        } else {
          if (athleteScoutModel.shortTokenBookPrice != roster[name]) {
            final percentChange = initialPrice == 0.0
                ? 0.0
                : ((initialPrice! - athleteScoutModel.shortTokenBookPrice!) /
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
