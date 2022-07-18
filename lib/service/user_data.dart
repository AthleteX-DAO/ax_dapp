import 'package:ax_dapp/service/athlete.dart';

class UserData {
  UserData();

  List<Athlete> boughtAthletes = [];

  void addAthlete(Athlete athlete) {
    if (!boughtAthletes.contains(athlete)) boughtAthletes.add(athlete);
  }

  void removeAthlete(Athlete athlete) {
    if (boughtAthletes.contains(athlete)) boughtAthletes.remove(athlete);
  }

  bool containsAthlete(Athlete athlete) {
    return boughtAthletes.contains(athlete);
  }
}
