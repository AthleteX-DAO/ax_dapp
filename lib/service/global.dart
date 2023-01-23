import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

// singleton class
class Global extends PropertyChangeNotifier<String> {
  factory Global() => _instance;

  Global._internal() {
    _athleteList = [];
    _page = 'landing';
    _selectedIndex = 0;
  }
  static final Global _instance = Global._internal();

  /// Variables

  List<AthleteScoutModel> _athleteList = [];
  String _page = 'landing';
  int _selectedIndex = 0;

  /// Gettters/Setters

  List<AthleteScoutModel> get athleteList => _athleteList;
  set athleteList(List<AthleteScoutModel> list) {
    _athleteList = list;
    notifyListeners('athleteList');
  }

  String get pageName => _page;
  set pageName(String _page) {
    this._page = _page;
    notifyListeners('page');
  }

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int _selectedIndex) {
    this._selectedIndex = _selectedIndex;
    notifyListeners('selectedIndex');
  }

  Scaffold buildPage(BuildContext context, Widget page) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: kIsWeb &&
                (MediaQuery.of(context).orientation == Orientation.landscape)
            ? TopNavigationBarWeb(page: pageName)
            : const TopNavigationBarMobile(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: kIsWeb &&
              (MediaQuery.of(context).orientation == Orientation.landscape)
          ? const BottomNavigationBarWeb()
          : BottomNavigationBarMobile(selectedIndex: selectedIndex),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blurredBackground.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: page,
      ),
    );
  }
}
