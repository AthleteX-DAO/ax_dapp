import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/markets/widgets/search.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketsFilterDesktop extends StatefulWidget {
  const MarketsFilterDesktop({
    super.key,
    required BoxConstraints boxConstraints,
  }) : constraints = boxConstraints;

  final BoxConstraints constraints;

  @override
  State<MarketsFilterDesktop> createState() => _MarketsFilterDesktopState();
}

class _MarketsFilterDesktopState extends State<MarketsFilterDesktop> {
  final marketsSearchController = TextEditingController();
  @override
  Container build(BuildContext context) {
    final bloc = context.read<MarketsPageBloc>();
    const sportFilterTxSz = 14.0;
    final _selectedMarket =
        context.read<MarketsPageBloc>().state.selectedMarket;

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
          TextButton(
            onPressed: () {
              marketsSearchController.clear();
              bloc.add(
                const SelectedMarketsChanged(
                  selectedMarkets: SupportedMarkets.Crypto,
                ),
              );
            },
            child: Text(
              'Crypto',
              style: textSwapState(
                condition: _selectedMarket == SupportedMarkets.Crypto,
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
              bloc.add(
                const SelectedMarketsChanged(
                  selectedMarkets: SupportedMarkets.Sports,
                ),
              );
            },
            child: Text(
              'Sports',
              style: textSwapState(
                condition: _selectedMarket == SupportedMarkets.Sports,
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
          const Spacer(),
          Container(width: 10),
          Search(boxConstraints: widget.constraints),
        ],
      ),
    );
  }

  @override
  void dispose() {
    marketsSearchController.dispose();
    super.dispose();
  }
}
