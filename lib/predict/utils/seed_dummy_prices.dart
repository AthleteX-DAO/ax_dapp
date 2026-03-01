import 'package:ax_dapp/predict/data/firebase_price_client.dart';
import 'package:ax_dapp/predict/repository/live_prediction_market_repository.dart';
import 'package:ax_dapp/predict/usecases/get_top_prediction_markets_usecase.dart';

/// Seed dummy price data for top prediction markets in Firebase.
/// 
/// This utility generates 24-hour price history for the top 4 markets
/// by trading volume. YES prices trend upward, NO prices trend downward.
/// 
/// Usage:
/// ```dart
/// await seedTopMarketsWithDummyPrices(
///   firebaseClient: firebaseClient,
///   getTopMarketsUseCase: getTopMarketsUseCase,
/// );
/// ```
Future<void> seedTopMarketsWithDummyPrices({
  required FirebasePriceClient firebaseClient,
  required GetTopPredictionMarketsUseCase getTopMarketsUseCase,
}) async {
  try {
    print('🌱 Seeding dummy prices for top prediction markets...');

    // Get top 4 markets by trading volume
    final topMarkets = await getTopMarketsUseCase.call(limit: 4);

    if (topMarkets.isEmpty) {
      print('⚠️  No markets found to seed.');
      return;
    }

    print('📊 Found ${topMarkets.length} top markets:');
    for (final market in topMarkets) {
      print('   • ${market.prompt} (Vol: \$${market.tradingVolume.toStringAsFixed(2)}M)');
    }

    // Seed dummy prices for each market
    print('\n🔄 Seeding Firebase collections...');
    final futures = topMarkets.map((market) {
      print('   Seeding: ${market.prompt}');
      return firebaseClient.seedDummyPriceData(
        market.id.toString(),
        market.marketAddress,
      );
    });

    await Future.wait(futures);

    print('\n✅ Successfully seeded dummy prices!');
    print('   Collection: prediction_markets_prices');
    print('   Markets: ${topMarkets.length}');
    print('   Data points per market: 48 (YES + NO, 24 hours)');
  } catch (e) {
    print('❌ Error seeding prices: $e');
    rethrow;
  }
}
