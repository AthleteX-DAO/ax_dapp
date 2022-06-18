import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/coingecko_result.dart';

class CoinGeckoRepo {
  final CoinGeckoApi _api;

  CoinGeckoRepo(
    this._api
  );

  Future<CoinGeckoResult> getAxPrice() async {
    return await _api.coins.getCoinData(id: 'athletex', marketData: true, localization: false, communityData: false, tickers: false, developerData: false);
  }
}
