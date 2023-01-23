import 'package:ax_dapp/add_liquidity/add_liquidity.dart';
import 'package:ax_dapp/app/bloc/app_bloc.dart';
import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/pages/farm/bloc/farm_bloc.dart';
import 'package:ax_dapp/pages/farm/desktop_farm.dart';
import 'package:ax_dapp/pages/farm/usecases/get_farm_data_use_case.dart';
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
import 'package:ax_dapp/service/global.dart';
import 'package:ethereum_api/gysr_api.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

enum Pages { scout, trade, pool, farm }

class V1App extends StatefulWidget {
  const V1App({super.key});

  @override
  State<V1App> createState() => _V1AppState();
}

class _V1AppState extends State<V1App> {
  Global global = Global();
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
        title: isWeb
            ? TopNavigationBarWeb(
                page: global.pageName,
              )
            : const TopNavigationBarMobile(),
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
      bottomNavigationBar: isWeb
          ? const BottomNavigationBarWeb()
          : BottomNavigationBarMobile(
              selectedIndex: global.selectedIndex,
            ),
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
              getAllLiquidityInfoUseCase:
                  RepositoryProvider.of<GetAllLiquidityInfoUseCase>(context),
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
}
