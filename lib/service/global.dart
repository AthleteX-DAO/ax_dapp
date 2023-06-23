import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

// singleton class
class Global extends PropertyChangeNotifier<String> {
  factory Global() => _instance;

  Global._internal() {
    _athleteList = [];
    _predictions = [];
  }
  static final Global _instance = Global._internal();

  /// Variables

  List<AthleteScoutModel> _athleteList = [];
  List<PredictionModel> _predictions = [];

  /// Gettters/Setters

  List<AthleteScoutModel> get athleteList => _athleteList;
  List<PredictionModel> get predictions => _predictions;

  set athleteList(List<AthleteScoutModel> list) {
    _athleteList = list;
    notifyListeners('athleteList');
  }

  set predictions(List<PredictionModel> list) {
    _predictions = list;
    notifyListeners('predictions');
  }
}
