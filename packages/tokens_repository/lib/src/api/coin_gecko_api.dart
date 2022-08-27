import 'package:retrofit/http.dart';
import 'package:shared/shared.dart';

import 'package:tokens_repository/src/api/model/coin_data.dart';

part 'coin_gecko_api.g.dart';

@RestApi(baseUrl: 'https://api.coingecko.com/api/v3/coins')
abstract class CoinGeckoAPI {
  factory CoinGeckoAPI(Dio dio, {String baseUrl}) = _CoinGeckoAPI;

  @GET('/athletex')
  Future<CoinData> getAthleteXCoinData();
}
