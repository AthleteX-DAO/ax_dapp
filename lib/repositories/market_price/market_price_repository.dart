import 'package:ax_dapp/repositories/market_price/data/market_price_api_client.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';

class MarketSummary {
  const MarketSummary({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change1h,
    required this.change24h,
  });

  final String symbol;
  final String name;
  final double price;
  final double change1h;
  final double change24h;
}

class MarketPriceRepository {
  MarketPriceRepository({
    MarketPriceApiClient? apiClient,
  }) : _apiClient = apiClient ?? MarketPriceApiClient();

  final MarketPriceApiClient _apiClient;
  static const Duration _chartCacheTtl = Duration(minutes: 5);
  static const Duration _summaryCacheTtl = Duration(minutes: 2);
  static const int _maxChartPoints = 240;
  final Map<String, _ChartCacheEntry> _chartCache = {};
  final Map<String, Future<List<GraphData>>> _inflightCharts = {};
  final Map<String, _SummaryCacheEntry> _summaryCache = {};
  final Map<String, Future<Map<String, MarketSummary>>> _inflightSummaries = {};

  static const Map<String, String> _symbolToId = {
    'BTC': 'bitcoin',
    'ETH': 'ethereum',
    'SOL': 'solana',
    'XRP': 'ripple',
    'ADA': 'cardano',
    'DOT': 'polkadot',
    'LINK': 'chainlink',
    'MATIC': 'matic-network',
    'AVAX': 'avalanche-2',
    'OP': 'optimism',
    'ARB': 'arbitrum',
    'LDO': 'lido-dao',
    'UNI': 'uniswap',
    'AAVE': 'aave',
    'USDC': 'usd-coin',
    'USDT': 'tether',
    'DAI': 'dai',
    'WETH': 'weth',
    'wstETH': 'wrapped-steth',
    'DOGE': 'dogecoin',
    'SHIB': 'shiba-inu',
    'PEPE': 'pepe',
    'BLUR': 'blur',
    'CRV': 'curve-dao-token',
    'GMX': 'gmx',
  };

  static const Map<String, String> _symbolToName = {
    'BTC': 'Bitcoin',
    'ETH': 'Ethereum',
    'SOL': 'Solana',
    'XRP': 'Ripple',
    'ADA': 'Cardano',
    'DOT': 'Polkadot',
    'LINK': 'Chainlink',
    'MATIC': 'Polygon',
    'AVAX': 'Avalanche',
    'OP': 'Optimism',
    'ARB': 'Arbitrum',
    'LDO': 'Lido',
    'UNI': 'Uniswap',
    'AAVE': 'Aave',
    'USDC': 'USD Coin',
    'USDT': 'Tether',
    'DAI': 'Dai',
    'WETH': 'Wrapped Ether',
    'wstETH': 'Wrapped stETH',
    'DOGE': 'Dogecoin',
    'SHIB': 'Shiba Inu',
    'PEPE': 'Pepe',
    'BLUR': 'Blur',
    'CRV': 'Curve',
    'GMX': 'GMX',
  };

  String? getIdForSymbol(String symbol) => _symbolToId[symbol];
  String getNameForSymbol(String symbol) => _symbolToName[symbol] ?? symbol;

  Future<Map<String, MarketSummary>> fetchMarketSummaries(
    List<String> symbols,
  ) async {
    final ids = <String>[];
    final symbolById = <String, String>{};

    for (final symbol in symbols) {
      final id = _symbolToId[symbol];
      if (id != null) {
        ids.add(id);
        symbolById[id] = symbol;
      }
    }

    if (ids.isEmpty) return {};

    ids.sort();
    final cacheKey = ids.join(',');
    final now = DateTime.now();
    final cached = _summaryCache[cacheKey];
    if (cached != null && now.difference(cached.timestamp) < _summaryCacheTtl) {
      return cached.data;
    }

    final inflight = _inflightSummaries[cacheKey];
    if (inflight != null) return inflight;

    final future = _apiClient.fetchMarkets(ids: ids).then((markets) {
      final result = <String, MarketSummary>{};

      for (final market in markets) {
        final id = market['id'] as String?;
        if (id == null) continue;
        final symbol = symbolById[id];
        if (symbol == null) continue;

        final price = (market['current_price'] as num?)?.toDouble() ?? 0.0;
        final change1h =
            (market['price_change_percentage_1h_in_currency'] as num?)?.toDouble() ??
                0.0;
        final change24h =
            (market['price_change_percentage_24h_in_currency'] as num?)?.toDouble() ??
                0.0;

        result[symbol] = MarketSummary(
          symbol: symbol,
          name: getNameForSymbol(symbol),
          price: price,
          change1h: change1h,
          change24h: change24h,
        );
      }

      _summaryCache[cacheKey] = _SummaryCacheEntry(now, result);
      return result;
    }).whenComplete(() {
      _inflightSummaries.remove(cacheKey);
    });

    _inflightSummaries[cacheKey] = future;
    return future;
  }

  Future<List<GraphData>> fetchMarketChart(
    String symbol, {
    int days = 1,
  }) async {
    final id = _symbolToId[symbol];
    if (id == null) return [];

    final cacheKey = '$id:$days';
    final now = DateTime.now();
    final cached = _chartCache[cacheKey];
    if (cached != null && now.difference(cached.timestamp) < _chartCacheTtl) {
      return cached.data;
    }

    final inflight = _inflightCharts[cacheKey];
    if (inflight != null) return inflight;

    final future = _apiClient.fetchMarketChart(id: id, days: days).then(
      (prices) {
        final data = prices
            .map(
              (entry) => GraphData(
                DateTime.fromMillisecondsSinceEpoch((entry[0] as num).toInt()),
                (entry[1] as num).toDouble(),
              ),
            )
            .toList();

        final sampled = _downsampleChartData(data, _maxChartPoints);
        _chartCache[cacheKey] = _ChartCacheEntry(now, sampled);
        return sampled;
      },
    ).whenComplete(() {
      _inflightCharts.remove(cacheKey);
    });

    _inflightCharts[cacheKey] = future;
    return future;
  }

  List<GraphData> _downsampleChartData(
    List<GraphData> data,
    int maxPoints,
  ) {
    if (data.length <= maxPoints) return data;
    if (maxPoints < 2) return [data.last];

    final result = <GraphData>[];
    final step = (data.length - 1) / (maxPoints - 1);

    for (int i = 0; i < maxPoints; i++) {
      final index = (i * step).round().clamp(0, data.length - 1);
      result.add(data[index]);
    }

    return result;
  }

  void dispose() {
    _apiClient.dispose();
    _chartCache.clear();
    _inflightCharts.clear();
    _summaryCache.clear();
    _inflightSummaries.clear();
  }
}

class _ChartCacheEntry {
  _ChartCacheEntry(this.timestamp, this.data);

  final DateTime timestamp;
  final List<GraphData> data;
}

class _SummaryCacheEntry {
  _SummaryCacheEntry(this.timestamp, this.data);

  final DateTime timestamp;
  final Map<String, MarketSummary> data;
}
