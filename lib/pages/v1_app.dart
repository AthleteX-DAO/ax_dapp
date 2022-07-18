// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/farm/desktop_farm.dart';
import 'package:ax_dapp/pages/pool/add_liquidity/bloc/pool_bloc.dart';
import 'package:ax_dapp/pages/pool/desktop_pool.dart';
import 'package:ax_dapp/pages/scout/bloc/scout_page_bloc.dart';
import 'package:ax_dapp/pages/scout/desktop_scout.dart';
import 'package:ax_dapp/pages/scout/usecases/get_scout_athletes_data_use_case.dart';
import 'package:ax_dapp/pages/trade/bloc/trade_page_bloc.dart';
import 'package:ax_dapp/pages/trade/desktop_trade.dart';
import 'package:ax_dapp/repositories/coin_gecko_repo.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pool_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/athlete.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/create_wallet/web.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:ax_dapp/service/controller/swap/matic.dart';
import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/controller/token.dart';
import 'package:ax_dapp/service/controller/wallet_controller.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/service/widgets_mobile/dropdown_menu.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

enum Pages { scout, trade, pool, farm }

class V1App extends StatefulWidget {
  const V1App({super.key});

  @override
  State<V1App> createState() => _V1AppState();
}

class _V1AppState extends State<V1App> {
  bool isWeb = true;

  // state change variables
  Pages pageNumber = Pages.scout;
  bool isBuyAX = false;
  bool walletConnected =
      false; //flag to check if user has connected their wallet
  bool allFarms = true;
  List<Athlete> athleteList = [];
  Controller controller =
      Get.put(Controller()); // Rather Controller controller = Controller();
  AXT axt = AXT('AthleteX', 'AX');
  Token matic = MATIC('Polygon', 'MATIC');
  late PageController _pageController;
  var _selectedIndex = 0;
  String axText = 'Ax';

  void setPageNumber(Pages page) {
    setState(() {
      pageNumber = page;
      isBuyAX = false;
    });
  }

  void goToTradePage() {
    setState(() {
      pageNumber = Pages.trade;
      isBuyAX = true;
    });
  }

  void animateToPage(int index) {
    // use this to animate to the page
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  Color iconColor(int index) {
    if (index == _selectedIndex) {
      return Colors.white;
    } else {
      return Colors.grey;
    }
  }

  @override
  void initState() {
    // Init the states of everything needed for the whole dapp
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    Get
      ..put(LSPController())
      ..put(SwapController())
      ..put(WalletController())
      ..put(PoolController())
      ..put(WebWallet());
  }

  @override
  Widget build(BuildContext context) {
    //check if device is in landscape and web
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: isWeb ? topNavBar(context) : topNavBarAndroid(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blurredBackground.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: buildUI(context),
      ),
      bottomNavigationBar:
          isWeb ? bottomNavBarDesktop(context) : bottomNavBarAndroid(context),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildUI(BuildContext context) {
    if (isWeb) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (pageNumber == Pages.scout)
            BlocProvider(
              create: (BuildContext context) => ScoutPageBloc(
                repo: GetScoutAthletesDataUseCase(
                  graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
                  sportsRepos: [
                    RepositoryProvider.of<MLBRepo>(context),
                  ],
                  coinGeckoRepo: RepositoryProvider.of<CoinGeckoRepo>(context),
                ),
              ),
              child: DesktopScout(goToTradePage: goToTradePage),
            )
          else if (pageNumber == Pages.trade)
            BlocProvider(
              create: (BuildContext context) => TradePageBloc(
                repo: RepositoryProvider.of<GetSwapInfoUseCase>(context),
                controller: Get.find(),
                swapController: Get.find(),
                walletController: Get.find(),
                isBuyAX: isBuyAX,
              ),
              child: const DesktopTrade(),
            )
          else if (pageNumber == Pages.pool)
            const DesktopPool()
          else if (pageNumber == Pages.farm)
            const DesktopFarm()
        ],
      );
    } else {
      return PageView(
        controller: _pageController,
        onPageChanged: _onItemTapped,
        children: <Widget>[
          BlocProvider(
            create: (BuildContext context) => ScoutPageBloc(
              repo: GetScoutAthletesDataUseCase(
                graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
                sportsRepos: [
                  RepositoryProvider.of<MLBRepo>(context),
                ],
                coinGeckoRepo: RepositoryProvider.of<CoinGeckoRepo>(context),
              ),
            ),
            child: DesktopScout(goToTradePage: goToTradePage),
          ),
          BlocProvider(
            create: (BuildContext context) => TradePageBloc(
              repo: RepositoryProvider.of<GetSwapInfoUseCase>(context),
              controller: Get.find(),
              swapController: Get.find(),
              walletController: Get.find(),
              isBuyAX: isBuyAX,
            ),
            child: const DesktopTrade(),
          ),
          BlocProvider(
            create: (BuildContext context) => PoolBloc(
              repo: RepositoryProvider.of<GetPoolInfoUseCase>(context),
              walletController: Get.find(),
              poolController: Get.find(),
            ),
            child: const DesktopPool(),
          ),
          const DesktopFarm(),
        ],
      );
    }
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
                    if (pageNumber != Pages.scout) {
                      setPageNumber(Pages.scout);
                    }
                  },
                  child: Text(
                    'Scout',
                    style: textSwapState(
                      pageNumber == Pages.scout,
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
                    if (pageNumber != Pages.trade) {
                      setPageNumber(Pages.trade);
                    }
                  },
                  child: Text(
                    'Trade',
                    style: textSwapState(
                      pageNumber == Pages.trade,
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
                    if (pageNumber != Pages.pool) {
                      setPageNumber(Pages.pool);
                    }
                  },
                  child: Text(
                    'Pool',
                    style: textSwapState(
                      pageNumber == Pages.pool,
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
                    if (pageNumber != Pages.farm) {
                      setPageNumber(Pages.farm);
                    }
                  },
                  child: Text(
                    'Farm',
                    style: textSwapState(
                      pageNumber == Pages.farm,
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
          if (!controller.walletConnected ||
              (controller.walletConnected &&
                  !Controller.supportedChains
                      .containsKey(controller.networkID.value))) ...[
            // top Connect Wallet Button
            buildConnectWalletButton(),
          ] else ...[
            //top right corner wallet information
            buildAccountBox()
          ]
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
        children: <Widget>[
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
            children: <Widget>[
              if (!controller.walletConnected ||
                  (controller.walletConnected &&
                      !Controller.supportedChains
                          .containsKey(controller.networkID.value))) ...[
                // top Connect Wallet Button
                buildConnectWalletButton(),
              ] else ...[
                //top right corner wallet information
                buildAccountBox()
              ],
              const DropdownMenuMobile(),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomNavBarDesktop(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        _onItemTapped(index);
        // Need animate function because we are not using _selectedIndex to
        // build mobile UI
        animateToPage(index);
      },
    );
  }

  Widget buildConnectWalletButton() {
    final _width = MediaQuery.of(context).size.width;
    var width = 180.0;
    var text = 'Connect Wallet';
    if (_width < 565) {
      width = 110;
      text = 'Connect';
    }

    return Container(
      height: 37.5,
      width: width,
      decoration: boxDecoration(Colors.transparent, 100, 2, Colors.amber[400]!),
      child: TextButton(
        onPressed: () => showDialog<void>(
          context: context,
          builder: walletDialog,
        ).then((value) => setState(() {})),
        child: Text(
          text,
          style: textStyle(Colors.amber[400]!, 16, true, false),
        ),
      ),
    );
  }

  Widget buildAccountBox() {
    final _width = MediaQuery.of(context).size.width;
    var width = 350.0;
    var matic = true;

    if (_width < 835) {
      matic = false;
      width = 200;
    }
    if (_width < 665) {
      width = 100;
    }

    final accNum = controller.publicAddress.value.toString();
    var retStr = accNum;
    if (accNum.length > 15) {
      retStr =
          '''${accNum.substring(0, 7)}...${accNum.substring(accNum.length - 5, accNum.length)}''';
    }

    return Container(
      height: isWeb ? 30 : 40,
      width: width,
      decoration: boxDecoration(Colors.black, 10, 2, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (matic)
            TextButton(
              onPressed: () {
                controller.getCurrentGas();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Icon(
                    Icons.local_gas_station,
                    color: Colors.grey,
                  ),
                  Obx(
                    () => Text(
                      '${controller.gasString} gwei',
                      style: textStyle(Colors.grey[400]!, 11, false, false),
                    ),
                  )
                ],
              ),
            ),
          TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: yourAXDialog,
            ).then((value) => setState(() {})),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('../assets/images/X_white.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  axText,
                  style: textStyle(Colors.grey[400]!, 11, false, false),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: accountDialog,
            ).then((value) => setState(() {})),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.grey,
                ),
                Text(
                  retStr,
                  style: textStyle(Colors.grey[400]!, 11, false, false),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    // ignore: curly_braces_in_flow_control_structures
    if (isBold) if (isUline) {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.underline,
      );
    } else {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    }
    else if (isUline) {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        decoration: TextDecoration.underline,
      );
    } else {
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
    }
  }

  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition) return tru;
    return fls;
  }
}
