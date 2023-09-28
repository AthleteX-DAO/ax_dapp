import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/markets/widgets/search.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class MarketsFilter extends StatelessWidget {
  const MarketsFilter({super.key, required BoxConstraints boxConstraints})
      : constraints = boxConstraints;

  final BoxConstraints constraints;

  @override
  Container build(BuildContext context) {
    var input = '';
    final myController = TextEditingController(text: input);
    final bloc = context.read<MarketsPageBloc>();
    var _selectedMarkets = SupportedMarkets.all;
    var _selectedSport = SupportedSport.all;
    const sportFilterTxSz = 14.0;

    // APT Title & Sport Filter
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      height: 40,
      // Sport filter, long/short, search
      child: Row(
        children: [
          // Sport filter
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
              myController.clear();
              _selectedMarkets = SupportedMarkets.all;
              _selectedSport = SupportedSport.all;

              context.read<MarketsPageBloc>().add(
                    const SelectedMarketsChanged(
                      selectedMarkets: SupportedMarkets.all,
                    ),
                  );
            },
            child: Text(
              'ALL',
              style: textSwapState(
                condition: _selectedMarkets == SupportedMarkets.all,
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
              myController.clear();
              _selectedMarkets = SupportedMarkets.Athlete;
              bloc.add(
                const SelectedMarketsChanged(
                  selectedMarkets: SupportedMarkets.Athlete,
                ),
              );
            },
            child: Text(
              'Athlete',
              style: textSwapState(
                condition: _selectedMarkets == SupportedMarkets.Athlete,
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
              myController.clear();
              _selectedMarkets = SupportedMarkets.Sports;
              bloc.add(
                const SelectedMarketsChanged(
                  selectedMarkets: SupportedMarkets.Sports,
                ),
              );
            },
            child: Text(
              'Sports',
              style: textSwapState(
                condition: _selectedMarkets == SupportedMarkets.Sports,
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
              myController.clear();
              _selectedMarkets = SupportedMarkets.Crypto;
              bloc.add(
                const SelectedMarketsChanged(
                  selectedMarkets: SupportedMarkets.Crypto,
                ),
              );
            },
            child: Text(
              'Crypto',
              style: textSwapState(
                condition: _selectedMarkets == SupportedMarkets.Crypto,
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
          Search(boxConstraints: constraints)
        ],
      ),
    );
  }
}