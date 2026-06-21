import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/data/prediction_order_client.dart';
import 'package:ax_dapp/predict/usecase/get_prediction_market_data_use_case.dart';
import 'package:ax_dapp/prediction/bloc/prediction_page_bloc.dart';
import 'package:ax_dapp/prediction/repository/prediction_address_repository.dart';
import 'package:ax_dapp/prediction/widgets/graph_side.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class PredictionHero extends StatelessWidget {
  const PredictionHero({
    super.key,
    required this.predictionModel,
  });

  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PredictionPageBloc(
        walletRepository: context.read<WalletRepository>(),
        eventMarketRepository: context.read<EventMarketRepository>(),
        streamAppDataChangesUseCase:
            context.read<StreamAppDataChangesUseCase>(),
        predictionAddressRepository:
            context.read<PredictionAddressRepository>(),
        predictionModelId: predictionModel.id,
        getPredictionMarketDataUseCase:
            context.read<GetPredictionMarketDataUseCase>(),
        tokensRepository: context.read<TokensRepository>(),
        predictionOrderClient: context.read<PredictionOrderClient>(),
      ),
      child: BlocListener<PredictionPageBloc, PredictionPageState>(
        listener: (context, state) {
          final bloc = context.read<PredictionPageBloc>();
          if (state.status == BlocStatus.success) {
            bloc.add(
              PredictionPageLoaded(
                predictionModel: predictionModel,
              ),
            );
          }
        },
        child: BlocBuilder<PredictionPageBloc, PredictionPageState>(
          buildWhen: (previous, current) => previous.stats != current.stats,
          builder: (context, state) {
            final chartStats = state.stats;
            return _PredictionHeroView(
              predictionModel: predictionModel,
              chartStats: chartStats,
            );
          },
        ),
      ),
    );
  }
}

class _PredictionHeroView extends StatelessWidget {
  const _PredictionHeroView({
    required this.predictionModel,
    required this.chartStats,
  });

  final PredictionModel predictionModel;
  final List<GraphData> chartStats;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.sizeOf(context).width;
    // Calculate container dimensions based on screen size, similar to GraphSide logic
    // but adapted for a Hero section (full width or large card)
    final containerWdt = _width * 0.9;
    const containerHgt = 400.0;

    return Container(
      width: containerWdt,
      height: containerHgt,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: boxDecoration(
        Colors.grey[800]!.withOpacity(0.6),
        30,
        0.5,
        Colors.grey[400]!,
      ),
      child: Row(
        children: [
          // Chart Section (Reusing GraphSide logic but simplified)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GraphSide(
                predictionModel: predictionModel,
                chartStats: chartStats,
                containerHeight: containerHgt,
                containerWidth: containerWdt * 0.6,
              ),
            ),
          ),
          // Info / Stats Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    predictionModel.prompt,
                    style: textStyle(Colors.white, 24,
                        isBold: true, isUline: false,),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _ProbabilityBadge(
                        label: 'Yes',
                        probability: predictionModel
                            .yesName, // Assuming yesName holds price/prob for now or use other field
                        color: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      _ProbabilityBadge(
                        label: 'No',
                        probability: predictionModel.noName,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Placeholder for News or additional info
                  Text(
                    'News: Market trending upwards due to recent events...',
                    style: textStyle(Colors.grey, 14,
                        isBold: false, isUline: false,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProbabilityBadge extends StatelessWidget {
  const _ProbabilityBadge({
    required this.label,
    required this.probability,
    required this.color,
  });

  final String label;
  final String probability;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: textStyle(color, 16, isBold: true, isUline: false),
          ),
          const SizedBox(width: 8),
          Text(
            probability, // This might need formatting if it's just a name
            style: textStyle(Colors.white, 16, isBold: true, isUline: false),
          ),
        ],
      ),
    );
  }
}
