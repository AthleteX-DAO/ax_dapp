import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketsFilterMobile extends StatefulWidget {
  const MarketsFilterMobile({
    super.key,
  });

  @override
  State<MarketsFilterMobile> createState() => _MarketsFilterMobileState();
}

class _MarketsFilterMobileState extends State<MarketsFilterMobile> {
  final marketsSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    const sportFilterTxSz = 14.0;
    return Row(
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
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: BlocSelector<MarketsPageBloc, MarketsPageState,
                SupportedMarkets>(
              selector: (state) => state.selectedMarket,
              builder: (context, market) {
                final _selectedMarket =
                    context.read<MarketsPageBloc>().state.selectedMarket;
                return DropdownButton<SupportedMarkets>(
                  dropdownColor: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1,
                  value: market,
                  items: SupportedMarkets.values
                      .map<DropdownMenuItem<SupportedMarkets>>(
                    (SupportedMarkets market) {
                      return DropdownMenuItem<SupportedMarkets>(
                        value: market,
                        child: Text(
                          market.convertToSportString(),
                          style: textSwapState(
                            condition: _selectedMarket == market,
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
                      );
                    },
                  ).toList(),
                  onChanged: (newMarket) {
                    marketsSearchController.clear();
                    context.read<MarketsPageBloc>().add(
                          SelectedMarketsChanged(
                            selectedMarkets: newMarket!,
                          ),
                        );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    marketsSearchController.dispose();
    super.dispose();
  }
}
