import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/prediction/repository/prediction_address_repository.dart';

class GetPredictionMarketInfoUseCase {
  const GetPredictionMarketInfoUseCase({
    required this.predictionSnapshotRepository,
    required this.predictionAddressRepository,
  });

  final PredictionSnapshotRepository predictionSnapshotRepository;
  final PredictionAddressRepository predictionAddressRepository;

  Future<List<PredictionModel>> fetchPredictionModel() async {
    final markets = <PredictionModel>[];
    final predictionModel =
        await predictionSnapshotRepository.fetchCurrentMarkets();
    for (final model in predictionModel) {
      final predictionInfo =
          await predictionAddressRepository.fetchMarketAddresses(model.id);
      final predictionModel = PredictionModel(
        id: model.id,
        prompt: model.prompt,
        details: model.details,
        marketAddress: '',
        yesTokenAddress: predictionInfo.isEmpty ? '' : predictionInfo[0],
        noTokenAddress: predictionInfo.isEmpty ? '' : predictionInfo[1],
        yesName: predictionInfo.isEmpty ? '' : predictionInfo[2],
        noName: predictionInfo.isEmpty ? '' : predictionInfo[3],
      );
      markets.add(predictionModel);
    }
    return markets;
  }
}
