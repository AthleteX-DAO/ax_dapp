import 'package:retrofit/http.dart';
import 'package:shared/shared.dart';

import 'package:tokens_repository/src/api/model/coin_data.dart';

part 'coin_gecko_api.g.dart';

/// Coin gecko API
@RestApi(baseUrl: 'https://api.coingecko.com/api/v3/coins')
abstract class CoinGeckoAPI {
  /// Factory constructor for the API
  factory CoinGeckoAPI(Dio dio, {String baseUrl}) = _CoinGeckoAPI;

  /// Fetches information for the AX coin
  @GET('/athletex')
  Future<CoinData> getAthleteXCoinData();
}
