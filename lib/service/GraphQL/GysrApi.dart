import 'package:ax_dapp/service/GraphQL/GraphQLClientHelper.dart';
import 'package:ax_dapp/service/GraphQL/GraphQLConfiguration.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// This class is used to call gysr api
class GysrApi {
  // declaration fo member variables
  static final GysrApi _instance = GysrApi._internal();
  late GraphQLClientHelper _gysrApiClientHelper;
  late GraphQLClient _gysrApiClient;

  final String getAllFarmsQuery = r'''
    query getAllFarms($owner: String!) {
      pools(where: {owner_contains: $owner}) {
        id
        name
        apr
        tvl
        stakingToken {
          id
          alias
          price
          symbol
        }
        rewardToken {
          id
          alias
          price
          symbol
        }
        staked
        rewards
        owner {
          id
        }
        stakingModule
      }
    }
  ''';

  final String getStakedFarmsQuery = r'''
    query getStakedFarms($account: String!) {
      user(id: $account) {
        positions {
          pool {
            id
            name
            apr
            tvl
            stakingToken {
              id
              alias
              price
              symbol
            }
            rewardToken {
              id
              alias
              price
              symbol
            }
            staked
            rewards
            owner {
              id
            }
            stakingModule
          }
        }
      }
    }
  ''';

  // factory function for singleton pattern
  factory GysrApi() {
    return _instance;
  }

  // constructor for singleton pattern
  GysrApi._internal() {
    _gysrApiClientHelper =
        GraphQLClientHelper(GraphQLConfiguration.gysrApiLink);
    _gysrApiClient = _gysrApiClientHelper.initializeClientWithoutCache();
  }

  /// @title  fetchAllFarms
  /// @desc   fetch all farms list from gysr api
  ///
  /// @param {String} the address of contract owner
  /// @return {Future<QueryResult>} the list of farms
  Future<QueryResult> fetchAllFarms(String owner) async {
    final result = await _gysrApiClientHelper.performQuery(
        _gysrApiClient, getAllFarmsQuery,
        variables: <String, dynamic>{"owner": owner});
    return result;
  }

  /// @title  getStakedFarms
  /// @desc   get staked farms list of an account from gysr api
  ///
  /// @param {String} the address of current account
  /// @return {Future<QueryResult>} the list of farms
  Future<QueryResult> fetchStakedFarms(String account) async {
    final result = await _gysrApiClientHelper.performQuery(
        _gysrApiClient, getStakedFarmsQuery,
        variables: <String, dynamic>{"account": account});
    return result;
  }
}
