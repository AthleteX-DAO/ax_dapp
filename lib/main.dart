import 'dart:developer';

import 'package:ax_dapp/pages/landing_page/landing_page.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
  runApp(
    GraphQLProvider(
      client: _gQLClient,
      child: MultiRepositoryProvider(
        providers: [
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
            create: (context) => GetBuyInfoUseCase(_getSwapInfoUseCase),
          ),
          RepositoryProvider(
            create: (context) => GetSellInfoUseCase(_getSwapInfoUseCase),
          ),
          RepositoryProvider(
            create: (context) => GetPoolInfoUseCase(_getPairInfoUseCase),
          ),
          RepositoryProvider(
            create: (context) => GetAllLiquidityInfoUseCase(_subGraphRepo),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Returns anything!
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
