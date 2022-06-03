import 'package:ax_dapp/pages/LandingPage.dart';
import 'package:ax_dapp/repositories/MlbRepo.dart';
import 'package:ax_dapp/repositories/subgraph/SubGraphRepo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetBuyInfoUseCase.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetPairInfoUseCase.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetPoolInfoUseCase.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetSellInfoUseCase.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetSwapInfoUseCase.dart';
import 'package:ax_dapp/repositories/usecases/GetAllLiquidityInfoUseCase.dart';
import 'package:ax_dapp/service/Api/MLBAthleteAPI.dart';
import 'package:ax_dapp/service/GraphQL/GraphQLClientHelper.dart';
import 'package:ax_dapp/service/GraphQL/GraphQLConfiguration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final _dio = Dio();
final _mlbApi = MLBAthleteAPI(_dio);
final _graphQLClientHelper =
    GraphQLClientHelper(GraphQLConfiguration.athleteDexApiLink);
void main() async {
  final _gQLClient = await _graphQLClientHelper.initializeClient();
  final _subGraphRepo = SubGraphRepo(_gQLClient.value);
  final _getPairInfoUseCase = GetPairInfoUseCase(_subGraphRepo);
  final _getSwapInfoUseCase = GetSwapInfoUseCase(_getPairInfoUseCase);
  print("Graph QL CLient initialized}");
  runApp(GraphQLProvider(
    client: _gQLClient,
    child: MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => _subGraphRepo),
        RepositoryProvider(
          create: (context) => MLBRepo(_mlbApi),
        ),
        RepositoryProvider(create: (context) => _getPairInfoUseCase),
        RepositoryProvider(create: (context) => _getSwapInfoUseCase),
        RepositoryProvider(
            create: (context) => GetBuyInfoUseCase(_getSwapInfoUseCase)),
        RepositoryProvider(
            create: (context) => GetSellInfoUseCase(_getSwapInfoUseCase)),
        RepositoryProvider(
            create: (context) => GetPoolInfoUseCase(_getPairInfoUseCase)),
        RepositoryProvider(
            create: (context) => GetAllLiquidityInfoUseCase(_subGraphRepo)),
      ],
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Returns anything!
    return MaterialApp(
      title: "AthleteX",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      theme: ThemeData(
          canvasColor: Colors.transparent,
          brightness: Brightness.dark,
          primaryColor: Colors.yellow[700],
          colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
              .copyWith(secondary: Colors.black)),
      home: LandingPage(),
      // home: V1App(),
      // home: HomePage()
    );
  }
}
