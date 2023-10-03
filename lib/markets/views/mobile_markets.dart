import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/markets/modules/crypto_markets/crypto.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class MobileMarkets extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const MobileMarkets({
    super.key,
  });

  @override
  State<MobileMarkets> createState() => _MobileMarketsState();
}

class _MobileMarketsState extends State<MobileMarkets> {
  Global global = Global();
  final myController = TextEditingController(text: input);
  static String input = '';
  //bool athletePage = false;
  static bool isLongToken = true;
  static SupportedSport _selectedSport = SupportedSport.all;
  String allSportsTitle = 'All Sports';
  int _widgetIndex = 0;
  int _marketVsBookPriceIndex = 0;
  EthereumChain? _selectedChain;
  String selectedAthlete = '';
  List<SportsMarketsModel> liveSports = [];
  List<AthleteScoutModel> filteredAthletes = [];

  @override
  void dispose() {
    myController.dispose();
    input = '';
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const sportFilterTxSz = 14.0;
    const sportFilterIconSz = 14.0;

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
        filteredAthletes = state.filteredAthletes;
        liveSports = state.liveSports;
        if (_selectedChain != state.selectedChain) {
          _selectedChain = state.selectedChain;
          bloc
            ..add(
              FetchScoutInfoRequested(),
            )
            ..add(
              const SelectedMarketsChanged(
                selectedMarkets: SupportedMarkets.Sports,
              ),
            );
        }
        _selectedSport = state.selectedSport;

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
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
                    // APT Title & Sport Filter & search icon/bar
                    Container(
                      margin: EdgeInsets.only(
                        left: (constraints.maxWidth >= 300) ? 15 : 9,
                        right: (constraints.maxWidth >= 300) ? 15 : 9,
                        bottom: 10,
                      ),
                      height: 40,
                      // header with the dropdwons & search
                      child: IndexedStack(
                        index: _widgetIndex,
                        children: [
                          // text & filters
                          SizedBox(
                            height: 20,
                            child: Row(
                              children: [
                                MarketsFilter(
                                  boxConstraints: constraints,
                                  pageState: state,
                                ).mobile(),
                                const Spacer(),
                                // search icon
                                Center(
                                  child: Align(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            _widgetIndex = 1;
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.search,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // search bar & cancel
                          SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Expanded(
                                  // Search Bar
                                  child: Container(
                                    width: constraints.maxWidth - 110,
                                    height: 160,
                                    decoration: boxDecoration(
                                      const Color.fromRGBO(
                                        118,
                                        118,
                                        128,
                                        0.24,
                                      ),
                                      20,
                                      1,
                                      const Color.fromRGBO(
                                        118,
                                        118,
                                        128,
                                        0.24,
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(width: 6),
                                        const Icon(
                                          Icons.search,
                                          color: Color.fromRGBO(
                                            235,
                                            235,
                                            245,
                                            0.6,
                                          ),
                                          size: 20,
                                        ),
                                        Container(width: 35),
                                        Expanded(
                                          child: TextFormField(
                                            controller: myController,
                                            style: textStyle(
                                              Colors.grey[400]!,
                                              15,
                                              isBold: false,
                                              isUline: false,
                                            ),
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  input = value;
                                                },
                                              );
                                              context
                                                  .read<MarketsPageBloc>()
                                                  .add(
                                                    AthleteSearchChanged(
                                                      searchedName: value,
                                                      selectedSport:
                                                          _selectedSport,
                                                    ),
                                                  );
                                            },
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                bottom: 8.5,
                                              ),
                                              hintText: 'Search an athlete',
                                              hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                  235,
                                                  235,
                                                  245,
                                                  0.6,
                                                ),
                                                fontFamily: 'OpenSans',
                                              ),
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp('[a-zA-z. ]'),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // cancel serach button
                                MaterialButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        _widgetIndex = 0;
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color.fromRGBO(254, 197, 0, 1),
                                      fontSize: 17,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // List Headers
                    // BuildListViewHeader
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: (constraints.maxWidth > 290) ? 66 : 10,
                        ),
                        const SizedBox(
                          width: 107,
                          child: Text(
                            'Athlete',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IndexedStack(
                          index: _marketVsBookPriceIndex,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                setState(
                                  () {
                                    _marketVsBookPriceIndex = 1;
                                  },
                                );
                              },
                              child: const MobileMarketBookText(
                                title: 'Market Price',
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                setState(
                                  () {
                                    _marketVsBookPriceIndex = 0;
                                  },
                                );
                              },
                              child: const MobileMarketBookText(
                                title: 'Book Value',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //BuildScoutView body
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
                            state.selectedMarket == SupportedMarkets.Sports)
                          SportsMarkets(
                            sportsMarkets: liveSports,
                            boxConstraints: constraints,
                          ).sportsMobileMarkets(),
                        if (state.status == BlocStatus.success &&
                            state.selectedMarket == SupportedMarkets.Athlete)
                          AthleteMarkets(
                            filteredAthletes: filteredAthletes,
                            boxConstraints: constraints,
                          ).athleteMobileMarkets(),
                        // Default Structure
                        SizedBox(
                          height: constraints.maxHeight * 0.8 - 120,
                          child: const Center(
                            child: SizedBox(
                              height: 70,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
