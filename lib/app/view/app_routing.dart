import 'package:ax_dapp/add_liquidity/bloc/add_liquidity_bloc.dart';
import 'package:ax_dapp/app/bloc/app_bloc.dart';
import 'package:ax_dapp/athlete/bloc/athlete_page_bloc.dart';
import 'package:ax_dapp/athlete/view/athlete_page.dart';
import 'package:ax_dapp/debug/views/debug_app_wrapper.dart';
import 'package:ax_dapp/pages/farm/bloc/farm_bloc.dart';
import 'package:ax_dapp/pages/farm/desktop_farm.dart';
import 'package:ax_dapp/pages/farm/usecases/get_farm_data_use_case.dart';
import 'package:ax_dapp/pages/landing_page/landing_page.dart';
import 'package:ax_dapp/pages/trade/bloc/trade_page_bloc.dart';
import 'package:ax_dapp/pages/trade/desktop_trade.dart';
import 'package:ax_dapp/pool/view/desktop_pool.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/nfl_repo.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pool_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/scout/bloc/scout_page_bloc.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/scout/usecases/usecases.dart';
import 'package:ax_dapp/scout/view/desktop_scout.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:config_repository/config_repository.dart';
import 'package:ethereum_api/gysr_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:tracking_repository/tracking_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.configRepository,
  });

  final ConfigRepository configRepository;

  @override
  // ignore: no_logic_in_create_state
  State<App> createState() => _AppState(configRepository: configRepository);
}

class _AppState extends State<App> {
  _AppState({
    required this.configRepository,
  });

  final ConfigRepository configRepository;

  final Global global = Global();
  List<AthleteScoutModel> athleteList = [];
  AthleteScoutModel? curAthlete;
  String curPage = 'landing';
  Controller controller = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    curPage = global.page;
    Get
      ..put(LSPController())
      ..put(SwapController())
      ..put(PoolController());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppBloc(
            walletRepository: context.read<WalletRepository>(),
            tokensRepository: context.read<TokensRepository>(),
            configRepository: configRepository,
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => WalletBloc(
            walletRepository: context.read<WalletRepository>(),
            tokensRepository: context.read<TokensRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => TrackingCubit(
            context.read<TrackingRepository>(),
          )..setup(),
        )
      ],
      child: kDebugMode
          ? DebugAppWrapper(
              home: MaterialApp.router(
                routerConfig: _router,
                title: 'AthleteX',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  canvasColor: Colors.transparent,
                  brightness: Brightness.dark,
                  primaryColor: Colors.yellow[700],
                  colorScheme:
                      ColorScheme.fromSwatch(brightness: Brightness.dark)
                          .copyWith(secondary: Colors.black),
                ),
              ),
            )
          : MaterialApp.router(
              routerConfig: _router,
              title: 'AthleteX',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                canvasColor: Colors.transparent,
                brightness: Brightness.dark,
                primaryColor: Colors.yellow[700],
                colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
                    .copyWith(secondary: Colors.black),
              ),
            ),
    );
  }

  // router
  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        name: 'landing',
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LandingPage(),
        ),
      ),
      GoRoute(
        name: 'scout',
        path: '/scout',
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: BlocProvider(
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
              child: const DesktopScout(),
            ),
          );
        },
        routes: [
          GoRoute(
            name: 'athlete',
            path: 'athlete/:id',
            pageBuilder: (context, state) {
              return MaterialPage(
                key: state.pageKey,
                child: AthletePage(athlete: _toAthlete(state.params['id']!)),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: 'trade',
        path: '/trade',
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: BlocProvider(
              create: (BuildContext context) => TradePageBloc(
                walletRepository: context.read<WalletRepository>(),
                streamAppDataChanges:
                    context.read<StreamAppDataChangesUseCase>(),
                repo: RepositoryProvider.of<GetSwapInfoUseCase>(context),
                swapController: Get.find(),
                //isBuyAX: isBuyAX,
                isBuyAX: false,
              ),
              child: const DesktopTrade(),
            ),
          );
        },
      ),
      GoRoute(
        name: 'pool',
        path: '/pool',
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: BlocProvider(
              create: (BuildContext context) => AddLiquidityBloc(
                walletRepository: context.read<WalletRepository>(),
                tokensRepository: context.read<TokensRepository>(),
                streamAppDataChanges:
                    context.read<StreamAppDataChangesUseCase>(),
                repo: RepositoryProvider.of<GetPoolInfoUseCase>(context),
                poolController: Get.find(),
              ),
              child: const DesktopPool(),
            ),
          );
        },
      ),
      GoRoute(
        name: 'farm',
        path: '/farm',
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: BlocProvider(
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
            ),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(child: Text(state.error.toString())),
      ),
    ),
  );
}

AthleteScoutModel? _toAthlete(String id) {
  for (final athlete in Global().athleteList) {
    if ((athlete.id.toString() + athlete.name) == id) {
      return athlete;
    }
  }
  return null;
}
