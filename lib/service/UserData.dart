import 'package:ax_dapp/service/Athlete.dart';

class UserData {
  
  List<Athlete> boughtAthletes = [];

  UserData();

  void addAthlete(Athlete _athlete) {
    if (!boughtAthletes.contains(_athlete))
      boughtAthletes.add(_athlete);
  }

  void removeAthlete(Athlete _athlete) {
    if (boughtAthletes.contains(_athlete))
      boughtAthletes.remove(_athlete);
  }

  bool containsAthlete(Athlete _athlete) {
    return boughtAthletes.contains(_athlete);
  }
}