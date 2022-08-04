import 'dart:async';
import 'dart:developer';

import 'package:ax_dapp/app/app.dart';
import 'package:ax_dapp/bootstrap.dart';
import 'package:ax_dapp/firebase_options.dart';
import 'package:ax_dapp/repositories/coin_gecko_repo.dart';
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
import 'package:ax_dapp/service/graphql/graphql_client_helper.dart';
import 'package:ax_dapp/service/graphql/graphql_configuration.dart';
import 'package:coingecko_api/coingecko_api.dart';
import 'package:dio/dio.dart';
import 'package:ethereum_api/ethereum_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:tracking_repository/tracking_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

void main() async {
  final _dio = Dio();
  final _mlbApi = MLBAthleteAPI(_dio);
  final _coinGeckoApi = CoinGeckoApi();
  final _graphQLClientHelper =
      GraphQLClientHelper(GraphQLConfiguration.athleteDexApiLink);
  final _gQLClient = await _graphQLClientHelper.initializeClient();
  final _subGraphRepo = SubGraphRepo(_gQLClient.value);
  final _getPairInfoUseCase = GetPairInfoUseCase(_subGraphRepo);
  final _getSwapInfoUseCase = GetSwapInfoUseCase(_getPairInfoUseCase);

  log('GraphQL Client initialized}');

  final ethereumApiClient = EthereumApiClient();

  unawaited(
    bootstrap(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return GraphQLProvider(
        client: _gQLClient,
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (_) => WalletRepository(
                defaultChain: EthereumChain.polygonMainnet,
              ),
            ),
            RepositoryProvider(
              create: (_) => TokensRepository(
                ethereumApiClient: ethereumApiClient,
              ),
            ),
            RepositoryProvider(create: (context) => _subGraphRepo),
            RepositoryProvider(
              create: (context) => MLBRepo(_mlbApi),
            ),
            RepositoryProvider(
              create: (context) => NFLRepo(),
            ),
            RepositoryProvider(
              create: (context) => CoinGeckoRepo(_coinGeckoApi),
            ),
            RepositoryProvider(create: (context) => _getPairInfoUseCase),
            RepositoryProvider(create: (context) => _getSwapInfoUseCase),
            RepositoryProvider(
              create: (context) => GetBuyInfoUseCase(
                tokensRepository: context.read<TokensRepository>(),
                repo: _getSwapInfoUseCase,
              ),
            ),
            RepositoryProvider(
              create: (context) => GetSellInfoUseCase(
                tokensRepository: context.read<TokensRepository>(),
                repo: _getSwapInfoUseCase,
              ),
            ),
            RepositoryProvider(
              create: (context) => GetPoolInfoUseCase(_getPairInfoUseCase),
            ),
            RepositoryProvider(
              create: (context) => GetAllLiquidityInfoUseCase(_subGraphRepo),
            ),
            RepositoryProvider(
              create: (context) => TrackingRepository(),
            ),
          ],
          child: const App(),
        ),
      );
    }),
  );
}
