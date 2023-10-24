import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

// singleton class
class Global extends PropertyChangeNotifier<String> {
  factory Global() => _instance;

  Global._internal() {
    _liveSportsMarkets = [];
    _athleteList = [];
    _predictions = [];
  }
  static final Global _instance = Global._internal();

  /// Variables
  List<SportsMarketsModel> _liveSportsMarkets = [];
  List<AthleteScoutModel> _athleteList = [];
  List<PredictionModel> _predictions = [];

  /// Gettters/Setters
  List<SportsMarketsModel> get liveSportsMarkets => _liveSportsMarkets;
  List<AthleteScoutModel> get athleteList => _athleteList;
  List<PredictionModel> get predictions => _predictions;

  set liveSportsMarkets(List<SportsMarketsModel> mrkts) {
    _liveSportsMarkets = mrkts;
    notifyListeners('liveSportsMarkets');
  }

  set athleteList(List<AthleteScoutModel> list) {
    _athleteList = list;
    notifyListeners('athleteList');
  }

  set predictions(List<PredictionModel> list) {
    _predictions = list;
    notifyListeners('predictions');
  }
}
