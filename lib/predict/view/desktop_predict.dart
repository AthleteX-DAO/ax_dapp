import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/widgets/loader.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesktopPredict extends StatefulWidget {
  const DesktopPredict({
    super.key,
  });

  @override
  State<DesktopPredict> createState() => _DesktopPredictState();
}

class _DesktopPredictState extends State<DesktopPredict> {
  Global global = Global();
  EthereumChain? _selectedChain;
  @override
  Widget build(BuildContext context) {
    context
        .read<TopNavigationBarBloc>()
        .add(const SelectButtonEvent(buttonName: 'predict'));
    context
        .read<BottomNavigationBarBloc>()
        .add(const SelectItemEvent(itemIndex: 0));
    return BlocBuilder<PredictPageBloc, PredictPageState>(
      builder: (context, state) {
        final bloc = context.read<PredictPageBloc>();
        global.predictions = state.predictions;
        final currentPredictions = [
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
          PredictionModel.empty,
        ];
        if (_selectedChain != state.selectedChain) {
          _selectedChain = state.selectedChain;
          bloc.add(
            const LoadPredictionsEvent(),
          );
        }
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              margin: const EdgeInsets.only(top: 20),
              height: constraints.maxHeight * 0.90,
              width: constraints.maxWidth * 0.99,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Divider(
                      color: Colors.grey,
                    ),
                  ),
                  const PredictionMarketsFilterDesktop(),
                  const DesktopHeaders(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (state.status == BlocStatus.loading) const Loader(),
                      if (state.status == BlocStatus.error)
                        const PredictionLoadingStatus(
                          message: 'Unable to load markets, please refresh',
                        ),

                      /// List of all available prediction markets
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket ==
                              SupportedPredictionMarkets.all)
                        SizedBox(
                          height: constraints.maxHeight * 0.8 - 120,
                          child: const Center(
                            child: SizedBox(
                              height: 70,
                              child: Text(
                                'Select a market from the tabs above',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 30,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                          ),
                        ),

                      /// College Athlete Prediction Markets
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket ==
                              SupportedPredictionMarkets.college)
                        CollegeMarkets(
                          boxConstraints: constraints,
                        ),

                      /// Basketball Athletes Prediction Markets
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket ==
                              SupportedPredictionMarkets.basketball)
                        BasketballMarkets(
                          boxConstraints: constraints,
                        ),

                      /// Football Athletes Prediction Markets
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket ==
                              SupportedPredictionMarkets.football)
                        FootballMarkets(
                          boxConstraints: constraints,
                        ),

                      /// Hockey Athletes Prediction Markets
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket ==
                              SupportedPredictionMarkets.hockey)
                        HockeyMarkets(
                          boxConstraints: constraints,
                        ),

                      /// Baseball Athletes Prediction Markets
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket ==
                              SupportedPredictionMarkets.baseball)
                        BaseballMarkets(
                          boxConstraints: constraints,
                        ),

                      /// Soccer Athletes Prediction Markets
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket ==
                              SupportedPredictionMarkets.soccer)
                        SoccerMarkets(
                          boxConstraints: constraints,
                        ),

                      /// Voted Prediction Markets
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket ==
                              SupportedPredictionMarkets.voted)
                        VotedMarkets(
                          boxConstraints: constraints,
                        ),

                      /// Exotic Athletes Prediction Markets
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket ==
                              SupportedPredictionMarkets.exotic)
                        ExoticMarkets(
                          boxConstraints: constraints,
                        ),

                      /// Empty Space when loading markets
                      SizedBox(
                        height: constraints.maxHeight * 0.8 - 120,
                        child: const Center(
                          child: SizedBox(
                            height: 70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
