import 'package:ax_dapp/predict/bloc/predict_page_bloc.dart';
import 'package:ax_dapp/predict/models/models.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PredictionMarketsFilterDesktop extends StatefulWidget {
  const PredictionMarketsFilterDesktop({super.key});

  @override
  State<PredictionMarketsFilterDesktop> createState() =>
      _PredictionMarketsFilterDesktopState();
}

class _PredictionMarketsFilterDesktopState
    extends State<PredictionMarketsFilterDesktop> {
  final marketsSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const sportFilterTxSz = 14.0;
    final bloc = context.read<PredictPageBloc>();
    final _selectedMarket =
        context.read<PredictPageBloc>().state.selectedMarket;
    return Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 10,
        ),
        height: 40,
        child: Row(
          children: [
            Text(
              'Athlete Prediction Markets',
              style: textStyle(
                Colors.white,
                18,
                isBold: false,
                isUline: false,
              ),
            ),
            Text(
              '|',
              style: textStyle(
                Colors.white,
                18,
                isBold: false,
                isUline: false,
              ),
            ),
            TextButton(
              onPressed: () {
                marketsSearchController.clear();
                bloc
                  ..add(
                    const SelectedPredictionMarketsChanged(
                      selectedMarkets: SupportedPredictionMarkets.College,
                    ),
                  )
                  ..add(const CollegePredictionMarketsRequested());
              },
              child: Text(
                'College',
                style: textSwapState(
                  condition:
                      _selectedMarket == SupportedPredictionMarkets.College,
                  tabNotSelected: textStyle(
                    Colors.white,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: false,
                  ),
                  tabSelected: textStyle(
                    Colors.amber[400]!,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: true,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                marketsSearchController.clear();
                bloc
                  ..add(
                    const SelectedPredictionMarketsChanged(
                      selectedMarkets: SupportedPredictionMarkets.Basketball,
                    ),
                  )
                  ..add(const BasketballPredictionMarketsRequested());
              },
              child: Text(
                'Basketball',
                style: textSwapState(
                  condition:
                      _selectedMarket == SupportedPredictionMarkets.Basketball,
                  tabNotSelected: textStyle(
                    Colors.white,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: false,
                  ),
                  tabSelected: textStyle(
                    Colors.amber[400]!,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: true,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                marketsSearchController.clear();
                bloc
                  ..add(
                    const SelectedPredictionMarketsChanged(
                      selectedMarkets: SupportedPredictionMarkets.Football,
                    ),
                  )
                  ..add(const FootballPredictionMarketsRequested());
              },
              child: Text(
                'Football',
                style: textSwapState(
                  condition:
                      _selectedMarket == SupportedPredictionMarkets.Football,
                  tabNotSelected: textStyle(
                    Colors.white,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: false,
                  ),
                  tabSelected: textStyle(
                    Colors.amber[400]!,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: true,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                marketsSearchController.clear();
                bloc
                  ..add(
                    const SelectedPredictionMarketsChanged(
                      selectedMarkets: SupportedPredictionMarkets.Hockey,
                    ),
                  )
                  ..add(const HockeyPredictionMarketsRequested());
              },
              child: Text(
                'Hockey',
                style: textSwapState(
                  condition:
                      _selectedMarket == SupportedPredictionMarkets.Hockey,
                  tabNotSelected: textStyle(
                    Colors.white,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: false,
                  ),
                  tabSelected: textStyle(
                    Colors.amber[400]!,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: true,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                marketsSearchController.clear();
                bloc
                  ..add(
                    const SelectedPredictionMarketsChanged(
                      selectedMarkets: SupportedPredictionMarkets.Baseball,
                    ),
                  )
                  ..add(const BaseballPredictionMarketsRequested());
              },
              child: Text(
                'Baseball',
                style: textSwapState(
                  condition:
                      _selectedMarket == SupportedPredictionMarkets.Baseball,
                  tabNotSelected: textStyle(
                    Colors.white,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: false,
                  ),
                  tabSelected: textStyle(
                    Colors.amber[400]!,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: true,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                marketsSearchController.clear();
                bloc
                  ..add(
                    const SelectedPredictionMarketsChanged(
                      selectedMarkets: SupportedPredictionMarkets.Soccer,
                    ),
                  )
                  ..add(const SoccerPredictionMarketsRequested());
              },
              child: Text(
                'Soccer',
                style: textSwapState(
                  condition:
                      _selectedMarket == SupportedPredictionMarkets.Soccer,
                  tabNotSelected: textStyle(
                    Colors.white,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: false,
                  ),
                  tabSelected: textStyle(
                    Colors.amber[400]!,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: true,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                marketsSearchController.clear();
                bloc
                  ..add(
                    const SelectedPredictionMarketsChanged(
                      selectedMarkets: SupportedPredictionMarkets.Voted,
                    ),
                  )
                  ..add(const VotedPredictionMarketsRequested());
              },
              child: Text(
                'Voted',
                style: textSwapState(
                  condition:
                      _selectedMarket == SupportedPredictionMarkets.Voted,
                  tabNotSelected: textStyle(
                    Colors.white,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: false,
                  ),
                  tabSelected: textStyle(
                    Colors.amber[400]!,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: true,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                marketsSearchController.clear();
                bloc
                  ..add(
                    const SelectedPredictionMarketsChanged(
                      selectedMarkets: SupportedPredictionMarkets.Exotic,
                    ),
                  )
                  ..add(const ExoticPredictionMarketsRequested());
              },
              child: Text(
                'Exotic',
                style: textSwapState(
                  condition:
                      _selectedMarket == SupportedPredictionMarkets.Exotic,
                  tabNotSelected: textStyle(
                    Colors.white,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: false,
                  ),
                  tabSelected: textStyle(
                    Colors.amber[400]!,
                    sportFilterTxSz,
                    isBold: false,
                    isUline: true,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
