import 'package:ax_dapp/service/SupportedAthletes/SupportedMLBAthletes.dart';
import 'package:ax_dapp/service/athlete_api/MLBAthleteAPI.dart';
import 'package:ax_dapp/service/athleteModels/MLBAthlete.dart';

class MLBRepo {
  final MLBAthleteAPI _api;
  final SupportedMLBAthletes _athletes;

  MLBRepo(this._api, this._athletes);

  Future<List<MLBAthlete>> getAllPlayers() async {
    return _api.getAllPlayers();
  }

  Future<List<MLBAthlete>> getPlayersById() async {
    return _api.getPlayersById(_athletes.getSupportedAthletesList());
  }
}
