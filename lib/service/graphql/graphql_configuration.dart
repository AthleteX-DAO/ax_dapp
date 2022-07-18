import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  // final HttpLink _httpLink = HttpLink(
  //     'https://thegraph.com/hosted-service/subgraph/nyamwaya/athletex-dex-subgraph-mainnet?selected=playground');
  static HttpLink athleteDexApiLink = HttpLink(
    'https://api.thegraph.com/subgraphs/name/nyamwaya/athletex-dex-subgraph-mainnet',
  );
  static HttpLink gysrApiLink =
      HttpLink('https://api.thegraph.com/subgraphs/name/gysr-io/gysr-polygon');
}
