import 'package:ax_dapp/app/view/app_routing.dart';
import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/bloc/prediction_page_bloc.dart';
import 'package:ax_dapp/prediction/widgets/prompt_details.dart';
import 'package:ax_dapp/prediction/widgets/desktop_prediction_widget.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/prediction/widgets/graph_side.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class PredictionPage extends StatelessWidget {
  PredictionPage({super.key, required this.prediction});

  final PredictionModel prediction;
  final Global global = Global();

  @override
  Widget build(BuildContext context) {
    final paramPrompt = prediction.prompt;

    if (global.pageName != 'prediction') {
      context.goNamed(
        global.pageName,
        params: {'id': paramPrompt},
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TopNavigationBarWeb(page: global.pageName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: const BottomNavigationBarWeb(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blurredBackground.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocProvider(
          create: (context) => PredictionPageBloc(
            walletRepository: context.read<WalletRepository>(),
            tokensRepository: context.read<TokensRepository>(),
            eventMarketRepository: context.read<EventMarketRepository>(),
            streamAppDataChangesUseCase:
                context.read<StreamAppDataChangesUseCase>(),
          ),
          child: BlocListener<PredictionPageBloc, PredictionPageState>(
            listener: (context, state) {
              if (state.status == BlocStatus.loading) {}
            },
            child: BlocBuilder<PredictionPageBloc, PredictionPageState>(
              buildWhen: (previous, current) =>
                  current.status == BlocStatus.initial,
              builder: (_, state) {
                return SizedBox(
                  height: 660,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GraphSide(
                            predictionModel: state.predictionModel,
                          ),
                          PromptDetails(
                            model: state.predictionModel,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}