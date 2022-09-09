import 'package:ethereum_api/src/gysr/gysr_queries.dart';
import 'package:shared/shared.dart';

/// {@template gysr_api_client}
/// Client that manages the gysr API.
/// {@endtemplate}
class GysrApiClient {
  /// {@macro gysr_api_client}
  GysrApiClient({required ValueStream<GraphQLClient> reactiveGysrClient})
      : _reactiveGysrClient = reactiveGysrClient;

  final ValueStream<GraphQLClient> _reactiveGysrClient;
  GraphQLClient get _gysrClient => _reactiveGysrClient.value;

  /// Fetches all farms list from gysr api for the address of contract [owner].
  Future<QueryResult> fetchAllFarms(String owner) async {
    final result = await _gysrClient.performQuery(
      GysrQuery.getAllFarms,
      variables: <String, dynamic>{'owner': owner},
    );
    return result;
  }

  /// Gets staked farms list of an [account] from gysr api.
  Future<QueryResult> fetchStakedFarms(String account) async {
    final result = await _gysrClient.performQuery(
      GysrQuery.getStakedFarms,
      variables: <String, dynamic>{'account': account},
    );
    return result;
  }
}
