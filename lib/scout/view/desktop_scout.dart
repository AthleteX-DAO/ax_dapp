// ignore_for_file: lines_longer_than_80_chars, avoid_positional_boolean_parameters

import 'package:ax_dapp/scout/bloc/scout_page_bloc.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/scout/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class DesktopScout extends StatefulWidget {
  const DesktopScout({
    super.key,
  });

  @override
  State<DesktopScout> createState() => _DesktopScoutState();
}

class _DesktopScoutState extends State<DesktopScout> {
  Global global = Global();
  final myController = TextEditingController(text: input);
  static String input = '';
  //bool athletePage = false;
  static bool isLongToken = true;
  static SupportedSport _selectedSport = SupportedSport.all;
  String allSportsTitle = 'All Sports';
  EthereumChain? _selectedChain;
  List<AthleteScoutModel> filteredAthletes = [];
  double minTeamWidth = 875;
  double minViewWidth = 1090;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
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
    // breaks the code, will come back to it later(probably)

    return global.buildPage(
      context,
      BlocBuilder<ScoutPageBloc, ScoutPageState>(
        buildWhen: (previous, current) {
          return current.status.name.isNotEmpty ||
              previous.selectedChain.chainId != current.selectedChain.chainId;
        },
        builder: (context, state) {
          final bloc = context.read<ScoutPageBloc>();
          global.athleteList = state.athletes;
          filteredAthletes = state.filteredAthletes;
          if (_selectedChain != state.selectedChain) {
            _selectedChain = state.selectedChain;
            bloc.add(
              FetchScoutInfoRequested(),
            );
          }
          _selectedSport = state.selectedSport;
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
                    // APT Title & Sport Filter
                    Container(
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
                            'APT List',
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
                              setState(
                                () {
                                  _selectedSport = SupportedSport.all;
                                },
                              );
                              context.read<ScoutPageBloc>().add(
                                    const SelectedSportChanged(
                                      selectedSport: SupportedSport.all,
                                    ),
                                  );
                            },
                            child: Text(
                              'ALL',
                              style: textSwapState(
                                condition: _selectedSport == SupportedSport.all,
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
                              setState(
                                () {
                                  _selectedSport = SupportedSport.MLB;
                                },
                              );
                              bloc.add(
                                const SelectedSportChanged(
                                  selectedSport: SupportedSport.MLB,
                                ),
                              );
                            },
                            child: Text(
                              'MLB',
                              style: textSwapState(
                                condition: _selectedSport == SupportedSport.MLB,
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
                              setState(
                                () {
                                  _selectedSport = SupportedSport.NFL;
                                },
                              );
                              bloc.add(
                                const SelectedSportChanged(
                                  selectedSport: SupportedSport.NFL,
                                ),
                              );
                            },
                            child: Text(
                              'NFL',
                              style: textSwapState(
                                condition: _selectedSport == SupportedSport.NFL,
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
                              setState(
                                () {
                                  _selectedSport = SupportedSport.NBA;
                                },
                              );
                              bloc.add(
                                const SelectedSportChanged(
                                  selectedSport: SupportedSport.NBA,
                                ),
                              );
                            },
                            child: Text(
                              'NBA',
                              style: textSwapState(
                                condition: _selectedSport == SupportedSport.NBA,
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
                          // long/short toggle
                          Container(
                            width: 250,
                            height: 30,
                            decoration: boxDecoration(
                              Colors.grey[900]!,
                              100,
                              1,
                              Colors.grey[400]!,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: 115,
                                  height: 20,
                                  decoration: isLongToken
                                      ? boxDecoration(
                                          Colors.grey[600]!,
                                          100,
                                          0,
                                          Colors.transparent,
                                        )
                                      : boxDecoration(
                                          Colors.transparent,
                                          100,
                                          0,
                                          Colors.transparent,
                                        ),
                                  child: TextButton(
                                    onPressed: () {
                                      if (!isLongToken) {
                                        setState(
                                          () {
                                            isLongToken = true;
                                          },
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Long Token',
                                      style: textStyle(
                                        Colors.white,
                                        14,
                                        isBold: true,
                                        isUline: false,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 115,
                                  height: 20,
                                  decoration: isLongToken
                                      ? boxDecoration(
                                          Colors.transparent,
                                          100,
                                          0,
                                          Colors.transparent,
                                        )
                                      : boxDecoration(
                                          Colors.grey[600]!,
                                          100,
                                          0,
                                          Colors.transparent,
                                        ),
                                  child: TextButton(
                                    onPressed: () {
                                      if (isLongToken) {
                                        setState(
                                          () {
                                            isLongToken = false;
                                          },
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Short Token',
                                      style: textStyle(
                                        Colors.white,
                                        14,
                                        isBold: true,
                                        isUline: false,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(width: 10),
                          // Search Bar
                          Container(
                            width: (constraints.maxWidth > 800)
                                ? constraints.maxWidth * 0.26
                                : constraints.maxWidth - 610,
                            height: 160,
                            decoration: boxDecoration(
                              const Color.fromRGBO(118, 118, 128, 0.24),
                              20,
                              1,
                              const Color.fromRGBO(118, 118, 128, 0.24),
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(width: 6),
                                const Icon(
                                  Icons.search,
                                  color: Color.fromRGBO(235, 235, 245, 0.6),
                                  size: 20,
                                ),
                                Container(width: 35),
                                Expanded(
                                  child: TextFormField(
                                    controller: myController,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          input = value;
                                        },
                                      );
                                      bloc.add(
                                        AthleteSearchChanged(
                                          searchedName: value,
                                          selectedSport: _selectedSport,
                                        ),
                                      );
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(bottom: 8.5),
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
                        ],
                      ),
                    ),
                    // List Headers
                    // BuildListViewHeader
                    DesktopHeaders(
                      minTeamWidth: minTeamWidth,
                      minViewWidth: minViewWidth,
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
                        SizedBox(
                          height: constraints.maxHeight * 0.8 - 120,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 10),
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredAthletes.length,
                            itemBuilder: (context, index) {
                              return DesktopAthlete(
                                athlete: filteredAthletes[index],
                                isLongToken: isLongToken,
                                minTeamWidth: minTeamWidth,
                                minViewWidth: minViewWidth,
                              );
                            },
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
      ),
    );
  }
}
