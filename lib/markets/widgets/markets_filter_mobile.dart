import 'package:ax_dapp/markets/bloc/markets_page_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class MarketsFilterMobile extends StatefulWidget {
  const MarketsFilterMobile({
    super.key,
    required BoxConstraints boxConstraints,
  }) : constraints = boxConstraints;

  final BoxConstraints constraints;

  @override
  State<MarketsFilterMobile> createState() => _MarketsFilterMobileState();
}

class _MarketsFilterMobileState extends State<MarketsFilterMobile> {
  final marketsSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MarketsPageBloc>();
    const sportFilterTxSz = 14.0;
    final _selectedMarket =
        context.read<MarketsPageBloc>().state.selectedMarket;

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
        TextButton(
          onPressed: () {
            marketsSearchController.clear();
            context.read<MarketsPageBloc>().add(
                  const SelectedMarketsChanged(
                    selectedMarkets: SupportedMarkets.all,
                  ),
                );
          },
          child: Text(
            'ALL',
            style: textSwapState(
              condition: _selectedMarket == SupportedMarkets.all,
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
                const SelectedMarketsChanged(
                  selectedMarkets: SupportedMarkets.Athlete,
                ),
              )
              ..add(FetchScoutInfoRequested());
          },
          child: Text(
            'Athlete',
            style: textSwapState(
              condition: _selectedMarket == SupportedMarkets.Athlete,
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
    );
  }

  @override
  void dispose() {
    marketsSearchController.dispose();
    super.dispose();
  }
}
