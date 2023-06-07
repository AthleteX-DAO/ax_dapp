import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

// singleton class
class Global extends PropertyChangeNotifier<String> {
  factory Global() => _instance;

  Global._internal() {
    _athleteList = [];
  }
  static final Global _instance = Global._internal();

  /// Variables

  List<AthleteScoutModel> _athleteList = [];

  /// Gettters/Setters

  List<AthleteScoutModel> get athleteList => _athleteList;
  set athleteList(List<AthleteScoutModel> list) {
    _athleteList = list;
    notifyListeners('athleteList');
  }
}
