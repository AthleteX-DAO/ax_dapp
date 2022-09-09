// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

/// This is a repository that makes queries with the GraphQlClient
/// primarily it should be employed by using or adding a usecase to subgraph/usecases
/// to define the specific functionality needed

class SubGraphRepo {
  SubGraphRepo({required ValueStream<GraphQLClient> reactiveDexClient})
      : _reactiveDexClient = reactiveDexClient;

  final ValueStream<GraphQLClient> _reactiveDexClient;
  GraphQLClient get _dexGqlClient => _reactiveDexClient.value;

  Future<Either<Map<String, dynamic>?, OperationException>>
      queryPairDataForTokenAddress(String token0, String token1) async {
    final result = await _dexGqlClient
        .performQuery(_getPairInfoForTokenId(token0, token1));
    if (result.hasException) {
      return tryPostQuery(_getPairInfoForTokenId(token0, token1));
    } else {
      return Either.left(result.data);
    }
  }

  Future<Either<Map<String, dynamic>?, OperationException>>
      queryAllPairs() async {
    final result = await _dexGqlClient.query(
      QueryOptions(document: parseString(_getAllPairs())),
    );
    if (result.hasException) {
      return tryPostQuery(_getAllPairs());
    } else {
      return Either.left(result.data);
    }
  }

  Future<Either<Map<String, dynamic>?, OperationException>> tryPostQuery(
    String query,
  ) async {
    final uri = (_dexGqlClient.link as HttpLink).uri;
    final result = await http.post(
      uri,
      headers: {},
      body: parseString(query),
    );
    if (result.statusCode != 200) {
      return Either.right(OperationException());
    } else {
      final body = jsonDecode(result.body) as Map<String, dynamic>;
      final decodedJson =
          body['data'] as Map<String, String>;
      return Either.left(decodedJson);
    }
  }

  Future<Either<Map<String, dynamic>?, OperationException>> querySpecificPairs(
    String token,
  ) async {
    // calculating the first time of 24 hours ago as secondsSinceEpoch
    final startTime = (DateTime.now()
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch /
            1000)
        .round();

    final result = await _dexGqlClient.query(
      QueryOptions(document: parseString(_getSpecificPairs(token, startTime))),
    );
    if (result.hasException) {
      return tryPostQuery(_getSpecificPairs(token, startTime));
    } else {
      return Either.left(result.data);
    }
  }

  Future<Either<Map<String, dynamic>?, OperationException>>
      queryAllPairsForWalletId(String walletId) async {
    final result = await _dexGqlClient.query(
      QueryOptions(
        document: parseString(_getAllLiquidityPositionsForWalletId(walletId)),
      ),
    );
    if (result.hasException) {
      return tryPostQuery(_getAllLiquidityPositionsForWalletId(walletId));
    } else {
      return Either.left(result.data);
    }
  }
}

///token0/token1 can be either the APT token address or the
///blockchain address respectively
///This is set by the first add liquidity transaction
///and therefore important to fetch the pair data for the APT first
String _getPairInfoForTokenId(String token0, String token1) => '''
query {
  pairs(where: {token0_in:["$token0", "$token1"], token1_in:["$token0", "$token1"]}) {
    id
    name
    token0{
      id
      name
    }
    token1{
      id
      name
    }
    reserve0
    reserve1
		token0Price
    token1Price
    totalSupply
  }
}
''';

///This returns all available pairs in the AthleteX Subgraph
String _getAllPairs() => '''
query {
 pairs {
  	id
    name
    token0Price
    token1Price
    token0 {name, id}
    token1 {name, id}
    reserve0 
    reserve1
  	totalSupply
  }
}
''';

String _getSpecificPairs(String token, int startTime) => '''
query {
  prefix: pairs(where: {name_starts_with: "$token-"}) {
  	id
    name
    token0Price
    token1Price
    token0 {name, id}
    token1 {name, id}
    reserve0 
    reserve1
  	totalSupply
    pairHourData(where: {hourStartUnix_lte: $startTime}, first: 1, orderBy: hourStartUnix, orderDirection: desc) {
      hourStartUnix
      reserve0
      reserve1
      pair {
        id
        name
        token0 {id, name}
        token1 {id, name}
        reserve0
        reserve1
        token0Price
        token1Price
      }
    }
  },
  suffix: pairs(where: {name_ends_with: "-$token"}) {
  	id
    name
    token0Price
    token1Price
    token0 {name, id}
    token1 {name, id}
    reserve0 
    reserve1
  	totalSupply
    pairHourData(where: {hourStartUnix_lte: $startTime}, first: 1, orderBy: hourStartUnix, orderDirection: desc) {
      hourStartUnix
      reserve0
      reserve1
      pair {
        id
        name
        token0 {id, name}
        token1 {id, name}
        reserve0
        reserve1
        token0Price
        token1Price
      }
    }
  }
}
''';

String _getAllLiquidityPositionsForWalletId(String walletId) => '''
  query {
    user(id: "$walletId") {
      liquidityPositions {
        pair {
          id
          name
          token0{
            id
            name
            symbol
          }
          token1{
            id
            name
            symbol
          }
          token0Price
          token1Price
          reserve0
          reserve1
          totalSupply
        }
        liquidityTokenBalance
      }
    }
  }
''';
