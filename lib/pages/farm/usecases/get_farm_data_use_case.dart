// ignore_for_file: only_throw_errors, avoid_dynamic_calls

import 'package:ax_dapp/pages/farm/models/farm_model.dart';
import 'package:ax_dapp/service/graphql/gysr_api.dart';

class GetFarmDataUseCase {
  final GysrApi gysrApi = GysrApi();

  Future<List<FarmModel>> fetchAllFarms(String owner) async {
    try {
      final response = await gysrApi.fetchAllFarms(owner);
      if (response.hasException) throw response.exception.toString();
      return _mapQueryResultToFarmModel(
        response.data!['pools'] as List<dynamic>,
        false,
      );
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<FarmModel>> fetchStakedFarms(String account) async {
    try {
      final response = await gysrApi.fetchStakedFarms(account);
      if (response.hasException) {
        throw response.exception.toString();
      }
      return _mapQueryResultToFarmModel(
        response.data!['user']!['positions'] as List<dynamic>,
        true,
      );
    } catch (e) {
      return List.empty();
    }
  }

  List<FarmModel> _mapQueryResultToFarmModel(
    List<dynamic> response,
    bool isStaked,
  ) {
    return response.map((pool) {
      final dynamic farm = isStaked ? pool['pool'] : pool;
      return FarmModel.fromJson(farm as Map<String, dynamic>);
    }).toList();
  }
}
