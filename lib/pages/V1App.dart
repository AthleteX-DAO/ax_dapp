import 'package:ax_dapp/pages/farm/DesktopFarm.dart';
import 'package:ax_dapp/pages/pool/AddLiquidity/bloc/PoolBloc.dart';
import 'package:ax_dapp/pages/pool/DesktopPool.dart';
import 'package:ax_dapp/pages/scout/DesktopScout.dart';
import 'package:ax_dapp/pages/scout/bloc/ScoutPageBloc.dart';
import 'package:ax_dapp/pages/scout/usecases/GetScoutAthletesDataUseCase.dart';
import 'package:ax_dapp/pages/trade/DesktopTrade.dart';
import 'package:ax_dapp/pages/trade/bloc/TradePageBloc.dart';
import 'package:ax_dapp/repositories/CoinGeckoRepo.dart';
import 'package:ax_dapp/repositories/MlbRepo.dart';
import 'package:ax_dapp/repositories/subgraph/SubGraphRepo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetPoolInfoUseCase.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetSwapInfoUseCase.dart';
import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Pool/PoolController.dart';
import 'package:ax_dapp/service/Controller/Scout/LSPController.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';
import 'package:ax_dapp/service/Controller/Swap/SwapController.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:ax_dapp/service/Controller/createWallet/web.dart';
import 'package:ax_dapp/service/Controller/usecases/GetChainChangesUseCase.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:ax_dapp/service/widgets_mobile/DropdownMenu.dart';
import 'package:ax_dapp/util/EthereumChainWrapper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web3/flutter_web3.dart' as FlutterWeb3;

class V1App extends StatefulWidget {
  @override
  _V1AppState createState() => _V1AppState();
}

class _V1AppState extends State<V1App> {
  bool isWeb = true;

  // state change variables
  int pageNumber = 0;
  bool walletConnected =
      false; //flag to check if user has connected their wallet
  bool allFarms = true;
  List<Athlete> athleteList = [];
  Controller controller =
      Get.put(Controller()); // Rather Controller controller = Controller();
  AXT axt = AXT("AthleteX", "AX");
  Token matic = MATIC("Polygon", "MATIC");
  late PageController _pageController;
  var _selectedIndex = 0;
  List<String> dropDownMenuItems = ["Matic Network", "SX Network"];
  String selectVal = "Matic Network";
  String axText = "Ax";

  animateToPage(int index) {
    // use this to animate to the page
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.ease);
  }

  iconColor(int index) {
    if (index == _selectedIndex) {
      return Colors.white;
    } else
      return Colors.grey;
  }

  @override
  void initState() {
    // Init the states of everything needed for the whole dapp
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    Get.put(LSPController());
    Get.put(SwapController());
    Get.put(WalletController());
    Get.put(PoolController());
    Get.put(WebWallet());
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
        title: isWeb ? topNavBar(context) : topNavBarAndroid(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blurredBackground.png"),
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
          if (pageNumber == 0)
            BlocProvider(
                create: (BuildContext context) => ScoutPageBloc(
                    chainChangeUseCase:
                        GetChainChangesUseCase(EthereumWebChainWrapper()),
                    repo: GetScoutAthletesDataUseCase(
                      graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
                      sportsRepos: [RepositoryProvider.of<MLBRepo>(context)],
                      coinGeckoRepo:
                          RepositoryProvider.of<CoinGeckoRepo>(context),
                    )),
                child: DesktopScout())
          else if (pageNumber == 1)
            BlocProvider(
                create: (BuildContext context) => TradePageBloc(
                      repo: RepositoryProvider.of<GetSwapInfoUseCase>(context),
                      swapController: Get.find(),
                      walletController: Get.find(),
                    ),
                child: DesktopTrade())
          else if (pageNumber == 2)
            // BlocProvider(
            //     create: (BuildContext context) => PoolBloc(
            //         repo: RepositoryProvider.of<GetPoolInfoUseCase>(context),
            //         walletController: Get.find(),
            //         poolController: Get.find()),
            //     child: DesktopPool())
            DesktopPool()
          else if (pageNumber == 3)
            DesktopFarm()
        ],
      );
    } else {
      return PageView(
        controller: _pageController,
        onPageChanged: _onItemTapped,
        children: <Widget>[
          BlocProvider(
              create: (BuildContext context) => ScoutPageBloc(
                  chainChangeUseCase:
                      GetChainChangesUseCase(EthereumWebChainWrapper()),
                  repo: GetScoutAthletesDataUseCase(
                    graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
                    sportsRepos: [RepositoryProvider.of<MLBRepo>(context)],
                    coinGeckoRepo:
                        RepositoryProvider.of<CoinGeckoRepo>(context),
                  )),
              child: DesktopScout()),
          BlocProvider(
            create: (BuildContext context) => TradePageBloc(
              repo: RepositoryProvider.of<GetSwapInfoUseCase>(context),
              swapController: Get.find(),
              walletController: Get.find(),
            ),
            child: DesktopTrade(),
          ),
          BlocProvider(
              create: (BuildContext context) => PoolBloc(
                  repo: RepositoryProvider.of<GetPoolInfoUseCase>(context),
                  walletController: Get.find(),
                  poolController: Get.find()),
              child: DesktopPool()),
          DesktopFarm(),
        ],
      );
    }
  }

  Widget topNavBar(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double tabTxSz = _width * 0.0185;
    if (tabTxSz < 19) tabTxSz = 19;
    double tabBxSz = _width * 0.3;
    if (tabBxSz < 350) tabBxSz = 350;

    return Container(
      width: _width * .95,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Tabs
          Container(
              width: tabBxSz,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 72,
                      height: 50,
                      child: IconButton(
                        icon: Image.asset("assets/images/x.png"),
                        iconSize: 40,
                        onPressed: () {
                          Uri urlString = Uri.parse('https://www.athletex.io/');
                          launchUrl(urlString);
                        },
                      ),
                    ),
                    Container(
                        child: TextButton(
                            onPressed: () {
                              if (pageNumber != 0)
                                setState(() {
                                  pageNumber = 0;
                                });
                            },
                            child: Text("Scout",
                                style: textSwapState(
                                    pageNumber == 0,
                                    textStyle(
                                        Colors.white, tabTxSz, true, false),
                                    textStyle(Colors.amber[400]!, tabTxSz, true,
                                        true))))),
                    Container(
                        child: TextButton(
                            onPressed: () {
                              if (pageNumber != 1)
                                setState(() {
                                  pageNumber = 1;
                                });
                            },
                            child: Text("Trade",
                                style: textSwapState(
                                    pageNumber == 1,
                                    textStyle(
                                        Colors.white, tabTxSz, true, false),
                                    textStyle(Colors.amber[400]!, tabTxSz, true,
                                        true))))),
                    Container(
                        child: TextButton(
                            onPressed: () {
                              if (pageNumber != 2)
                                setState(() {
                                  pageNumber = 2;
                                });
                            },
                            child: Text("Pool",
                                style: textSwapState(
                                    pageNumber == 2,
                                    textStyle(
                                        Colors.white, tabTxSz, true, false),
                                    textStyle(Colors.amber[400]!, tabTxSz, true,
                                        true))))),
                    Container(
                        child: TextButton(
                            onPressed: () {
                              if (pageNumber != 3)
                                setState(() {
                                  pageNumber = 3;
                                });
                            },
                            child: Text("Farm",
                                style: textSwapState(
                                    pageNumber == 3,
                                    textStyle(
                                        Colors.white, tabTxSz, true, false),
                                    textStyle(Colors.amber[400]!, tabTxSz, true,
                                        true))))),
                  ])),
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
    return Container(
      // color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      //height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Image.asset("assets/images/x.png"),
            iconSize: 40,
            onPressed: () {
              String urlString = "https://www.athletex.io/";
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
              DropdownMenuMobile(),
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
      padding: const EdgeInsets.only(left: 40.0, top: 0.0, right: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  // margin: ,
                  child: InkWell(
                    child: Text('athletex.io'),
                    onTap: () =>
                        launchUrl(Uri.parse('https://www.athletex.io/')),
                  ),
                  width: 72,
                  height: 20,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: () =>
                              //Discord button
                              launchUrl(Uri.parse(
                                  'https://discord.com/invite/WFsyAuzp9V')),
                          icon: FaIcon(
                            FontAwesomeIcons.discord,
                            size: 25,
                            color: Colors.grey[400],
                          )),
                      IconButton(
                          onPressed: () => launchUrl(Uri.parse(
                              'https://twitter.com/athletex_dao?s=20')),
                          icon: FaIcon(
                            FontAwesomeIcons.twitter,
                            size: 25,
                            color: Colors.grey[400],
                          )),
                      IconButton(
                          onPressed: () => launchUrl(
                              Uri.parse('https://github.com/SportsToken')),
                          icon: FaIcon(
                            FontAwesomeIcons.github,
                            size: 25,
                            color: Colors.grey[400],
                          )),
                    ],
                  ),
                ),
                // Help icon button, temporarily delete
                // IconButton(
                //   onPressed: () {},
                //   hoverColor: Colors.amber,
                //   icon: Icon(
                //     Icons.help_outline,
                //   ),
                //   color: Colors.white,
                //   iconSize: 25,
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bottomNavBarAndroid(BuildContext context) {
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
        //Need animate function because we are not using _selectedIndex to build mobile UI
        animateToPage(index);
      },
    );
  }

  Widget buildConnectWalletButton() {
    double _width = MediaQuery.of(context).size.width;
    double wid = 180;
    String text = "Connect Wallet";
    if (_width < 565) {
      wid = 110;
      text = "Connect";
    }

    return Container(
        height: 37.5,
        width: wid,
        decoration:
            boxDecoration(Colors.transparent, 100, 2, Colors.amber[400]!),
        child: TextButton(
            onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => walletDialog(context))
                .then((value) => setState(() {})),
            child: Text(
              text,
              style: textStyle(Colors.amber[400]!, 16, true, false),
            )));
  }

  Widget buildAccountBox() {
    double _width = MediaQuery.of(context).size.width;
    double wid = 500;
    bool network = true;
    bool matic = true;

    if (_width < 835) {
      matic = false;
      wid = 350;
    }
    if (_width < 665) {
      network = false;
      wid = 210;
    }

    String accNum = controller.publicAddress.value.toString();
    String retStr = accNum;
    if (accNum.length > 15)
      retStr = accNum.substring(0, 7) +
          "..." +
          accNum.substring(accNum.length - 5, accNum.length);

    return Container(
        height: isWeb ? 30 : 40,
        width: wid,
        decoration: boxDecoration(Colors.black, 10, 2, Colors.grey[400]!),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (network)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Icon(
                    Icons.link,
                    color: Colors.grey,
                  ),
                  DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        dropdownColor: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 1,
                        value: selectVal,
                        items: dropDownMenuItems.map((itemOne) {
                          return DropdownMenuItem(
                              enabled: false,
                              value: itemOne,
                              child: Text(itemOne));
                        }).toList(),
                        onChanged: (value) {},
                      ),
                    ),
                  )
                ],
              ),
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
                    Obx(() => Text(
                          "${controller.gasString} gwei",
                          style: textStyle(Colors.grey[400]!, 11, false, false),
                        ))
                  ],
                ),
              ),
            TextButton(
              onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => yourAXDialog(context))
                  .then((value) => (setState(() {}))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("../assets/images/X_white.png"),
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
              onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => accountDialog(context))
                  .then((value) => setState(() {})),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
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
        ));
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold) if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    else if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
  }

  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition) return tru;
    return fls;
  }
}
