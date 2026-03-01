import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/repository/live_prediction_market_repository.dart';

/// Use case: Get top prediction markets sorted by trading volume
/// Returns top N markets by lifetime trading volume (descending order)
class GetTopPredictionMarketsUseCase {
  const GetTopPredictionMarketsUseCase({
    required LivePredictionMarketRepository livePredictionMarketRepository,
  }) : _livePredictionMarketRepository = livePredictionMarketRepository;

  final LivePredictionMarketRepository _livePredictionMarketRepository;

  /// Get top N prediction markets by trading volume
  /// [limit]: Number of markets to return (default: 4)
  /// Returns sorted list by trading volume (highest first)
  Future<List<PredictionModel>> call({int limit = 4}) async {
    try {
      final allMarkets =
          await _livePredictionMarketRepository.getLivePredictionMarkets();

      // Sort by trading volume descending (highest first)
      final sorted = List<PredictionModel>.from(allMarkets)
        ..sort((a, b) => (b.tradingVolume).compareTo(a.tradingVolume));

      // Return top N markets
      return sorted.take(limit).toList();
    } catch (e) {
      rethrow;
    }
  }
}
