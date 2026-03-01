import 'package:ax_dapp/predict/models/market_price_record.dart';
import 'package:ax_dapp/service/prediction_models/prediction_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Lightweight Firestore-based price client for high-frequency price data
/// Collections: prediction_markets_prices, spot_markets_prices, perp_markets_prices
/// Structure: {marketId}_{tokenType}_{timestamp}: {price}
class FirebasePriceClient {
  const FirebasePriceClient({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  /// Get YES token price history for prediction market
  Future<List<PriceRecord>> getYesPriceHistory(
    String marketAddress,
    String startDate,
  ) async {
    try {
      final query = _firestore
          .collection('prediction_markets_prices')
          .where('marketId', isEqualTo: marketAddress)
          .where('token', isEqualTo: 'YES')
          .where('timestamp', isGreaterThanOrEqualTo: startDate)
          .orderBy('timestamp', descending: true)
          .limit(100);

      final docs = await query.get();
      return docs.docs
          .map((doc) => PriceRecord(
                price: (doc['price'] as num).toDouble(),
                timestamp: doc['timestamp'] as String,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error fetching YES price history: $e');
      return [];
    }
  }

  /// Get NO token price history for prediction market
  Future<List<PriceRecord>> getNoPriceHistory(
    String marketAddress,
    String startDate,
  ) async {
    try {
      final query = _firestore
          .collection('prediction_markets_prices')
          .where('marketId', isEqualTo: marketAddress)
          .where('token', isEqualTo: 'NO')
          .where('timestamp', isGreaterThanOrEqualTo: startDate)
          .orderBy('timestamp', descending: true)
          .limit(100);

      final docs = await query.get();
      return docs.docs
          .map((doc) => PriceRecord(
                price: (doc['price'] as num).toDouble(),
                timestamp: doc['timestamp'] as String,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error fetching NO price history: $e');
      return [];
    }
  }

  /// Get complete market price history (YES and NO tokens)
  Future<MarketPriceRecord?> getMarketPriceHistory(
    String marketAddress,
    String startDate,
    String marketId,
  ) async {
    try {
      final yesHistory = await getYesPriceHistory(marketAddress, startDate);
      final noHistory = await getNoPriceHistory(marketAddress, startDate);

      if (yesHistory.isEmpty || noHistory.isEmpty) {
        return null;
      }

      return MarketPriceRecord(
        yesRecord: PredictionPriceRecord(
          id: marketId.hashCode,
          name: '$marketId-YES',
          priceHistory: yesHistory,
        ),
        noRecord: PredictionPriceRecord(
          id: marketId.hashCode,
          name: '$marketId-NO',
          priceHistory: noHistory,
        ),
      );
    } catch (e) {
      debugPrint('Error fetching market price history: $e');
      return null;
    }
  }

  /// Seed dummy price data for development
  Future<void> seedDummyPriceData(String marketId, String marketAddress) async {
    try {
      final now = DateTime.now();
      final batch = _firestore.batch();

      // Generate 24 hourly price points for both YES and NO
      for (int i = 0; i < 24; i++) {
        final timestamp =
            now.subtract(Duration(hours: i)).toIso8601String().split('.')[0];

        // YES prices (trending up slightly)
        final yesPrice = 0.45 + (i * 0.002);
        final yesDoc = _firestore
            .collection('prediction_markets_prices')
            .doc('${marketAddress}_YES_$timestamp');
        batch.set(yesDoc, {
          'marketId': marketAddress,
          'token': 'YES',
          'price': yesPrice,
          'timestamp': timestamp,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // NO prices (trending down)
        final noPrice = 0.55 - (i * 0.002);
        final noDoc = _firestore
            .collection('prediction_markets_prices')
            .doc('${marketAddress}_NO_$timestamp');
        batch.set(noDoc, {
          'marketId': marketAddress,
          'token': 'NO',
          'price': noPrice,
          'timestamp': timestamp,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      debugPrint('Seeded dummy price data for market: $marketId');
    } catch (e) {
      debugPrint('Error seeding dummy price data: $e');
    }
  }
}
