import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class PredictionMarketsFilterMobile extends StatefulWidget {
  const PredictionMarketsFilterMobile({super.key});

  @override
  State<PredictionMarketsFilterMobile> createState() => _PredictionMarketsFilterMobileState();
}

class _PredictionMarketsFilterMobileState extends State<PredictionMarketsFilterMobile> {
    final marketsSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PredictionPageBloc>();
    final _selectedMarket = context.read<PredictionPageBloc>().state.selectedMarket;
    return Container(
      height: 40,
      child: Row(
        children: [
                    Text(
            'Live Markets',
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
                  const SupportedPredictionMarkets(
                    selectedMarkets: SupportedPredictionMarkets.College,
                  ),
                )
                ..add(FetchScoutInfoRequested());
            },
            child: Text(
              'College',
              style: textSwapState(
                condition: _selectedMarket == SupportedPredictionMarkets.College,
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
                  const SupportedPredictionMarkets(
                    selectedMarkets: SupportedPredictionMarkets.Basketball,
                  ),
                )
                ..add(FetchScoutInfoRequested());
            },
            child: Text(
              'Basketball',
              style: textSwapState(
                condition: _selectedMarket == SupportedPredictionMarkets.Basketball,
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
                  const SupportedPredictionMarkets(
                    selectedMarkets: SupportedPredictionMarkets.Football,
                  ),
                )
                ..add(FetchScoutInfoRequested());
            },
            child: Text(
              'Football',
              style: textSwapState(
                condition: _selectedMarket == SupportedPredictionMarkets.Football,
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
                  const SupportedPredictionMarkets(
                    selectedMarkets: SupportedPredictionMarkets.Hockey,
                  ),
                )
                ..add(FetchScoutInfoRequested());
            },
            child: Text(
              'Hockey',
              style: textSwapState(
                condition: _selectedMarket == SupportedPredictionMarkets.Hockey,
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
                  const SupportedPredictionMarkets(
                    selectedMarkets: SupportedPredictionMarkets.Baseball,
                  ),
                )
                ..add(FetchScoutInfoRequested());
            },
            child: Text(
              'Baseball',
              style: textSwapState(
                condition: _selectedMarket == SupportedPredictionMarkets.Baseball,
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
                  const SupportedPredictionMarkets(
                    selectedMarkets: SupportedPredictionMarkets.Soccer,
                  ),
                )
                ..add(FetchScoutInfoRequested());
            },
            child: Text(
              'Soccer',
              style: textSwapState(
                condition: _selectedMarket == SupportedPredictionMarkets.Soccer,
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
                  const SupportedPredictionMarkets(
                    selectedMarkets: SupportedPredictionMarkets.Exotic,
                  ),
                )
                ..add(FetchScoutInfoRequested());
            },
            child: Text(
              'Exotic',
              style: textSwapState(
                condition: _selectedMarket == SupportedPredictionMarkets.Exotic,
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
      )
    );
  }
}