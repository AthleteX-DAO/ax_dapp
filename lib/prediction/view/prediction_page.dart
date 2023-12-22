import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/usecase/get_prediction_market_data_use_case.dart';
import 'package:ax_dapp/prediction/bloc/prediction_page_bloc.dart';
import 'package:ax_dapp/prediction/repository/prediction_address_repository.dart';
import 'package:ax_dapp/prediction/view/prediction_page_web_view.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class PredictionPage extends StatelessWidget {
  const PredictionPage({
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
            return PredictionPageWebView(
              predictionModel: predictionModel,
              chartStats: chartStats,
            );
          },
        ),
      ),
    );
  }
}
