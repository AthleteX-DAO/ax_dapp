import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLClientHelper {
  final HttpLink _httpLink;
  GraphQLClientHelper(this._httpLink);
  //TODO determine if we need auth token for access
  // final AuthLink _authLink = AuthLink(getToken: () async => "QmSUtWsFg4rY3UAz9NNiiUPdBazd5RG6SHMBymBTpxj9zp");

  Future<ValueNotifier<GraphQLClient>> initializeClient() async {
    await initHiveForFlutter();
    return ValueNotifier(GraphQLClient(
        link: _httpLink, cache: GraphQLCache(store: HiveStore())));
  }

  GraphQLClient initializeClientWithoutCache() {
    final policies = Policies(
      fetch: FetchPolicy.noCache,
    );
    return GraphQLClient(
        link: _httpLink,
        cache: GraphQLCache(),
        defaultPolicies: DefaultPolicies(
            watchQuery: policies, query: policies, mutate: policies));
  }

  Future<QueryResult> performQuery(GraphQLClient client, String query,
      {required Map<String, dynamic> variables}) async {
    QueryOptions options =
        QueryOptions(document: gql(query), variables: variables);

    final result = await client.query(options);

    return result;
  }

  Future<QueryResult> performMutation(GraphQLClient client, String query,
      {required Map<String, dynamic> variables}) async {
    MutationOptions options =
        MutationOptions(document: gql(query), variables: variables);

    final result = await client.mutate(options);

    print(result);

    return result;
  }
}
