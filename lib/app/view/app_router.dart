import 'package:ax_dapp/add_liquidity/bloc/add_liquidity_bloc.dart';
import 'package:ax_dapp/app/bloc/app_bloc.dart';
import 'package:ax_dapp/app/view/app_scaffold.dart';
import 'package:ax_dapp/athlete/view/athlete_page.dart';
import 'package:ax_dapp/farm/bloc/farm_bloc.dart';
import 'package:ax_dapp/farm/desktop_farm.dart';
import 'package:ax_dapp/farm/usecases/get_farm_data_use_case.dart';
import 'package:ax_dapp/landing_page/landing_page_wrapper.dart';
import 'package:ax_dapp/league/league_game/bloc/league_game_bloc.dart';
import 'package:ax_dapp/league/league_game/views/league_game.dart';
import 'package:ax_dapp/league/league_search/bloc/league_bloc.dart';
import 'package:ax_dapp/league/league_search/views/desktop_league.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/repository/timer_repository.dart';
import 'package:ax_dapp/league/usecases/league_use_case.dart';
import 'package:ax_dapp/pool/view/desktop_pool.dart';
import 'package:ax_dapp/predict/bloc/predict_page_bloc.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/usecase/get_prediction_market_info_use_case.dart';
import 'package:ax_dapp/predict/view/desktop_predict.dart';
import 'package:ax_dapp/prediction/bloc/prediction_page_bloc.dart';
import 'package:ax_dapp/prediction/repository/prediction_address_repository.dart';
import 'package:ax_dapp/prediction/view/prediction_page.dart';
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
import 'package:ax_dapp/service/controller/pool/pool_repository.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/service/controller/scout/long_short_pair_repository.dart.dart';
import 'package:ax_dapp/service/controller/swap/swap_repository.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/trade/bloc/trade_page_bloc.dart';
import 'package:ax_dapp/trade/desktop_trade.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:ethereum_api/gysr_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:league_repository/league_repository.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final GoRouter _router = GoRouter(
    redirect: (context, state) async {
      // ignore: use_build_context_synchronously
      if (await context.read<WalletRepository>().searchForWallet() ?? false) {
        // ignore: use_build_context_synchronously
        context.read<WalletBloc>().add(const ConnectWalletRequested());
      }
      if (state.location.contains('/athlete') && Global().athleteList.isEmpty) {
        return '/scout';
      }
      if (state.location.contains('/prediction') &&
          Global().predictions.isEmpty) {
        return '/predict';
      }
      return null;
    },
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        name: 'landing',
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const LandingPageWrapper();
        },
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
                ),
                child: const DesktopPredict(),
              );
            },
            routes: [
              GoRoute(
                name: 'prediction',
                path: 'prediction/:id',
                builder: (BuildContext context, GoRouterState state) {
                  return BlocProvider(
                    create: (context) => PredictionPageBloc(
                      walletRepository: context.read<WalletRepository>(),
                      eventMarketRepository:
                          context.read<EventMarketRepository>(),
                      streamAppDataChangesUseCase:
                          context.read<StreamAppDataChangesUseCase>(),
                      predictionAddressRepository:
                          context.read<PredictionAddressRepository>(),
                      predictionModelId: _toPrediction(state.params['id']!)!.id,
                    ),
                    child: PredictionPage(
                      predictionModel: _toPrediction(state.params['id']!)!,
                    ),
                  );
                },
              )
            ],
          ),
          GoRoute(
            name: 'scout',
            path: '/scout',
            builder: (BuildContext context, GoRouterState state) {
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
                    athlete: _findAthleteById(state.params['id']!),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            name: 'trade',
            path: '/trade',
            builder: (BuildContext context, GoRouterState state) {
              return BlocProvider(
                create: (BuildContext context) => TradePageBloc(
                  walletRepository: context.read<WalletRepository>(),
                  streamAppDataChanges:
                      context.read<StreamAppDataChangesUseCase>(),
                  repo: RepositoryProvider.of<GetSwapInfoUseCase>(context),
                  swapRepository: context.read<SwapRepository>(),
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
                  poolRepository: context.read<PoolRepository>(),
                ),
                child: const DesktopPool(),
              );
            },
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
                  final leagueID = state.params['leagueID']!;
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
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: UniqueKey(),
      child: Scaffold(
        body: Center(child: Text(state.error.toString())),
      ),
    ),
  );

  GoRouter get router => _router;
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
    (prediction) => prediction.id == id,
    orElse: () => PredictionModel.empty,
  );
}
