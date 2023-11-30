import 'package:ax_dapp/athlete_markets/athlete.dart';
import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/markets/widgets/desktop_headers.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:ax_dapp/sports_markets/view/sports_markets.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class DesktopMarkets extends StatefulWidget {
  const DesktopMarkets({
    super.key,
  });

  static bool isLongToken = true;

  @override
  State<DesktopMarkets> createState() => _DesktopMarketsState();
}

class _DesktopMarketsState extends State<DesktopMarkets> {
  Global global = Global();
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
        global
          ..athleteList = state.athletes
          ..liveSportsMarkets = state.liveSports;
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
                  MarketsFilterDesktop(
                    boxConstraints: constraints,
                  ),
                  if (state.status == BlocStatus.success &&
                      state.selectedMarket == SupportedMarkets.Athlete)
                    const DesktopHeaders(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (state.status == BlocStatus.loading) const Loader(),
                      if (state.status == BlocStatus.error)
                        const ScoutLoadingError(),
                      if (state.status == BlocStatus.noData)
                        const FilterMenuError(),
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket == SupportedMarkets.All)
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
                      if (state.status == BlocStatus.success &&
                          state.selectedMarket == SupportedMarkets.Athlete)
                        AthleteMarkets(
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
                        CryptoMarkets(
                          filteredMarkets: const [],
                          boxConstraints: constraints,
                        ),
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
