import 'package:fpdart/fpdart.dart';
import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// This is a repository that makes queries with the GraphQlClient
/// primarily it should be employed by using or adding a usecase to subgraph/usecases
/// to define the specific functionality needed

class SubGraphRepo {
  final GraphQLClient _client;

  SubGraphRepo(this._client);

  Future<Either<Map<String, dynamic>?, OperationException>>
      queryPairDataForTokenAddress(String token0, String token1) async {
    final result = await _client.query(
        QueryOptions(document: gql(_getPairInfoForTokenId(token0, token1))));
    if (result.hasException)
      return Either.right(result.exception!);
    else
      return Either.left(result.data);
  }

  Future<Either<Map<String, dynamic>?, OperationException>>
      queryAllPairs() async {
    final result = await _client.query(
      QueryOptions(
          document: parseString(_getAllPairs()),
          pollInterval: const Duration(seconds: 10)),
    );
    if (result.hasException)
      return Either.right(result.exception!);
    else
      return Either.left(result.data);
  }
}

///token0/token1 can be either the APT token address or the
///blockchain address respectively
///This is set by the first add liquidity transaction
///and therefore important to fetch the pair data for the APT first
String _getPairInfoForTokenId(String token0, String token1) => """
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
  } 
} 
""";

///This returns all available pairs in the AthleteX Subgraph
String _getAllPairs() => """
query {
 pairs {
  	id
    name
    token0 {name, id}
    token1 {name, id}
    reserve0 
    reserve1
  	totalSupply
  }
}
""";
