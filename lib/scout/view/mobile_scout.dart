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

class MobileScout extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const MobileScout({
    super.key,
  });

  @override
  State<MobileScout> createState() => _MobileScoutState();
}

class _MobileScoutState extends State<MobileScout> {
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
  List<AthleteScoutModel> filteredAthletes = [];

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
    const sportFilterIconSz = 14.0;
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
                                  // sport filter dropdown
                                  Container(
                                    alignment: Alignment.center,
                                    child: PopupMenuButton(
                                      // dropdown options
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            title: Align(
                                              child: Text(
                                                'All Sports',
                                                style: textSwapState(
                                                  condition: allSportsTitle ==
                                                      'All Sports',
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
                                          ),
                                          onTap: () {
                                            myController.clear();
                                            if (allSportsTitle !=
                                                'All Sports') {
                                              setState(
                                                () {
                                                  allSportsTitle = 'All Sports';
                                                  _selectedSport =
                                                      SupportedSport.all;
                                                  context
                                                      .read<ScoutPageBloc>()
                                                      .add(
                                                        const SelectedSportChanged(
                                                          selectedSport:
                                                              SupportedSport
                                                                  .all,
                                                        ),
                                                      );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                        PopupMenuItem(
                                          height: 5,
                                          value: 1,
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 8,
                                                  ),
                                                  child: const Icon(
                                                    Icons.sports_football,
                                                    size: sportFilterIconSz,
                                                  ),
                                                ),
                                                Text(
                                                  'MLB',
                                                  style: textSwapState(
                                                    condition:
                                                        allSportsTitle == 'MLB',
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
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            myController.clear();
                                            if (allSportsTitle != 'MLB') {
                                              myController.clear();
                                              setState(
                                                () {
                                                  allSportsTitle = 'MLB';
                                                  _selectedSport =
                                                      SupportedSport.MLB;
                                                },
                                              );
                                              context.read<ScoutPageBloc>().add(
                                                    const SelectedSportChanged(
                                                      selectedSport:
                                                          SupportedSport.MLB,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                        PopupMenuItem(
                                          height: 5,
                                          value: 2,
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 8,
                                                  ),
                                                  child: const Icon(
                                                    Icons.sports_football,
                                                    size: sportFilterIconSz,
                                                  ),
                                                ),
                                                Text(
                                                  'NFL',
                                                  style: textSwapState(
                                                    condition:
                                                        allSportsTitle == 'NFL',
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
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            myController.clear();
                                            if (allSportsTitle != 'NFL') {
                                              myController.clear();
                                              setState(
                                                () {
                                                  allSportsTitle = 'NFL';
                                                  _selectedSport =
                                                      SupportedSport.NFL;
                                                },
                                              );
                                              context.read<ScoutPageBloc>().add(
                                                    const SelectedSportChanged(
                                                      selectedSport:
                                                          SupportedSport.NFL,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                        PopupMenuItem(
                                          height: 5,
                                          value: 2,
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 8,
                                                  ),
                                                  child: const Icon(
                                                    Icons.sports_football,
                                                    size: sportFilterIconSz,
                                                  ),
                                                ),
                                                Text(
                                                  'NBA',
                                                  style: textSwapState(
                                                    condition:
                                                        allSportsTitle == 'NBA',
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
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            myController.clear();
                                            if (allSportsTitle != 'NBA') {
                                              myController.clear();
                                              setState(
                                                () {
                                                  allSportsTitle = 'NBA';
                                                  _selectedSport =
                                                      SupportedSport.NBA;
                                                },
                                              );
                                              context.read<ScoutPageBloc>().add(
                                                    const SelectedSportChanged(
                                                      selectedSport:
                                                          SupportedSport.NBA,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                      ],
                                      offset: const Offset(0, 45),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      // dropdown title
                                      child: Row(
                                        children: [
                                          Text(
                                            allSportsTitle,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontFamily: 'OpenSans',
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down_sharp,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Long/Short filter
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      // Long
                                      PopupMenuItem(
                                        value: 1,
                                        child: const ListTile(
                                          title: Align(
                                            child: Text('Long'),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(
                                            () {
                                              isLongToken = true;
                                            },
                                          );
                                        },
                                      ),
                                      // Short
                                      PopupMenuItem(
                                        height: 5,
                                        value: 1,
                                        child: const ListTile(
                                          title: Align(
                                            child: Text('Short'),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(
                                            () {
                                              isLongToken = false;
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                    offset: const Offset(0, 45),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    // dropdown title
                                    child: Row(
                                      children: [
                                        Text(
                                          isLongToken ? 'Long' : 'Short',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_drop_down_sharp,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
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
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    input = value;
                                                  },
                                                );
                                                context
                                                    .read<ScoutPageBloc>()
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
                                                FilteringTextInputFormatter
                                                    .allow(
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
                          if (state.status == BlocStatus.loading)
                            const Loader(),
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
                                return MobileAthleteContents(
                                  athlete: filteredAthletes[index],
                                  marketVsBookPriceIndex:
                                      _marketVsBookPriceIndex,
                                  isLongToken: isLongToken,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
