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
  // Per-symbol cache populated from batch results so single-symbol lookups
  // hit cached data instead of making a new API call.
  final Map<String, _SymbolCacheEntry> _perSymbolCache = {};

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
    'USDe': 'ethena-usde',
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
    'USDe': 'Ethena USDe',
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
    final now = DateTime.now();

    // For small queries (1-2 symbols), check per-symbol cache first.
    // This avoids making a new API call when a recent batch already cached them.
    if (symbols.length <= 2) {
      final fromCache = <String, MarketSummary>{};
      var allCached = true;
      for (final symbol in symbols) {
        final entry = _perSymbolCache[symbol];
        if (entry != null &&
            now.difference(entry.timestamp) < _summaryCacheTtl) {
          fromCache[symbol] = entry.data;
        } else {
          allCached = false;
          break;
        }
      }
      if (allCached) return fromCache;
    }

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
    final cached = _summaryCache[cacheKey];
    if (cached != null && now.difference(cached.timestamp) < _summaryCacheTtl) {
      return cached.data;
    }

    final inflight = _inflightSummaries[cacheKey];
    if (inflight != null) return inflight;

    final future = _apiClient.fetchMarkets(ids: ids).then((markets) {
      final result = <String, MarketSummary>{};
      final fetchTime = DateTime.now();

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

        final summary = MarketSummary(
          symbol: symbol,
          name: getNameForSymbol(symbol),
          price: price,
          change1h: change1h,
          change24h: change24h,
        );
        result[symbol] = summary;

        // Populate per-symbol cache so subsequent single-symbol lookups hit cache
        _perSymbolCache[symbol] = _SymbolCacheEntry(fetchTime, summary);
      }

      _summaryCache[cacheKey] = _SummaryCacheEntry(fetchTime, result);
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

    for (var i = 0; i < maxPoints; i++) {
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
    _perSymbolCache.clear();
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

class _SymbolCacheEntry {
  _SymbolCacheEntry(this.timestamp, this.data);

  final DateTime timestamp;
  final MarketSummary data;
}
