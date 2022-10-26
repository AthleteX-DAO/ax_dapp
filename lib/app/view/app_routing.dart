import 'package:ax_dapp/athlete/view/athlete_page.dart';
import 'package:ax_dapp/pages/farm/desktop_farm.dart';
import 'package:ax_dapp/pages/landing_page/landing_page.dart';
import 'package:ax_dapp/pages/trade/desktop_trade.dart';
import 'package:ax_dapp/pool/view/desktop_pool.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/nfl_repo.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/scout/bloc/scout_page_bloc.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/scout/usecases/usecases.dart';
import 'package:ax_dapp/scout/view/desktop_scout.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:config_repository/config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.configRepository,
  });

  final ConfigRepository configRepository;

  @override
  State<App> createState() => _AppState();
/*

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
          ? const DebugAppWrapper(
              home: _MaterialApp(),
            )
          : const _MaterialApp(),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  */
}

class _AppState extends State<App> {
  final Global global = Global();
  List<AthleteScoutModel> athleteList = [];
  AthleteScoutModel? curAthlete;
  String curPage = 'landing';

  @override
  void initState() {
    curPage = global.page;
    global
      ..addListener(_athleteListListener)
      ..addListener(_curAthleteListener)
      ..addListener(_pageListener);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
          debugPrint('towards scout');
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
            path: ':id',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: AthletePage(),
            ),
          ),
        ],
      ),
      GoRoute(
        name: 'trade',
        path: '/trade',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DesktopTrade(),
        ),
      ),
      GoRoute(
        name: 'pool',
        path: '/pool',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DesktopPool(),
        ),
      ),
      GoRoute(
        name: 'farm',
        path: '/farm',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DesktopFarm(),
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(child: Text(state.error.toString())),
      ),
    ),
  );

  // global listeners
  void _athleteListListener() {
    setState(() {
      athleteList = global.athleteList;
    });
  }

  void _curAthleteListener() {
    setState(() {
      curAthlete = global.curAthlete;
    });
  }

  void _pageListener() {
    setState(() {
      curPage = global.page;
    });
  }
}

/*
class _MaterialApp extends StatelessWidget {
  // ignore: use_super_parameters
  const _MaterialApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AthleteX',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(
        canvasColor: Colors.transparent,
        brightness: Brightness.dark,
        primaryColor: Colors.yellow[700],
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
            .copyWith(secondary: Colors.black),
      ),
      home: const LandingPage(),
    );
  }
}
*/
