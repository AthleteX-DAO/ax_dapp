import 'package:graphql/client.dart';

/// [GraphQLClient] extensions.
extension GraphQLClientX on GraphQLClient {
  /// Performs a `GraphQL` query.
  Future<QueryResult> performQuery(
    String query, {
    Map<String, dynamic> variables = const {},
  }) async {
    final options = QueryOptions(document: gql(query), variables: variables);
    final result = await this.query(options);
    return result;
  }

  /// Performs a `GraphQL` mutation.
  Future<QueryResult> performMutation(
    String query, {
    Map<String, dynamic> variables = const {},
  }) async {
    final options = MutationOptions(document: gql(query), variables: variables);
    final result = await mutate(options);
    return result;
  }
}
