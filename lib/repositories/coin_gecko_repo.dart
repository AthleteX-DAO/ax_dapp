import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/coingecko_result.dart';
import 'package:coingecko_api/data/coin.dart';

class CoinGeckoRepo {
  CoinGeckoRepo(CoinGeckoApi coinGeckoApi) : _coinGeckoApi = coinGeckoApi;

  final CoinGeckoApi _coinGeckoApi;

  Future<CoinGeckoResult<Coin?>> getAxPrice() {
    return _coinGeckoApi.coins.getCoinData(
      id: 'athletex',
      localization: false,
      communityData: false,
      tickers: false,
      developerData: false,
    );
  }
}
