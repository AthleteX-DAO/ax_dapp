// ignore_for_file: only_throw_errors, avoid_dynamic_calls

import 'package:ax_dapp/pages/farm/models/farm_model.dart';
import 'package:ethereum_api/gysr_api.dart';

class GetFarmDataUseCase {
  GetFarmDataUseCase({required GysrApiClient gysrApiClient})
      : _gysrApiClient = gysrApiClient;

  final GysrApiClient _gysrApiClient;

  Future<List<FarmModel>> fetchAllFarms(String owner) async {
    try {
      final response = await _gysrApiClient.fetchAllFarms(owner);
      if (response.hasException) throw response.exception.toString();
      return _mapQueryResultToFarmModel(
        response.data!['pools'] as List<dynamic>,
        false,
      );
    } catch (error) {
      return const [];
    }
  }

  Future<List<FarmModel>> fetchStakedFarms(String account) async {
    try {
      final response = await _gysrApiClient.fetchStakedFarms(account);
      if (response.hasException) {
        throw response.exception.toString();
      }
      return _mapQueryResultToFarmModel(
        response.data!['user']!['positions'] as List<dynamic>,
        true,
      );
    } catch (_) {
      return const [];
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
