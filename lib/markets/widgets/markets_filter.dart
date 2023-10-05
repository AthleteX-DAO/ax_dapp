import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/markets/widgets/search.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class MarketsFilter extends StatelessWidget {
  const MarketsFilter({
    super.key,
    required BoxConstraints boxConstraints,
    required MarketsPageState pageState,
  })  : constraints = boxConstraints,
        state = pageState;

  final BoxConstraints constraints;
  final MarketsPageState state;

  Widget mobile() {
    return BlocConsumer<MarketsPageBloc, MarketsPageState>(
      builder: (context, state) {
        const sportFilterTxSz = 14.0;
        var bloc = context.read<MarketsPageBloc>();
        var input = '';
        final myController = TextEditingController(text: input);

        var _selectedMarkets = state.selectedMarket;
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
                _selectedMarkets = SupportedMarkets.all;

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
                bloc
                  ..add(
                    const SelectedMarketsChanged(
                      selectedMarkets: SupportedMarkets.Sports,
                    ),
                  )
                  ..add(
                    FetchSportsMarketsRequested(),
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
          ],
        );
      },
      listener: (context, state) {},
    );
  }

  @override
  Container build(BuildContext context) {
    var input = '';
    final myController = TextEditingController(text: input);
    final bloc = context.read<MarketsPageBloc>();
    var _selectedMarkets = state.selectedMarket;
    var _selectedSport = SupportedSport.all;
    const sportFilterTxSz = 14.0;

    // Sport Filter
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
          // TextButton(
          //   onPressed: () {
          //     myController.clear();
          //     _selectedMarkets = SupportedMarkets.all;
          //     _selectedSport = SupportedSport.all;

          //     context.read<MarketsPageBloc>().add(
          //           const SelectedMarketsChanged(
          //             selectedMarkets: SupportedMarkets.all,
          //           ),
          //         );
          //   },
          //   child: Text(
          //     'ALL',
          //     style: textSwapState(
          //       condition: _selectedMarkets == SupportedMarkets.all,
          //       tabNotSelected: textStyle(
          //         Colors.white,
          //         sportFilterTxSz,
          //         isBold: false,
          //         isUline: false,
          //       ),
          //       tabSelected: textStyle(
          //         Colors.amber[400]!,
          //         sportFilterTxSz,
          //         isBold: false,
          //         isUline: true,
          //       ),
          //     ),
          //   ),
          // ),
          TextButton(
            onPressed: () {
              myController.clear();
              _selectedMarkets = SupportedMarkets.Athlete;
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
              bloc
                ..add(
                  const SelectedMarketsChanged(
                    selectedMarkets: SupportedMarkets.Sports,
                  ),
                )
                ..add(
                  FetchSportsMarketsRequested(),
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
