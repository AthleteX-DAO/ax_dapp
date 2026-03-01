import 'dart:async';

import 'package:ax_dapp/account/repository/account_repository.dart';
import 'package:ax_dapp/app/view/app.dart';
import 'package:ax_dapp/bootstrap.dart';
import 'package:ax_dapp/firebase_options.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/repository/timer_repository.dart';
import 'package:ax_dapp/league/usecases/league_use_case.dart';
import 'package:ax_dapp/logger_interceptor.dart';
import 'package:ax_dapp/predict/data/firebase_price_client.dart';
import 'package:ax_dapp/predict/data/prediction_market_client.dart';
import 'package:ax_dapp/predict/repository/live_prediction_market_repository.dart';
import 'package:ax_dapp/predict/repository/prediction_snapshot_repository.dart';
import 'package:ax_dapp/predict/usecase/get_prediction_market_data_use_case.dart';import 'package:ax_dapp/predict/usecase/get_prediction_market_info_use_case.dart';
import 'package:ax_dapp/predict/usecases/get_top_prediction_markets_usecase.dart';
import 'package:ax_dapp/prediction/repository/prediction_address_repository.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/nfl_repo.dart';
import 'package:ax_dapp/repositories/oracle/oracle_repository.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pair_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pool_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_sell_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/repositories/sx_markets_repository.dart';
import 'package:ax_dapp/repositories/usecases/get_all_liquidity_info_use_case.dart';
import 'package:ax_dapp/service/api/mlb_athlete_api.dart';
import 'package:ax_dapp/service/api/nfl_athlete_api.dart';
import 'package:ax_dapp/service/controller/earn/vault_repository.dart';
import 'package:ax_dapp/service/controller/markets/long_short_pair_repository.dart.dart';
import 'package:ax_dapp/service/controller/pool/pool_repository.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/service/controller/swap/swap_repository.dart';
import 'package:ax_dapp/service/controller/usecases/get_total_token_balance_use_case.dart';
import 'package:ax_dapp/service/portfolio_balance_service.dart';
import 'package:ax_dapp/service/synthetix_core_service.dart';
import 'package:ax_dapp/sports_markets/usecases/get_sports_markets_data_use_case.dart';
import 'package:ax_dapp/wallet/usecases/cross_chain_balance_usecase.dart';
import 'package:ax_dapp/wallet/usecases/synthetix_account_bootstrap.dart';
import 'package:ax_dapp/wallet/usecases/unified_portfolio_usecase.dart';
import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:config_repository/config_repository.dart';
import 'package:ethereum_api/config_api.dart';
import 'package:ethereum_api/gysr_api.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:ethereum_api/wallet_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:league_repository/league_repository.dart';
import 'package:logging/logging.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:tracking_repository/tracking_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:user_authentication/user_authentication.dart';
import 'package:wallet_repository/wallet_repository.dart';

void main() async {
  const defaultChain = EthereumChain.polygonMainnet;

  _setupLogging();
  final dio = Dio()..interceptors.add(LoggingInterceptor());
  final mlbApi = MLBAthleteAPI(dio);
  final nflApi = NFLAthleteAPI(dio);
  final cache = CacheClient();

  final httpClient = http.Client();

  await initHiveForFlutter();
  final configApiClient = ConfigApiClient(
    defaultChain: defaultChain,
    httpClient: httpClient,
  );
  final configRepository = ConfigRepository(configApiClient: configApiClient);
  final appConfig = configRepository.initializeAppConfig();

  final reactiveWeb3Client = appConfig.reactiveWeb3Client;
  final walletApiClient =
      EthereumWalletApiClient(reactiveWeb3Client: reactiveWeb3Client);
  final tokensApiClient = TokensApiClient(
    defaultChain: defaultChain,
    reactiveWeb3Client: reactiveWeb3Client,
  );

  final reactiveLspClient = appConfig.reactiveLspClient;

  final gysrApiClient =
      GysrApiClient(reactiveGysrClient: appConfig.reactiveGysrGqlClient);
  final subGraphRepo =
      SubGraphRepo(reactiveDexClient: appConfig.reactiveDexGqlClient);
  final getPairInfoUseCase = GetPairInfoUseCase(subGraphRepo);
  final getSwapInfoUseCase = GetSwapInfoUseCase(getPairInfoUseCase);

  unawaited(
    bootstrap(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (_) => LongShortPairRepository(),
          ),
          RepositoryProvider(
            create: (_) => PoolRepository(),
          ),
          RepositoryProvider(
            create: (_) => SwapRepository(),
          ),
          RepositoryProvider(
            create: (_) => LeagueRepository(
              fireStore: FirebaseFirestore.instance,
            ),
          ),
          RepositoryProvider(
            create: (_) => WalletRepository(
              walletApiClient,
              cache,
              defaultChain: defaultChain,
            ),
          ),
          RepositoryProvider(
            create: (_) => TokensRepository(
              tokensApiClient: tokensApiClient,
              reactiveLspClient: reactiveLspClient,
              httpClient: httpClient,
            ),
          ),
          RepositoryProvider.value(value: gysrApiClient),
          RepositoryProvider.value(value: subGraphRepo),
          RepositoryProvider(
            create: (context) => MLBRepo(mlbApi),
          ),
          RepositoryProvider(
            create: (context) => NFLRepo(nflApi),
          ),
          RepositoryProvider(
            create: (context) => StreamAppDataChangesUseCase(
              walletRepository: context.read<WalletRepository>(),
              tokensRepository: context.read<TokensRepository>(),
              configRepository: configRepository,
            ),
          ),
          RepositoryProvider.value(value: getPairInfoUseCase),
          RepositoryProvider.value(value: getSwapInfoUseCase),
          RepositoryProvider(
            create: (context) => GetBuyInfoUseCase(
              tokensRepository: context.read<TokensRepository>(),
              repo: getSwapInfoUseCase,
            ),
          ),
          RepositoryProvider(
            create: (context) => GetSellInfoUseCase(
              tokensRepository: context.read<TokensRepository>(),
              repo: getSwapInfoUseCase,
            ),
          ),
          RepositoryProvider(
            create: (context) => GetPoolInfoUseCase(),
          ),
          RepositoryProvider(
            create: (context) => GetAllLiquidityInfoUseCase(subGraphRepo),
          ),
          RepositoryProvider(
            create: (context) => TrackingRepository(),
          ),
          RepositoryProvider(
            create: (context) => EventMarketRepository(),
          ),
          RepositoryProvider(
            create: (context) => PredictionMarketClient(),
          ),
          RepositoryProvider(
            create: (context) => FirebasePriceClient(
              firestore: FirebaseFirestore.instance,
            ),
          ),
          RepositoryProvider(
            create: (context) => LivePredictionMarketRepository(
              predictionMarketClient:
                  context.read<PredictionMarketClient>(),
            ),
          ),
          RepositoryProvider(
            create: (context) => LeagueUseCase(),
          ),
          RepositoryProvider(
            create: (context) => TimerRepository(),
          ),
          RepositoryProvider(
            create: (context) => PrizePoolRepository(),
          ),
          RepositoryProvider(
            create: (context) => PredictionSnapshotRepository(),
          ),
          RepositoryProvider(
            create: (context) => PredictionAddressRepository(
              fireStore: FirebaseFirestore.instance,
            ),
          ),
          RepositoryProvider(
            create: (context) => GetPredictionMarketDataUseCase(
              tokensRepository: context.read<TokensRepository>(),
              graphRepo: subGraphRepo,
              livePredictionMarketRepository:
                  context.read<LivePredictionMarketRepository>(),
              firebasePriceClient: context.read<FirebasePriceClient>(),
            ),
          ),
          RepositoryProvider(
            create: (context) => GetPredictionMarketInfoUseCase(
              predictionSnapshotRepository:
                  context.read<PredictionSnapshotRepository>(),
              predictionAddressRepository:
                  context.read<PredictionAddressRepository>(),
            ),
          ),
          RepositoryProvider(
            create: (context) => GetTopPredictionMarketsUseCase(
              livePredictionMarketRepository:
                  context.read<LivePredictionMarketRepository>(),
            ),
          ),
          RepositoryProvider(
            create: (context) => SXMarketsRepository(),
          ),
          RepositoryProvider(
            create: (context) => GetSportsMarketsDataUseCase(
              sxMarketsRepository: context.read<SXMarketsRepository>(),
            ),
          ),
          RepositoryProvider(
            create: (context) => FireBaseAuthRepository(),
          ),
          RepositoryProvider(
            create: (context) => FireStoreCredentialsRepository(
              fireStore: FirebaseFirestore.instance,
              walletRepository: context.read<WalletRepository>(),
            ),
          ),
          RepositoryProvider(
            create: (context) => GetTotalTokenBalanceUseCase(
              walletRepository: context.read<WalletRepository>(),
              tokensRepository: context.read<TokensRepository>(),
            ),
          ),
          RepositoryProvider(
            create: (context) => OracleRepository(),
          ),
          RepositoryProvider(
            create: (context) => PortfolioBalanceService(
              walletRepository: context.read<WalletRepository>(),
              oracleRepository: context.read<OracleRepository>(),
            ),
          ),
          RepositoryProvider(
            create: (context) => CrossChainBalanceUseCase(
              walletRepository: context.read<WalletRepository>(),
              portfolioBalanceService: context.read<PortfolioBalanceService>(),
            ),
          ),
          RepositoryProvider(
            create: (context) => UnifiedPortfolioUseCase(
              walletRepository: context.read<WalletRepository>(),
            ),
          ),
          RepositoryProvider(
            create: (_) => SynthetixAccountBootstrap(
              SynthetixCoreService(),
            ),
          ),
          RepositoryProvider(
            create: (context) => AccountRepository(),
          ),
          RepositoryProvider(
            create: (context) => VaultRepository(
              chain: defaultChain,
              reactiveWeb3Client: appConfig.reactiveWeb3Client,
              walletRepository: context.read<WalletRepository>(),
            ),
          ),
        ],
        child: App(configRepository: configRepository),
      );
    }),
  );
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    debugPrint('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
