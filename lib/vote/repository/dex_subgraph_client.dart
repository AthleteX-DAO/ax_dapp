// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:ax_dapp/vote/models/trade_record.dart';
import 'package:ax_dapp/vote/models/trader_summary.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

/// Client that queries the DEX subgraph for swap data, volume, and TVL.
///
/// Accepts a [ValueStream<GraphQLClient>] directly (same constructor pattern
/// as [SubGraphRepo]) so it can perform independent queries.
class DexSubgraphClient {
  DexSubgraphClient({required ValueStream<GraphQLClient> reactiveDexClient})
      : _reactiveDexClient = reactiveDexClient;

  final ValueStream<GraphQLClient> _reactiveDexClient;
  GraphQLClient get _dexGqlClient => _reactiveDexClient.value;

  // ─── Queries ─────────────────────────────────────────────────────────

  /// Fetches the most recent swaps from the DEX subgraph.
  Future<List<TradeRecord>> getRecentSwaps({int limit = 50}) async {
    final query = '''
    query {
      swaps(first: $limit, orderBy: timestamp, orderDirection: desc) {
        id
        timestamp
        pair {
          token0 { symbol }
          token1 { symbol }
        }
        sender
        amount0In
        amount1In
        amount0Out
        amount1Out
        amountUSD
      }
    }
    ''';

    final data = await _executeQuery(query);
    if (data == null) return [];

    final swaps = data['swaps'] as List<dynamic>? ?? [];
    return swaps.map((swap) {
      final pair = swap['pair'] as Map<String, dynamic>;
      final token0Symbol =
          (pair['token0'] as Map<String, dynamic>)['symbol'] as String? ?? '';
      final token1Symbol =
          (pair['token1'] as Map<String, dynamic>)['symbol'] as String? ?? '';

      final amount0In = double.tryParse('${swap['amount0In']}') ?? 0;
      final amount1In = double.tryParse('${swap['amount1In']}') ?? 0;
      final amount0Out = double.tryParse('${swap['amount0Out']}') ?? 0;
      final amount1Out = double.tryParse('${swap['amount1Out']}') ?? 0;
      var amountUSD = double.tryParse('${swap['amountUSD']}') ?? 0;

      // If the subgraph returns amountUSD=0 (common for custom tokens like
      // prediction YES/NO tokens), derive the USD value from the axUSD side.
      // axUSD is pegged to $1, so whichever axUSD amount flows is the $ value.
      if (amountUSD == 0) {
        amountUSD = _deriveUsdAmount(
          token0Symbol, token1Symbol,
          amount0In, amount1In, amount0Out, amount1Out,
        );
      }

      // Determine side: if amount0In > 0 the sender sold token0 (buy token1)
      final isBuy = amount0In > 0;
      final symbol = isBuy ? token1Symbol : token0Symbol;

      return TradeRecord(
        walletAddress: swap['sender'] as String? ?? '',
        side: isBuy ? 'buy' : 'sell',
        amount: amountUSD,
        price: amountUSD,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          (int.tryParse('${swap['timestamp']}') ?? 0) * 1000,
        ),
        txHash: swap['id'] as String? ?? '',
        tokenSymbol: symbol,
        marketName: '$token0Symbol/$token1Symbol',
      );
    }).toList();
  }

  /// Queries `pairDayDatas` for the aggregate 24-hour volume.
  ///
  /// Falls back to summing individual swap amounts (using axUSD-derived values)
  /// when the subgraph can't price custom tokens.
  Future<double> get24hVolume() async {
    final yesterday = (DateTime.now()
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch /
            1000)
        .round();

    // First try pairDayDatas (fast aggregate)
    final query = '''
    query {
      pairDayDatas(
        where: { date_gte: $yesterday }
        orderBy: dailyVolumeUSD
        orderDirection: desc
        first: 1000
      ) {
        dailyVolumeUSD
      }
    }
    ''';

    final data = await _executeQuery(query);
    if (data != null) {
      final dayDatas = data['pairDayDatas'] as List<dynamic>? ?? [];
      var total = 0.0;
      for (final entry in dayDatas) {
        total += double.tryParse('${entry['dailyVolumeUSD']}') ?? 0;
      }
      if (total > 0) return total;
    }

    // Fallback: sum USD from individual swaps in last 24h
    final swapQuery = '''
    query {
      swaps(
        first: 1000
        where: { timestamp_gte: "$yesterday" }
        orderBy: timestamp
        orderDirection: desc
      ) {
        amountUSD
        amount0In
        amount1In
        amount0Out
        amount1Out
        pair {
          token0 { symbol }
          token1 { symbol }
        }
      }
    }
    ''';

    final swapData = await _executeQuery(swapQuery);
    if (swapData == null) return 0;

    final swaps = swapData['swaps'] as List<dynamic>? ?? [];
    var total = 0.0;
    for (final swap in swaps) {
      var usd = double.tryParse('${swap['amountUSD']}') ?? 0;
      if (usd == 0) {
        final pair = swap['pair'] as Map<String, dynamic>?;
        if (pair != null) {
          final t0 = (pair['token0'] as Map<String, dynamic>?)?['symbol'] as String? ?? '';
          final t1 = (pair['token1'] as Map<String, dynamic>?)?['symbol'] as String? ?? '';
          usd = _deriveUsdAmount(
            t0, t1,
            double.tryParse('${swap['amount0In']}') ?? 0,
            double.tryParse('${swap['amount1In']}') ?? 0,
            double.tryParse('${swap['amount0Out']}') ?? 0,
            double.tryParse('${swap['amount1Out']}') ?? 0,
          );
        }
      }
      total += usd;
    }
    return total;
  }

  /// Queries recent swaps and aggregates by sender to find top traders.
  Future<List<TraderSummary>> getTopTraders({int limit = 10}) async {
    // Fetch a larger set of swaps to aggregate
    final query = '''
    query {
      swaps(first: 500, orderBy: timestamp, orderDirection: desc) {
        sender
        amountUSD
        amount0In
        amount1In
        amount0Out
        amount1Out
        timestamp
        pair {
          token0 { symbol }
          token1 { symbol }
        }
      }
    }
    ''';

    final data = await _executeQuery(query);
    if (data == null) return [];

    final swaps = data['swaps'] as List<dynamic>? ?? [];
    final traderMap = <String, _TraderAccumulator>{};

    for (final swap in swaps) {
      final sender = swap['sender'] as String? ?? '';
      var usd = double.tryParse('${swap['amountUSD']}') ?? 0;
      final ts = int.tryParse('${swap['timestamp']}') ?? 0;

      // Derive USD from axUSD side when amountUSD is 0
      if (usd == 0) {
        final pair = swap['pair'] as Map<String, dynamic>?;
        if (pair != null) {
          final t0 = (pair['token0'] as Map<String, dynamic>?)?['symbol'] as String? ?? '';
          final t1 = (pair['token1'] as Map<String, dynamic>?)?['symbol'] as String? ?? '';
          usd = _deriveUsdAmount(
            t0, t1,
            double.tryParse('${swap['amount0In']}') ?? 0,
            double.tryParse('${swap['amount1In']}') ?? 0,
            double.tryParse('${swap['amount0Out']}') ?? 0,
            double.tryParse('${swap['amount1Out']}') ?? 0,
          );
        }
      }

      traderMap.putIfAbsent(
        sender,
        () => _TraderAccumulator(sender),
      );
      traderMap[sender]!.add(usd, ts);
    }

    final sorted = traderMap.values.toList()
      ..sort((a, b) => b.volume.compareTo(a.volume));

    return sorted.take(limit).map((t) => t.toSummary()).toList();
  }

  /// Queries all pairs and sums `reserveUSD` — used as a TVL / OI proxy.
  Future<double> getTotalValueLocked() async {
    final query = '''
    query {
      pairs(first: 1000) {
        reserveUSD
      }
    }
    ''';

    final data = await _executeQuery(query);
    if (data == null) return 0;

    final pairs = data['pairs'] as List<dynamic>? ?? [];
    var total = 0.0;
    for (final pair in pairs) {
      total += double.tryParse('${pair['reserveUSD']}') ?? 0;
    }
    return total;
  }

  // ─── Helpers ─────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> _executeQuery(String query) async {
    try {
      final result = await _dexGqlClient.query(
        QueryOptions(document: parseString(query)),
      );
      if (result.hasException) {
        return _tryPostQuery(query);
      }
      return result.data;
    } catch (e) {
      debugPrint('[DexSubgraphClient] query error: $e');
      return _tryPostQuery(query);
    }
  }

  Future<Map<String, dynamic>?> _tryPostQuery(String query) async {
    try {
      final uri = (_dexGqlClient.link as HttpLink).uri;
      final result = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query}),
      );
      if (result.statusCode != 200) return null;
      final body = jsonDecode(result.body) as Map<String, dynamic>;
      return body['data'] as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('[DexSubgraphClient] POST fallback error: $e');
      return null;
    }
  }

  /// Derives USD amount from axUSD token amounts when `amountUSD` is 0.
  ///
  /// Since axUSD is pegged to $1, whichever side of the swap involves axUSD
  /// gives us the dollar value directly.
  static double _deriveUsdAmount(
    String token0Symbol,
    String token1Symbol,
    double amount0In,
    double amount1In,
    double amount0Out,
    double amount1Out,
  ) {
    // Stablecoin symbols that are worth ~$1
    const stableSymbols = {'axUSD', 'USDC', 'USDT', 'DAI', 'USDC.e'};

    if (stableSymbols.contains(token0Symbol)) {
      // token0 is the stable — use its in or out amount
      return amount0In > 0 ? amount0In : amount0Out;
    }
    if (stableSymbols.contains(token1Symbol)) {
      return amount1In > 0 ? amount1In : amount1Out;
    }
    // Neither side is a known stable — can't derive
    return 0;
  }
}

/// Internal accumulator for aggregating trader stats.
class _TraderAccumulator {
  _TraderAccumulator(this.sender);

  final String sender;
  double volume = 0;
  int count = 0;
  int latestTs = 0;

  void add(double usd, int ts) {
    volume += usd;
    count++;
    if (ts > latestTs) latestTs = ts;
  }

  TraderSummary toSummary() => TraderSummary(
        walletAddress: sender,
        totalVolume: volume,
        tradeCount: count,
        lastTradeTimestamp:
            DateTime.fromMillisecondsSinceEpoch(latestTs * 1000),
      );
}
