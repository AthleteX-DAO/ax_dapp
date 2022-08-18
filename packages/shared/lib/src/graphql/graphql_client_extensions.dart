import 'package:graphql/client.dart';

/// [GraphQLClient] extensions.
extension GraphQLClientX on GraphQLClient {
  /// Performs a `GraphQL` query.
  Future<QueryResult> performQuery(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    final options = QueryOptions(document: gql(query), variables: variables);
    final result = await this.query(options);
    return result;
  }

  /// Performs a `GraphQL` mutation.
  Future<QueryResult> performMutation(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    final options = MutationOptions(document: gql(query), variables: variables);
    final result = await mutate(options);
    return result;
  }
}
