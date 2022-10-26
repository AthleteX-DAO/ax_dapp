import 'package:ax_dapp/pages/footer/simple_tool_tip.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/widgets_mobile/dropdown_menu.dart';
import 'package:ax_dapp/wallet/view/wallet_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

// singleton class
class Global extends PropertyChangeNotifier<String> {
  factory Global() => _instance;

  Global._internal() {
    _athleteList = [];
    _curAthlete = null;
    _page = 'landing';
    _isWeb = true;
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }
  static final Global _instance = Global._internal();

  List<AthleteScoutModel> _athleteList = [];
  AthleteScoutModel? _curAthlete;
  String _page = 'landing';
  bool _isWeb = true;
  int _selectedIndex = 0;
  late PageController _pageController;

  List<AthleteScoutModel> get athleteList => _athleteList;
  set athleteList(List<AthleteScoutModel> list) {
    _athleteList = list;
    notifyListeners('athleteList');
  }

  AthleteScoutModel? get curAthlete => _curAthlete;
  set curAthlete(AthleteScoutModel? _ath) {
    _curAthlete = _ath;
    notifyListeners('curAthlete');
  }

  String get page => _page;
  set page(String _page) {
    this._page = _page;
    notifyListeners('page');
  }

  bool get isWeb => _isWeb;
  set isWeb(bool _isWeb) {
    this._isWeb = _isWeb;
    notifyListeners('isWeb');
  }

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int _selectedIndex) {
    this._selectedIndex = _selectedIndex;
    notifyListeners('selectedIndex');
  }

  /// App-wide elements

  // Background
  BoxDecoration background(BuildContext context) {
    return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/blurredBackground.png'),
        fit: BoxFit.fill,
      ),
    );
  }

  AppBar topNav(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: _isWeb ? topNavBar(context) : topNavBarAndroid(context),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget bottomNav(BuildContext context) {
    return isWeb ? bottomNavBarDesktop(context) : bottomNavBarAndroid(context);
  }

  Widget backgroundNav(BuildContext context, Widget page) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: topNav(context),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: background(context),
        child: page,
      ),
      bottomNavigationBar: bottomNav(context),
    );
  }

  Widget topNavBar(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var tabTxSz = _width * 0.0185;
    if (tabTxSz < 19) tabTxSz = 19;
    var tabBxSz = _width * 0.3;
    if (tabBxSz < 350) tabBxSz = 350;

    return SizedBox(
      width: _width * .95,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Tabs
          SizedBox(
            width: tabBxSz,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 72,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/images/x.png'),
                    iconSize: 40,
                    onPressed: () {
                      final urlString = Uri.parse('https://www.athletex.io/');
                      launchUrl(urlString);
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_page != 'scout') {
                      _page = 'scout';
                      context.goNamed('scout');
                    }
                  },
                  child: Text(
                    'Scout',
                    style: textSwapState(
                      _page == 'scout',
                      textStyle(
                        Colors.white,
                        tabTxSz,
                        true,
                        false,
                      ),
                      textStyle(
                        Colors.amber[400]!,
                        tabTxSz,
                        true,
                        true,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_page != 'trade') {
                      _page = 'trade';
                      context.goNamed('trade');
                    }
                  },
                  child: Text(
                    'Trade',
                    style: textSwapState(
                      _page == 'trade',
                      textStyle(
                        Colors.white,
                        tabTxSz,
                        true,
                        false,
                      ),
                      textStyle(
                        Colors.amber[400]!,
                        tabTxSz,
                        true,
                        true,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_page != 'pool') {
                      _page = 'pool';
                      context.goNamed('pool');
                    }
                  },
                  child: Text(
                    'Pool',
                    style: textSwapState(
                      _page == 'pool',
                      textStyle(
                        Colors.white,
                        tabTxSz,
                        true,
                        false,
                      ),
                      textStyle(
                        Colors.amber[400]!,
                        tabTxSz,
                        true,
                        true,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_page != 'farm') {
                      _page = 'farm';
                      context.goNamed('farm');
                    }
                  },
                  child: Text(
                    'Farm',
                    style: textSwapState(
                      _page == 'farm',
                      textStyle(
                        Colors.white,
                        tabTxSz,
                        true,
                        false,
                      ),
                      textStyle(
                        Colors.amber[400]!,
                        tabTxSz,
                        true,
                        true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const WalletView(),
        ],
      ),
    );
  }

  Widget topNavBarAndroid(BuildContext context) {
    // include the AX logo
    // include the wallet information once the user has connected their wallet
    // include a dropdown menu for the ellipses and add links to them
    // include the divider line
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset('assets/images/x.png'),
            iconSize: 40,
            onPressed: () {
              const urlString = 'https://www.athletex.io/';
              launchUrl(Uri.parse(urlString));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              WalletView(),
              DropdownMenuMobile(),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomNavBarDesktop(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Center(
        child: Row(
          children: [
            Row(
              children: <Widget>[
                SizedBox(
                  width: 72,
                  height: 20,
                  child: InkWell(
                    child: const Text('athletex.io'),
                    onTap: () =>
                        launchUrl(Uri.parse('https://www.athletex.io/')),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      //Discord button
                      launchUrl(
                    Uri.parse(
                      'https://discord.com/invite/WFsyAuzp9V',
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.discord,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                IconButton(
                  onPressed: () => launchUrl(
                    Uri.parse('https://twitter.com/athletex_dao?s=20'),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.twitter,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                IconButton(
                  onPressed: () => launchUrl(
                    Uri.parse('https://github.com/SportsToken'),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.github,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                Container(width: _width - 320),
                AppToolTip(
                  'Invest in what you know best at AthleteX Markets.',
                  IconButton(
                    onPressed: () => launchUrl(
                      Uri.parse(
                        'https://athletex-markets.gitbook.io/athletex-huddle/start-here/litepaper',
                      ),
                    ),
                    icon: FaIcon(
                      FontAwesomeIcons.circleQuestion,
                      size: 25,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar bottomNavBarAndroid(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/search.png',
            height: 24,
            width: 24,
            color: iconColor(0),
          ),
          label: 'Scout',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/swap.png',
            height: 24,
            width: 24,
            color: iconColor(1),
          ),
          label: 'Trade',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/coins.png',
            height: 24,
            width: 24,
            color: iconColor(2),
          ),
          label: 'Pool',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/barn.png',
            height: 24,
            width: 24,
            color: iconColor(3),
          ),
          label: 'Farm',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        _selectedIndex = index;
        // Need animate function because we are not using _selectedIndex to
        // build mobile UI
        animateToPage(index);
      },
    );
  }

  /// common methods

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    // ignore: curly_braces_in_flow_control_structures
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
      fontWeight: isBold ? FontWeight.w400 : null,
      decoration: isUline ? TextDecoration.underline : null,
    );
  }

  // ignore: avoid_positional_boolean_parameters
  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition) return tru;
    return fls;
  }

  Color iconColor(int index) {
    if (index == _selectedIndex) {
      return Colors.white;
    } else {
      return Colors.grey;
    }
  }

  void animateToPage(int index) {
    // use this to animate to the page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }
}