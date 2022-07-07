import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:ax_dapp/service/GraphQL/GysrApi.dart';
import 'package:ax_dapp/pages/farm/models/FarmModel.dart';

class GetFarmDataUseCase {
  final GysrApi gysrApi = GysrApi();

  Future<List<FarmModel>> fetchAllFarms(String owner) async {
    List<FarmModel> allFarms = [];
    final QueryResult response = await gysrApi.fetchAllFarms(owner);
    if (response.hasException) throw response.exception.toString();
    allFarms = _mapQueryResultToFarmModel(response.data!['pools'], false);
    return allFarms;
  }

  Future<List<FarmModel>> fetchStakedFarms(String account) async {
    print("[Debug] staked address $account");
    List<FarmModel> stakedFarms = [];
    final QueryResult response = await gysrApi.fetchStakedFarms(account);
    if (response.hasException) {
      print("[Debug] ${response.exception.toString()}");
      throw response.exception.toString();
    }

    stakedFarms =
        _mapQueryResultToFarmModel(response.data!['user']!['positions'], true);
    return stakedFarms;
  }

  List<FarmModel> _mapQueryResultToFarmModel(dynamic response, bool isStaked) {
    List<FarmModel> farms = [];
    response.forEach((pool) {
      dynamic farm = isStaked ? pool['pool'] : pool;
      farms.add(FarmModel(
          "${farm['stakingToken']['alias']!.length > 0 ? farm['stakingToken']['alias'] : farm['stakingToken']['symbol']} APT",
          farm['id'].toString(),
          farm['stakingToken']['alias'].toString(),
          farm['stakingToken']['symbol'].toString(),
          farm['rewardToken']['symbol'].toString(),
          farm['stakingToken']['id'].toString(),
          farm['rewardToken']['id'].toString(),
          farm['stakingModule'].toString(),
          farm['apr'].toString(),
          farm['tvl'].toString(),
          farm['staked'].toString(),
          farm['rewards'].toString(),
          farm['stakingToken']['price'].toString(),
          farm['rewardToken']['price'].toString(),
          int.parse(farm['stakingToken']['decimals']),
          int.parse(farm['rewardToken']['decimals'])));
    });
    return farms;
  }
}
