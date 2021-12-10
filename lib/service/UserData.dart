import 'package:ae_dapp/service/NFLAthlete.dart';

class UserData {
  
  List<NFLAthlete> boughtAthletes = [];

  UserData();

  void addAthlete(NFLAthlete _athlete) {
    if (!boughtAthletes.contains(_athlete))
      boughtAthletes.add(_athlete);
  }

  void removeAthlete(NFLAthlete _athlete) {
    if (boughtAthletes.contains(_athlete))
      boughtAthletes.remove(_athlete);
  }

  bool containsAthlete(NFLAthlete _athlete) {
    return boughtAthletes.contains(_athlete);
  }
}