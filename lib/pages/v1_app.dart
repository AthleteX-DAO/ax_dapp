// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/add_liquidity/add_liquidity.dart';
import 'package:ax_dapp/app/bloc/app_bloc.dart';
import 'package:ax_dapp/pages/farm/bloc/farm_bloc.dart';
import 'package:ax_dapp/pages/farm/desktop_farm.dart';
import 'package:ax_dapp/pages/farm/usecases/get_farm_data_use_case.dart';
import 'package:ax_dapp/pages/footer/simple_tool_tip.dart';
import 'package:ax_dapp/pages/trade/bloc/trade_page_bloc.dart';
import 'package:ax_dapp/pages/trade/desktop_trade.dart';
import 'package:ax_dapp/pool/pool.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/nfl_repo.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pool_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/repositories/usecases/get_all_liquidity_info_use_case.dart';
import 'package:ax_dapp/scout/scout.dart';
import 'package:ax_dapp/scout/view/scout_base.dart';
import 'package:ax_dapp/service/athlete.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/widgets_mobile/dropdown_menu.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:ethereum_api/gysr_api.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

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

  void goToPage(int page) {
    setState(() {
      pageNumber = Pages.values[page];
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
      ..put(PoolController());
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
                tokenRepository: context.read<TokensRepository>(),
                walletRepository: context.read<WalletRepository>(),
                streamAppDataChanges:
                    context.read<StreamAppDataChangesUseCase>(),
                repo: GetScoutAthletesDataUseCase(
                  tokensRepository: context.read<TokensRepository>(),
                  graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
                  sportsRepos: [
                    RepositoryProvider.of<MLBRepo>(context),
                    RepositoryProvider.of<NFLRepo>(context),
                  ],
                ),
              ),
              child: const Scout(),
            )
          else if (pageNumber == Pages.trade)
            BlocProvider(
              create: (BuildContext context) => TradePageBloc(
                walletRepository: context.read<WalletRepository>(),
                streamAppDataChanges:
                    context.read<StreamAppDataChangesUseCase>(),
                repo: RepositoryProvider.of<GetSwapInfoUseCase>(context),
                swapController: Get.find(),
                isBuyAX: isBuyAX,
              ),
              child: const DesktopTrade(),
            )
          else if (pageNumber == Pages.pool)
            const DesktopPool()
          else if (pageNumber == Pages.farm)
            BlocProvider(
              create: (BuildContext context) => FarmBloc(
                walletRepository: context.read<WalletRepository>(),
                tokensRepository: context.read<TokensRepository>(),
                configRepository: context.read<AppBloc>().configRepository,
                streamAppDataChanges:
                    context.read<StreamAppDataChangesUseCase>(),
                repo: GetFarmDataUseCase(
                  gysrApiClient: context.read<GysrApiClient>(),
                ),
              ),
              child: const DesktopFarm(),
            )
        ],
      );
    } else {
      return PageView(
        controller: _pageController,
        onPageChanged: _onItemTapped,
        children: <Widget>[
          BlocProvider(
            create: (BuildContext context) => ScoutPageBloc(
              tokenRepository: context.read<TokensRepository>(),
              walletRepository: context.read<WalletRepository>(),
              streamAppDataChanges: context.read<StreamAppDataChangesUseCase>(),
              repo: GetScoutAthletesDataUseCase(
                tokensRepository: context.read<TokensRepository>(),
                graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
                sportsRepos: [
                  RepositoryProvider.of<MLBRepo>(context),
                  RepositoryProvider.of<NFLRepo>(context),
                ],
              ),
            ),
            child: const Scout(),
          ),
          BlocProvider(
            create: (BuildContext context) => TradePageBloc(
              walletRepository: context.read<WalletRepository>(),
              streamAppDataChanges: context.read<StreamAppDataChangesUseCase>(),
              repo: RepositoryProvider.of<GetSwapInfoUseCase>(context),
              swapController: Get.find(),
              isBuyAX: isBuyAX,
            ),
            child: const DesktopTrade(),
          ),
          BlocProvider(
            create: (BuildContext context) => AddLiquidityBloc(
              walletRepository: context.read<WalletRepository>(),
              tokensRepository: context.read<TokensRepository>(),
              streamAppDataChanges: context.read<StreamAppDataChangesUseCase>(),
              repo: RepositoryProvider.of<GetPoolInfoUseCase>(context),
              getAllLiquidityInfoUseCase: RepositoryProvider.of<GetAllLiquidityInfoUseCase>(context),
              poolController: Get.find(),
            ),
            child: const DesktopPool(),
          ),
          BlocProvider(
            create: (BuildContext context) => FarmBloc(
              walletRepository: context.read<WalletRepository>(),
              tokensRepository: context.read<TokensRepository>(),
              configRepository: context.read<AppBloc>().configRepository,
              streamAppDataChanges: context.read<StreamAppDataChangesUseCase>(),
              repo: GetFarmDataUseCase(
                gysrApiClient: context.read<GysrApiClient>(),
              ),
            ),
            child: const DesktopFarm(),
          )
        ],
      );
    }
  }

  Widget topNavBar(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var tabTxSz = _width * 0.0185;
    if (tabTxSz < 19) tabTxSz = 19;
    var tabBxSz = _width * 0.35;
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
                TextButton(
                  onPressed: () {
                    final urlString =
                        Uri.parse('https://snapshot.org/#/athletex.eth');
                    launchUrl(urlString);
                  },
                  child: Text(
                    'Vote',
                    style: textStyle(
                      Colors.white,
                      tabTxSz,
                      true,
                      false,
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
                IconButton(
                  onPressed: () => launchUrl(
                    Uri.parse(
                      'https://www.instagram.com/athletexmarkets/?hl=en',
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.instagram,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                IconButton(
                  onPressed: () => launchUrl(
                    Uri.parse(
                      'https://www.tiktok.com/@athlete_x',
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.tiktok,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AppToolTip(
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

  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition) return tru;
    return fls;
  }
}
