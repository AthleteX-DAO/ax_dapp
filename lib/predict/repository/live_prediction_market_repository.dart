import 'package:ax_dapp/predict/data/prediction_api_client.dart';
import 'package:ax_dapp/predict/data/prediction_market_client.dart';
import 'package:ax_dapp/predict/data/prediction_market_manifest.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/models/supported_prediction_markets.dart';
import 'package:flutter/foundation.dart';

/// Repository that combines the deployment manifest (static JSON) with
/// live on-chain reads (via [PredictionMarketClient]) to produce
/// [PredictionModel] objects for the UI.
///
/// Domain layer — applies business rules, composes data clients.
/// NO Flutter widget dependencies.
class LivePredictionMarketRepository {
  LivePredictionMarketRepository({
    required PredictionMarketClient predictionMarketClient,
    PredictionMarketManifest? manifest,
    PredictionApiClient? apiClient,
  })  : _client = predictionMarketClient,
        _manifest = manifest,
        _apiClient = apiClient;

  final PredictionMarketClient _client;
  final PredictionApiClient? _apiClient;
  PredictionMarketManifest? _manifest;

  /// Ensure the manifest is loaded (cached after first call).
  Future<PredictionMarketManifest> _loadManifest() async {
    if (_manifest != null) return _manifest!;
    _manifest = await PredictionMarketManifest.loadFromAssets();
    return _manifest!;
  }

  /// Fetch all live prediction markets, enriched with on-chain data.
  /// Optionally filter by [category].
  Future<List<PredictionModel>> getLivePredictionMarkets({
    SupportedPredictionMarkets category = SupportedPredictionMarkets.all,
  }) async {
    final manifest = await _loadManifest();

    // Fetch API volumes in parallel with chain data
    final apiVolumes = <String, double>{};
    if (_apiClient != null) {
      try {
        final apiMarkets = await _apiClient!.fetchMarkets();
        for (final am in apiMarkets) {
          apiVolumes[am.marketAddress.toLowerCase()] = am.tradingVolume;
        }
      } catch (e) {
        debugPrint('Failed to fetch API volumes: $e');
      }
    }

    // Build PredictionModels from manifest — fetch chain data in parallel.
    final futures = manifest.markets.map((deployedMarket) async {
      try {
        final chainData = await _client.getMarketData(
          deployedMarket.contractAddress,
          deployedMarket.longTokenAddress,
          deployedMarket.shortTokenAddress,
        );
        return _toPredictionModel(deployedMarket, chainData, apiVolumes);
      } catch (e) {
        debugPrint(
          'Failed to fetch chain data for ${deployedMarket.pairName}: $e',
        );
        // Return with defaults so the card still renders
        return _toPredictionModel(
          deployedMarket,
          MarketOnChainData.empty(),
          apiVolumes,
        );
      }
    });

    final models = await Future.wait(futures);

    if (category == SupportedPredictionMarkets.all) return models;

    return models
        .where((m) => m.supportedPredictionMarkets == category)
        .toList();
  }

  /// Convert a manifest entry + on-chain data to a [PredictionModel].
  PredictionModel _toPredictionModel(
    DeployedMarketConfig config,
    MarketOnChainData chainData,
    Map<String, double> apiVolumes,
  ) {
    // Determine resolution status
    bool? resolution;
    if (chainData.isResolved) {
      // 1e18 = YES wins, 0 = NO wins, 5e17 = draw
      if (chainData.settlementPrice >= BigInt.from(1e18.toInt())) {
        resolution = true;
      } else if (chainData.settlementPrice == BigInt.zero) {
        resolution = false;
      }
      // 5e17 (draw) → null resolution for now
    }

    // Use API volume if available, otherwise fall back to on-chain proxy
    final marketId = config.contractAddress.hashCode;
    final volume = apiVolumes[config.contractAddress.toLowerCase()] ??
        chainData.tradingVolume;

    return PredictionModel(
      id: marketId,
      prompt: config.question,
      details: config.details,
      marketAddress: config.contractAddress,
      yesTokenAddress: config.longTokenAddress,
      noTokenAddress: config.shortTokenAddress,
      yesName: config.longTokenName,
      noName: config.shortTokenName,
      resolution: resolution,
      tradingVolume: volume,
      supportedPredictionMarkets: _parseCategory(config.category),
      time: config.resolveBy,
      longTokenPrice: chainData.yesPrice,
      shortTokenPrice: chainData.noPrice,
      longTokenPercentage: chainData.yesPrice * 100,
      shortTokenPercentage: chainData.noPrice * 100,
      longTokenPriceUsd: chainData.yesPrice,
      shortTokenPriceUsd: chainData.noPrice,
      yesTokenSupply: chainData.yesTokenSupply.toDouble() / 1e18,
      noTokenSupply: chainData.noTokenSupply.toDouble() / 1e18,
    );
  }

  /// Map the JSON category string to the enum.
  SupportedPredictionMarkets _parseCategory(String category) {
    switch (category.toLowerCase()) {
      case 'football':
        return SupportedPredictionMarkets.football;
      case 'basketball':
        return SupportedPredictionMarkets.basketball;
      case 'soccer':
        return SupportedPredictionMarkets.soccer;
      case 'baseball':
        return SupportedPredictionMarkets.baseball;
      case 'hockey':
        return SupportedPredictionMarkets.hockey;
      case 'college':
        return SupportedPredictionMarkets.college;
      case 'voted':
        return SupportedPredictionMarkets.voted;
      case 'exotic':
        return SupportedPredictionMarkets.exotic;
      default:
        return SupportedPredictionMarkets.exotic;
    }
  }
}
