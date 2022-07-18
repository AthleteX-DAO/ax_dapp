// ignore_for_file: only_throw_errors, avoid_dynamic_calls

import 'package:ax_dapp/pages/farm/models/farm_model.dart';
import 'package:ax_dapp/service/graphql/gysr_api.dart';

class GetFarmDataUseCase {
  final GysrApi gysrApi = GysrApi();

  Future<List<FarmModel>> fetchAllFarms(String owner) async {
    final response = await gysrApi.fetchAllFarms(owner);
    if (response.hasException) throw response.exception.toString();
    return _mapQueryResultToFarmModel(response.data!['pools'], false);
  }

  Future<List<FarmModel>> fetchStakedFarms(String account) async {
    final response = await gysrApi.fetchStakedFarms(account);
    if (response.hasException) {
      throw response.exception.toString();
    }
    return _mapQueryResultToFarmModel(
      response.data!['user']!['positions'],
      true,
    );
  }

  List<FarmModel> _mapQueryResultToFarmModel(dynamic response, bool isStaked) {
    final farms = <FarmModel>[];
    response.forEach((dynamic pool) {
      final dynamic farm = isStaked ? pool['pool'] : pool;
      final stakingTokenAlias = farm['stakingToken']['alias'];
      final name = stakingTokenAlias!.length as int > 0
          ? '$stakingTokenAlias'
          : "${farm['stakingToken']['symbol']} APT";
      farms.add(
        FarmModel(
          name,
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
          int.parse(farm['stakingToken']['decimals'] as String),
          int.parse(farm['rewardToken']['decimals'] as String),
        ),
      );
    });
    return farms;
  }
}
