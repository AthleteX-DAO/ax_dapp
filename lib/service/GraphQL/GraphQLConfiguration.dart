import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  // final HttpLink _httpLink = HttpLink(
  //     'https://thegraph.com/hosted-service/subgraph/nyamwaya/athletex-dex-subgraph-mainnet?selected=playground');
  static HttpLink AthleteDexApiLink = HttpLink(
      'https://thegraph.com/hosted-service/subgraph/nyamwaya/athletex-dex-subgraph-mainnet?selected=playground');
  static HttpLink GysrApiLink =
      HttpLink('https://api.thegraph.com/subgraphs/name/gysr-io/gysr-polygon');
}
