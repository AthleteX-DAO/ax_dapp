import 'package:ax_dapp/app/bloc/app_bloc.dart';
import 'package:ax_dapp/app/view/app_scaffold.dart';
import 'package:ax_dapp/earn/bloc/earn_page_bloc.dart';
import 'package:ax_dapp/earn/view/desktop_earn_page.dart';
import 'package:ax_dapp/service/controller/earn/vault_repository.dart';
import 'package:ax_dapp/athlete_markets/athlete.dart';
import 'package:ax_dapp/perps/bloc/perps_page_bloc.dart';
import 'package:ax_dapp/perps/bloc/perps_trading_bloc.dart';
import 'package:ax_dapp/perps/view/desktop_perpetuals_page.dart';
import 'package:ax_dapp/service/controller/perps/perps_repository.dart';
import 'package:ax_dapp/service/controller/perps/base_sepolia_perps_service.dart';
import 'package:ax_dapp/spot_markets/bloc/bloc.dart';
import 'package:ax_dapp/spot_markets/view/view.dart';
import 'package:ax_dapp/athlete_markets/usecases/get_scout_athletes_data_use_case.dart';
import 'package:ax_dapp/athlete_markets/view/athlete_page.dart';
import 'package:ax_dapp/farm/bloc/farm_bloc.dart';
import 'package:ax_dapp/farm/desktop_farm.dart';
import 'package:ax_dapp/farm/usecases/get_farm_data_use_case.dart';
import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/league_game/views/league_game.dart';
import 'package:ax_dapp/league/league_search/bloc/league_bloc.dart';
import 'package:ax_dapp/league/league_search/views/desktop_league.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/repository/timer_repository.dart';
import 'package:ax_dapp/league/usecases/league_use_case.dart';
import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/predict/bloc/predict_page_bloc.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/usecase/get_prediction_market_data_use_case.dart';
import 'package:ax_dapp/predict/usecase/get_prediction_market_info_use_case.dart';
import 'package:ax_dapp/predict/view/desktop_predict.dart';
import 'package:ax_dapp/prediction/view/prediction_page.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/nfl_repo.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/service/controller/markets/long_short_pair_repository.dart.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:ax_dapp/sports_markets/usecases/get_sports_markets_data_use_case.dart';
import 'package:ax_dapp/sports_markets/view/sports_page.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ethereum_api/gysr_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:league_repository/league_repository.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';
import 'package:web3dart/web3dart.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        name: '/',
        path: '/',
        redirect: (context, state) => '/predict',
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [
          GoRoute(
            name: 'predict',
            path: '/predict',
            builder: (BuildContext context, GoRouterState state) {
              return BlocProvider(
                create: (BuildContext context) => PredictPageBloc(
                  streamAppDataChangesUseCase:
                      context.read<StreamAppDataChangesUseCase>(),
                  eventMarketRepository: context.read<EventMarketRepository>(),
                  getPredictionMarketInfoUseCase:
                      context.read<GetPredictionMarketInfoUseCase>(),
                  getPredictionMarketDataUseCase:
                      context.read<GetPredictionMarketDataUseCase>(),
                ),
                child: const DesktopPredict(),
              );
            },
            routes: [
              GoRoute(
                name: 'prediction',
                path: 'prediction/:id',
                builder: (BuildContext context, GoRouterState state) {
                  final predictionModel = state.extra as PredictionModel? ??
                      _toPrediction(state.pathParameters['id']!);
                  
                  if (predictionModel == null || predictionModel == PredictionModel.empty) {
                    return const Scaffold(
                      body: Center(
                        child: Text('Prediction market not found'),
                      ),
                    );
                  }
                  
                  return PredictionPage(
                    predictionModel: predictionModel,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: 'scout',
            path: '/scout',
            builder: (BuildContext context, GoRouterState state) {
              return BlocProvider(
                create: (BuildContext context) => MarketsPageBloc(
                  tokenRepository: context.read<TokensRepository>(),
                  walletRepository: context.read<WalletRepository>(),
                  streamAppDataChanges:
                      context.read<StreamAppDataChangesUseCase>(),
                  getSportsMarketsDataUseCase:
                      context.read<GetSportsMarketsDataUseCase>(),
                  repo: GetScoutAthletesDataUseCase(
                    tokensRepository: context.read<TokensRepository>(),
                    graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
                    sportsRepos: [
                      RepositoryProvider.of<MLBRepo>(context),
                      RepositoryProvider.of<NFLRepo>(context),
                    ],
                  ),
                  longShortPairRepository:
                      context.read<LongShortPairRepository>(),
                ),
                child: const Scout(),
              );
            },
            routes: [
              GoRoute(
                name: 'athlete',
                path: 'athlete/:id',
                builder: (BuildContext context, GoRouterState state) {
                  return AthletePage(
                    athlete: _findAthleteById(state.pathParameters['id']!),
                  );
                },
              ),
              GoRoute(
                name: 'sports-markets',
                path: 'sport/:name',
                builder: (BuildContext context, GoRouterState state) {
                  return SportsPage(
                    sport:
                        _goToSportsMarketByName(state.pathParameters['name']!),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: 'farm',
            path: '/farm',
            builder: (BuildContext context, GoRouterState state) {
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
          GoRoute(
            name: 'league',
            path: '/league',
            builder: (BuildContext context, GoRouterState state) {
              return const DesktopLeague();
            },
            routes: [
              GoRoute(
                name: 'league-game',
                path: 'league-game/:leagueID',
                builder: (BuildContext context, GoRouterState state) {
                  final leagueID = state.pathParameters['leagueID']!;
                  final leaguesWithTeams =
                      context.watch<LeagueBloc>().state.leaguesWithTeams;
                  if (leaguesWithTeams.isEmpty) return const Loader();
                  final leagueWithTeam = leaguesWithTeams.firstWhere(
                    (leaguePair) => leaguePair.first.leagueID == leagueID,
                  );
                  return BlocProvider(
                    create: (context) => LeagueGameBloc(
                      startDate: leagueWithTeam.first.dateStart,
                      endDate: leagueWithTeam.first.dateEnd,
                      streamAppDataChanges:
                          context.read<StreamAppDataChangesUseCase>(),
                      leagueRepository: context.read<LeagueRepository>(),
                      repo: GetScoutAthletesDataUseCase(
                        tokensRepository: context.read<TokensRepository>(),
                        graphRepo: RepositoryProvider.of<SubGraphRepo>(context),
                        sportsRepos: [
                          RepositoryProvider.of<MLBRepo>(context),
                          RepositoryProvider.of<NFLRepo>(context),
                        ],
                      ),
                      leagueUseCase: context.read<LeagueUseCase>(),
                      timerRepository: context.read<TimerRepository>(),
                      prizePoolRepository: context.read<PrizePoolRepository>(),
                      walletRepository: context.read<WalletRepository>(),
                    ),
                    child: LeagueGame(
                      league: leagueWithTeam.first,
                      leagueID: leagueID,
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: 'earn',
            path: '/earn',
            builder: (BuildContext context, GoRouterState state) {
              final configRepo = context.read<AppBloc>().configRepository;
              final appConfig = configRepo.initializeAppConfig();
              
              return MultiProvider(
                providers: [
                  RepositoryProvider(
                    create: (context) => VaultRepository(
                      chain: EthereumChain.ethereumSepolia,
                      reactiveWeb3Client: appConfig.reactiveWeb3Client,
                      walletRepository: context.read<WalletRepository>(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => EarnPageBloc(
                      walletRepository: context.read<WalletRepository>(),
                      vaultRepository: context.read<VaultRepository>(),
                      configRepository: configRepo,
                    ),
                  ),
                ],
                child: const DesktopEarnPage(),
              );
            },
          ),
          GoRoute(
            name: 'perpetuals',
            path: '/perpetuals',
            builder: (BuildContext context, GoRouterState state) {
              final baseSepoliaWeb3Client = _getBaseSepoliaWeb3Client();
              final walletRepository = context.read<WalletRepository>();
              
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (BuildContext context) => PerpsPageBloc(
                      perpsRepository: PerpsRepository(
                        web3Client: _getWeb3Client(),
                      ),
                    ),
                  ),
                  BlocProvider(
                    create: (BuildContext context) => PerpsTradingBloc(
                      perpsService: BaseSepoliaPerpsService(
                        web3Client: baseSepoliaWeb3Client,
                        walletRepository: walletRepository,
                      ),
                    ),
                  ),
                ],
                child: const DesktopPerpetualsPage(),
              );
            },
          ),
          GoRoute(
            name: 'spot-markets',
            path: '/spot-markets',
            builder: (BuildContext context, GoRouterState state) {
              return BlocProvider(
                create: (BuildContext context) => SpotMarketsBloc(
                  walletRepository: context.read<WalletRepository>(),
                ),
                child: const DesktopSpotMarketsPage(),
              );
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      // These fix redirects a page back to the markest list if a user refreshes
      if (state.uri.toString().contains('/athlete') &&
          Global().athleteList.isEmpty) {
        return '/scout';
      }
      // if (state.location.contains('/prediction') &&
      //     Global().predictions.isEmpty) {
      //   return '/predict';
      // }
      return null;
    },
    errorPageBuilder: (context, state) => MaterialPage(
      key: UniqueKey(),
      child: Scaffold(
        body: Center(child: Text(state.error.toString())),
      ),
    ),
  );

  GoRouter get router => _router;
}

SportsMarketsModel _goToSportsMarketByName(String name) {
  final liveSports = Global().liveSportsMarkets;
  return liveSports.firstWhere(
    (element) => element.name == name,
    orElse: () => SportsMarketsModel.empty,
  );
}

AthleteScoutModel _findAthleteById(String id) {
  final athleteList = Global().athleteList;
  return athleteList.firstWhere(
    (athlete) => athlete.id.toString() + athlete.name == id,
    orElse: () => AthleteScoutModel.empty,
  );
}

PredictionModel? _toPrediction(String id) {
  final predictions = Global().predictions;
  return predictions.firstWhere(
    (prediction) => prediction.id.toString() + prediction.prompt == id,
    orElse: () => PredictionModel.empty,
  );
}

Web3Client _getWeb3Client() {
  return Web3Client(
    'https://eth.public.blastapi.io',
    http.Client(),
  );
}

Web3Client _getBaseSepoliaWeb3Client() {
  return Web3Client(
    'https://base-sepolia.infura.io/v3/295739f3c9f64796bccfc206fc476a88',
    http.Client(),
  );
}
