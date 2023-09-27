import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/markets/widgets/desktop_headers.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class DesktopMarkets extends StatelessWidget {
  DesktopMarkets({
    super.key,
  });

  Global global = Global();
  final myController = TextEditingController(text: input);
  static String input = '';
  static bool isLongToken = true;
  String allSportsTitle = 'All Sports';
  EthereumChain? _selectedChain;
  List<SportsMarketsModel> liveSports = [];
  List<AthleteScoutModel> filteredAthletes = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketsPageBloc, MarketsPageState>(
      buildWhen: (previous, current) {
        return current.status.name.isNotEmpty ||
            previous.selectedChain.chainId != current.selectedChain.chainId;
      },
      builder: (context, state) {
        final bloc = context.read<MarketsPageBloc>();
        global.athleteList = state.athletes;
        liveSports = state.liveSports;
        filteredAthletes = state.filteredAthletes;
        if (_selectedChain != state.selectedChain) {
          _selectedChain = state.selectedChain;
          bloc.add(
            FetchScoutInfoRequested(),
          );
        }
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              margin: const EdgeInsets.only(top: 20),
              height: constraints.maxHeight * 0.85 + 41,
              width: constraints.maxWidth * 0.99,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Divider(
                      color: Colors.grey,
                    ),
                  ),
                  MarketsFilter(boxConstraints: constraints),
                  //Cause-Effect of the Filters
                  const DesktopHeaders(),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (state.status == BlocStatus.loading) const Loader(),
                      if (state.status == BlocStatus.error)
                        const ScoutLoadingError(),
                      if (state.status == BlocStatus.noData)
                        FilterMenuError(
                          selectedChain: _selectedChain,
                        ),
                      if (state.status == BlocStatus.success &&
                          filteredAthletes.isEmpty)
                        const NoResultFound(),
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket == SupportedMarkets.Athlete)
                        AthleteMarkets(
                          filteredAthletes: filteredAthletes,
                          boxConstraints: constraints,
                        ),
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket == SupportedMarkets.Sports)
                        SportsMarkets(
                          sportsMarkets: liveSports,
                          boxConstraints: constraints,
                        ),
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket == SupportedMarkets.Crypto)
                        const Text('Crypto Markets coming soon!')
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
