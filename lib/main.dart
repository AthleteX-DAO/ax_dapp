import 'dart:async';

import 'package:ax_dapp/app/view/app.dart';
import 'package:ax_dapp/bootstrap.dart';
import 'package:ax_dapp/chat_box/repository/chat_gpt_repository.dart';
import 'package:ax_dapp/firebase_options.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/repository/timer_repository.dart';
import 'package:ax_dapp/league/usecases/league_use_case.dart';
import 'package:ax_dapp/live_chat_box/repository/live_chat_repository.dart';
import 'package:ax_dapp/logger_interceptor.dart';
import 'package:ax_dapp/predict/repository/prediction_snapshot_repository.dart';
import 'package:ax_dapp/predict/usecase/get_prediction_market_info_use_case.dart';
import 'package:ax_dapp/prediction/repository/prediction_address_repository.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/nfl_repo.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pair_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_pool_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_sell_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/repositories/usecases/get_all_liquidity_info_use_case.dart';
import 'package:ax_dapp/service/api/mlb_athlete_api.dart';
import 'package:ax_dapp/service/api/nfl_athlete_api.dart';
import 'package:ax_dapp/service/controller/pool/pool_repository.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/service/controller/scout/long_short_pair_repository.dart.dart';
import 'package:ax_dapp/service/controller/swap/swap_repository.dart';
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
import 'package:wallet_repository/wallet_repository.dart';

void main() async {
  const defaultChain = EthereumChain.sxMainnet;

  _setupLogging();
  final dio = Dio()..interceptors.add(LoggingInterceptor());
  final mlbApi = MLBAthleteAPI(dio);
  final nflApi = NFLAthleteAPI(dio);
  final coinApi = CoinGeckoAPI(dio);
  final cache = CacheClient();

  final httpClient = http.Client();

  final magic = MagicSDK('pk_live_A0EFC48FF2C1D624');

  await initHiveForFlutter();
  // usePathUrlStrategy();
  final configApiClient = ConfigApiClient(
    defaultChain: defaultChain,
    httpClient: httpClient,
  );
  final configRepository = ConfigRepository(configApiClient: configApiClient);
  final appConfig = configRepository.initializeAppConfig();

  /// Section -- Wallet Clients setup

  final reactiveWeb3Client = appConfig.reactiveWeb3Client;
  final walletApiClient =
      EthereumWalletApiClient(reactiveWeb3Client: reactiveWeb3Client);
  final magicWalletApiClient = MagicWalletApiClient(
    magicSDK: magic,
    reactiveWeb3Client: reactiveWeb3Client,
  );

  final nativeWalletApiClient =
      NativeWalletApiClient(reactiveWeb3Client: reactiveWeb3Client);

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
            create: (_) => LiveChatRepository(
              fireStore: FirebaseFirestore.instance,
            ),
          ),
          RepositoryProvider(
            create: (_) => ChatGPTRepository(
              fireStore: FirebaseFirestore.instance,
            ),
          ),
          RepositoryProvider(
            create: (_) => WalletRepository(
              walletApiClient,
              nativeWalletApiClient,
              magicWalletApiClient,
              cache,
              defaultChain: defaultChain,
            ),
          ),
          RepositoryProvider(
            create: (_) => TokensRepository(
              tokensApiClient: tokensApiClient,
              reactiveLspClient: reactiveLspClient,
              coinGeckoApiClient: coinApi,
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
            create: (context) => GetPoolInfoUseCase(getPairInfoUseCase),
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
            create: (context) => GetPredictionMarketInfoUseCase(
              predictionSnapshotRepository:
                  context.read<PredictionSnapshotRepository>(),
              predictionAddressRepository:
                  context.read<PredictionAddressRepository>(),
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
