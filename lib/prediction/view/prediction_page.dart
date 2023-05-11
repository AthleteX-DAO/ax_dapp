import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/bloc/prediction_page_bloc.dart';
import 'package:ax_dapp/prediction/widgets/graph_side.dart';
import 'package:ax_dapp/prediction/widgets/prompt_details.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/widgets/widgets.dart';
import 'package:flutter/material.dart';
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
      resizeToAvoidBottomInset: true,
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
              final bloc = context.read<PredictionPageBloc>();
              if (state.status == BlocStatus.error) {
                bloc.add(const LoadingPredictionPage());
              }

              if (state.status == BlocStatus.success) {
                bloc.add(
                  PredictionPageLoaded(
                    predictionModel: prediction,
                  ),
                );
              }
            },
            child: BlocBuilder<PredictionPageBloc, PredictionPageState>(
              buildWhen: (previous, current) =>
                  current.status == BlocStatus.success,
              builder: (context, state) {
                return SizedBox(
                  height: 660,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // if (state.status == BlocStatus.loading)
                          //   const Loader(),
                          if (state.status == BlocStatus.initial ||
                              state.status == BlocStatus.success)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GraphSide(
                                  predictionModel: prediction,
                                ),
                                PromptDetails(
                                  model: prediction,
                                )
                              ],
                            ),
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
