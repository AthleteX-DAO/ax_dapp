import 'package:ax_dapp/add_liquidity/bloc/add_liquidity_bloc.dart';
import 'package:ax_dapp/app/bloc/app_bloc.dart';
import 'package:ax_dapp/athlete/view/athlete_page.dart';
import 'package:ax_dapp/chat_box/chat_box_wrapper.dart';
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
import 'package:ax_dapp/repositories/usecases/get_all_liquidity_info_use_case.dart';
import 'package:ax_dapp/scout/bloc/scout_page_bloc.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/scout/usecases/get_scout_athletes_data_use_case.dart';
import 'package:ax_dapp/scout/view/scout_base.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/pool/pool_controller.dart';
import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/controller/swap/swap_controller.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/wallet.dart';
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

class App extends StatelessWidget {
  const App({
    super.key,
    required this.configRepository,
  });

  final ConfigRepository configRepository;

  @override
  Widget build(BuildContext context) {
    Get
      ..put(Controller())
      ..put(LSPController())
      ..put(SwapController())
      ..put(PoolController());

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
      child: const _MaterialApp(),
    );
  }
}

class _MaterialApp extends StatelessWidget {
  // ignore: use_super_parameters
  const _MaterialApp();

  @override
  Widget build(BuildContext context) {
    final isWebMobile = kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    final _appRouter = MaterialApp.router(
      title: 'AthleteX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.transparent,
        brightness: Brightness.dark,
        primaryColor: Colors.yellow[700],
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
            .copyWith(secondary: Colors.black),
      ),
      routerConfig: GoRouter(
        // ignore: body_might_complete_normally_nullable
        redirect: (context, state) async {
          if (notLanding(state.location) &&
              (await context.read<WalletRepository>().searchForWallet() ??
                  false)) {
            context.read<WalletBloc>().add(const ConnectWalletRequested());
          }

          if (state.location.contains('/athlete') &&
              Global().athleteList.isEmpty) {
            return '/scout';
          }
        },
        routes: <GoRoute>[
          GoRoute(
            name: 'landing',
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return const LandingPage();
            },
          ),
          GoRoute(
            name: 'scout',
            path: '/scout',
            builder: (BuildContext context, GoRouterState state) {
              Global().page = 'scout';
              return BlocProvider(
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
              );
            },
            routes: [
              GoRoute(
                name: 'athlete',
                path: 'athlete/:id',
                builder: (BuildContext context, GoRouterState state) {
                  Global().page = 'athlete';
                  return AthletePage(athlete: _toAthlete(state.params['id']!));
                },
              ),
            ],
          ),
          GoRoute(
            name: 'trade',
            path: '/trade',
            builder: (BuildContext context, GoRouterState state) {
              Global().page = 'trade';
              return BlocProvider(
                create: (BuildContext context) => TradePageBloc(
                  walletRepository: context.read<WalletRepository>(),
                  streamAppDataChanges:
                      context.read<StreamAppDataChangesUseCase>(),
                  repo: RepositoryProvider.of<GetSwapInfoUseCase>(context),
                  swapController: Get.find(),
                  isBuyAX: false,
                ),
                child: const DesktopTrade(),
              );
            },
          ),
          GoRoute(
            name: 'pool',
            path: '/pool',
            builder: (BuildContext context, GoRouterState state) {
              Global().page = 'pool';
              return BlocProvider(
                create: (BuildContext context) => AddLiquidityBloc(
                  walletRepository: context.read<WalletRepository>(),
                  tokensRepository: context.read<TokensRepository>(),
                  streamAppDataChanges:
                      context.read<StreamAppDataChangesUseCase>(),
                  repo: RepositoryProvider.of<GetPoolInfoUseCase>(context),
                  getAllLiquidityInfoUseCase:
                      RepositoryProvider.of<GetAllLiquidityInfoUseCase>(
                    context,
                  ),
                  poolController: Get.find(),
                ),
                child: const DesktopPool(),
              );
            },
          ),
          GoRoute(
            name: 'farm',
            path: '/farm',
            builder: (BuildContext context, GoRouterState state) {
              Global().page = 'farm';
              return BlocProvider(
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
              );
            },
          ),
        ],
        errorPageBuilder: (context, state) => MaterialPage(
          key: UniqueKey(),
          child: Scaffold(
            body: Center(child: Text(state.error.toString())),
          ),
        ),
      ),
    );

    return kDebugMode
        ? DebugAppWrapper(home: _appRouter)
        : (isWebMobile
            ? _appRouter
            : ChatBoxWrapper(
                home: _appRouter,
              ));
  }

  AthleteScoutModel? _toAthlete(String id) {
    for (final athlete in Global().athleteList) {
      if ((athlete.id.toString() + athlete.name) == id) {
        return athlete;
      }
    }
    return null;
  }

  bool notLanding(String location) {
    return location.contains('scout') ||
        location.contains('athlete') ||
        location.contains('trade') ||
        location.contains('pool') ||
        location.contains('farm');
  }
}
