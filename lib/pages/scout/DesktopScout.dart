import 'package:ax_dapp/dialogs/buy/BuyDialog.dart';
import 'package:ax_dapp/dialogs/buy/bloc/BuyDialogBloc.dart';
import 'package:ax_dapp/pages/athlete/bloc/AthletePageBloc.dart';
import 'package:ax_dapp/pages/scout/Widget%20Factories/AthleteDetailsWidget.dart';
import 'package:ax_dapp/pages/scout/components/filter_menu_error.dart';
import 'package:ax_dapp/pages/scout/components/scout_loading.dart';
import 'package:ax_dapp/pages/scout/components/scout_loading_error.dart';
import 'package:ax_dapp/pages/scout/dialogs/misc.dart';
import 'package:ax_dapp/repositories/MlbRepo.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/GetBuyInfoUseCase.dart';
import 'package:ax_dapp/pages/athlete/AthletePage.dart';
import 'package:ax_dapp/pages/scout/bloc/ScoutPageBloc.dart';
import 'package:ax_dapp/pages/scout/models/ScoutPageEvent.dart';
import 'package:ax_dapp/pages/scout/models/ScoutPageState.dart';
import 'package:ax_dapp/service/Controller/usecases/GetMaxTokenInputUseCase.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/util/PercentHelper.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import 'models/AthleteScoutModel.dart';

class DesktopScout extends StatefulWidget {
  final void Function() goToTradePage;

  const DesktopScout({
    required this.goToTradePage,
    Key? key,
  }) : super(key: key);

  @override
  _DesktopScoutState createState() => _DesktopScoutState();
}

class _DesktopScoutState extends State<DesktopScout> {
  final myController = TextEditingController(text: input);
  static String input = "";
  bool athletePage = false;
  static bool isLongToken = true;
  static int sportState = 0;
  static SupportedSport supportedSport = SupportedSport.ALL;
  String allSportsTitle = "All Sports";
  String longTitle = "Long";
  AthleteScoutModel? curAthlete;
  int _widgetIndex = 0;
  int _marketVsBookPriceIndex = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    input = "";
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sportFilterTxSz = 14;
    double sportFilterIconSz = 14;
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    // breaks the code, will come back to it later(probably)

    return BlocBuilder<ScoutPageBloc, ScoutPageState>(
        buildWhen: (previous, current) => current.status.name.isNotEmpty,
        builder: (context, state) {
          final bloc = context.read<ScoutPageBloc>();
          final filteredAthletes = state.filteredAthletes;
          if (state.status == BlocStatus.initial) {
            bloc.add(OnPageRefresh());
          }
          if (athletePage && curAthlete != null)
            return BlocProvider(
              create: (context) => AthletePageBloc(
                  repo: RepositoryProvider.of<MLBRepo>(context)),
              child: AthletePage(
                athlete: curAthlete!, goToTradePage: widget.goToTradePage
              ),
            );
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
                margin: EdgeInsets.only(top: 20),
                height: _height * 0.85 + 41,
                width: _width * 0.99,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      // APT Title & Sport Filter
                      Container(
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        width: _width * 1,
                        height: 40,
                        child: kIsWeb
                            ? buildFilterMenuWeb(
                                state, bloc, sportFilterTxSz, _width)
                            : buildFilterMenu(state, bloc, sportFilterTxSz,
                                sportFilterIconSz),
                      ),
                      // List Headers
                      buildListviewHeaders(),
                      buildScoutView(state, filteredAthletes),
                    ])),
          );
        });
  }

  Stack buildScoutView(ScoutPageState state, List<AthleteScoutModel> filteredAthletes) {
    return Stack(                     
      alignment: Alignment.center,
      children: [
        if (state.status == BlocStatus.loading) ScoutLoading(),
        if (state.status == BlocStatus.error) ScoutLoadingError(),
        if (state.status == BlocStatus.no_data) FilterMenuError(),
        buildListview(state, filteredAthletes)
      ],                      
    );
  }

  Row buildFilterMenuWeb(ScoutPageState state, ScoutPageBloc bloc,
      double sportFilterTxSz, double _width) {
    return Row(children: [
      Text("APT List", style: textStyle(Colors.white, 18, false, false)),
      Text("|", style: textStyle(Colors.white, 18, false, false)),
      Container(
          child: TextButton(
        onPressed: () {
          myController.clear();
          setState(() {
            supportedSport = SupportedSport.ALL;
          });
          bloc.add(SelectSport(selectedSport: SupportedSport.ALL));
        },
        child: Text("ALL",
            style: textSwapState(
                supportedSport == SupportedSport.ALL,
                textStyle(Colors.white, sportFilterTxSz, false, false),
                textStyle(Colors.amber[400]!, sportFilterTxSz, false, true))),
      )),
      Container(
          child: TextButton(
        onPressed: () {
          myController.clear();
          setState(() {
            supportedSport = SupportedSport.MLB;
          });
          bloc.add(SelectSport(selectedSport: SupportedSport.MLB));
        },
        child: Text("MLB",
            style: textSwapState(
                supportedSport == SupportedSport.MLB,
                textStyle(Colors.white, sportFilterTxSz, false, false),
                textStyle(Colors.amber[400]!, sportFilterTxSz, false, true))),
      )),
      Spacer(),
      toggleTokenButton(800, 40),
      Container(width: 10),
      Container(
        child: createSearchBar(bloc, supportedSport),
      ),
    ]);
  }

  IndexedStack buildFilterMenu(ScoutPageState state, ScoutPageBloc bloc,
      double sportFilterTxSz, double sportFilterIconSz) {
    return IndexedStack(
      index: _widgetIndex,
      children: [
        Container(
          height: 20,
          child: Row(children: [
            Text("APT List", style: textStyle(Colors.white, 18, false, false)),
            Text("|", style: textStyle(Colors.white, 18, false, false)),
            SizedBox(
              child: PopupMenuButton(
                child: Row(
                  children: [
                    Text(
                      allSportsTitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Colors.grey,
                    )
                  ],
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("All Sports",
                              style: textSwapState(
                                  sportState == 0,
                                  textStyle(Colors.white, sportFilterTxSz,
                                      false, false),
                                  textStyle(Colors.amber[400]!, sportFilterTxSz,
                                      false, true))),
                        ],
                      ),
                    ),
                    onTap: () {
                      myController.clear();
                      if (sportState != 0)
                        setState(() {
                          sportState = 0;
                        });
                      allSportsTitle = "All Sports";
                    },
                  ),
                  PopupMenuItem(
                    height: 5,
                    value: 1,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.sports_football,
                                size: sportFilterIconSz,
                              )),
                          Text("MLB",
                              style: textSwapState(
                                  sportState == 1,
                                  textStyle(Colors.white, sportFilterTxSz,
                                      false, false),
                                  textStyle(Colors.amber[400]!, sportFilterTxSz,
                                      false, true))),
                        ],
                      ),
                    ),
                    onTap: () {
                      myController.clear();
                      if (sportState != 1)
                        setState(() {
                          sportState = 1;
                          allSportsTitle = "MLB";
                        });
                    },
                  ),
                ],
                offset: Offset(0, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            PopupMenuButton(
              child: Row(
                children: [
                  Text(
                    longTitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.grey,
                  )
                ],
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Long"),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      longTitle = "Long";
                    });
                  },
                ),
                PopupMenuItem(
                  height: 5,
                  value: 1,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Short"),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      longTitle = "Short";
                    });
                  },
                ),
              ],
              offset: Offset(0, 45),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            Spacer(),
            Center(
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        _widgetIndex = 1;
                      });
                    },
                    icon: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    )),
              ),
            ),
          ]),
        ),
        Container(
            height: 40,
            child: Row(
              children: [
                Container(
                  child: Expanded(
                    child: Row(
                      children: [
                        createSearchBar(bloc, supportedSport),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      _widgetIndex = 0;
                    });
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Color.fromRGBO(254, 197, 0, 1), fontSize: 17),
                  ),
                )
              ],
            ))
      ],
    );
  }

  Widget buildListviewHeaders() {
    double _width = MediaQuery.of(context).size.width;

    bool team = true;
    if (_width < 684) team = false;

    double athNameBx = _width * 0.15;
    if (_width < 685) athNameBx = 107;

    return Container(
      child: kIsWeb
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  Container(width: 66),
                  Container(
                      width: athNameBx,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Athlete (Seasonal APT)",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      )),
                  if (team)
                    Container(
                        width: _width * 0.12,
                        child: Text("Team",
                            style: textStyle(
                                Colors.grey[400]!, 12, false, false))),
                  Container(
                    width: _width * 0.18,
                    child: Text(
                      "Market Price / Change",
                      style: textStyle(Colors.grey[400]!, 10, false, false),
                    ),
                  ),
                  Container(
                    width: _width * 0.12,
                    child: Text("Book Value / Change",
                        style: textStyle(Colors.grey[400]!, 10, false, false)),
                  ),
                ])
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  Container(width: 66),
                  Container(
                      width: athNameBx,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Athlete",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      )),
                  if (team)
                    Container(
                        width: _width * 0.15,
                        child: Text("Team",
                            style: textStyle(
                                Colors.grey[400]!, 12, false, false))),
                  IndexedStack(
                    index: _marketVsBookPriceIndex,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            _marketVsBookPriceIndex = 1;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Market Price",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                  textAlign: TextAlign.justify,
                                )),
                            Container(
                                margin: EdgeInsets.only(left: 2),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.autorenew,
                                      size: 10,
                                      color: Colors.grey,
                                    )))
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            _marketVsBookPriceIndex = 0;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Book Value",
                                style: textStyle(
                                    Colors.grey[400]!, 10, false, false)),
                            Container(
                                margin: EdgeInsets.only(left: 2),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.autorenew,
                                      size: 10,
                                      color: Colors.grey,
                                    )))
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
    );
  }

  Widget buildListview(ScoutPageState state, filteredAthletes) {
    double _height = MediaQuery.of(context).size.height;
    double hgt = _height * 0.8 - 120;
    return Container(
        height: hgt,
        child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemCount: filteredAthletes.length,
            itemBuilder: (context, index) {
              return kIsWeb
                  ? createListCardsForWeb(filteredAthletes[index])
                  : createListCardsForMobile(filteredAthletes[index]);
            }));
  }

  // Athlete Cards
  Widget createListCardsForMobile(AthleteScoutModel athlete) {
    double _width = MediaQuery.of(context).size.width;
    bool view = true;
    bool team = true;
    if (_width < 910) view = false;
    if (_width < 689) team = false;
    double athNameBx = _width * 0.15;
    if (_width < 685) athNameBx = 107;

    return Container(
        height: 70,
        child: OutlinedButton(
            onPressed: () {
              setState(() {
                curAthlete = athlete;
                athletePage = true;
              });
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    AthleteDetailsWidget(athlete)
                        .athleteDetailsCardsForMobile(team, _width, athNameBx),
                    // Market Price / Change
                    IndexedStack(
                      index: _marketVsBookPriceIndex,
                      children: [
                        Container(
                            child: Row(
                          children: <Widget>[
                            Text(
                                isLongToken
                                    ? athlete.longTokenPrice!
                                            .toStringAsFixed(4) +
                                        ' AX'
                                    : athlete.shortTokenPrice!
                                            .toStringAsFixed(4) +
                                        ' AX',
                                style:
                                    textStyle(Colors.white, 16, false, false)),
                            Container(width: 10),
                            Text(
                                isLongToken
                                    ? getPercentageDesc(
                                        athlete.longTokenPercentage!)
                                    : getPercentageDesc(
                                        athlete.shortTokenPercentage!),
                                style: isLongToken
                                    ? textStyle(
                                        getPercentageColor(
                                            athlete.longTokenPercentage!),
                                        12,
                                        false,
                                        false)
                                    : textStyle(
                                        getPercentageColor(
                                            athlete.shortTokenPercentage!),
                                        12,
                                        false,
                                        false)),
                          ],
                        )),
                        Container(
                            child: Column(
                          children: [
                            Row(children: <Widget>[
                              Text(
                                  isLongToken
                                      ? athlete.longTokenBookPrice!
                                              .toStringAsFixed(4) +
                                          ' AX'
                                      : athlete.shortTokenBookPrice!
                                              .toStringAsFixed(4) +
                                          ' AX',
                                  style: textStyle(
                                      Colors.white, 16, false, false)),
                              Container(width: 10),
                              Text("-2%",
                                  style:
                                      textStyle(Colors.red, 12, false, false))
                            ]),
                            Text(
                                isLongToken
                                    ? athlete.longTokenBookPriceUsd!
                                            .toStringAsFixed(4) +
                                        ' AX'
                                    : athlete.shortTokenPriceUsd!
                                            .toStringAsFixed(4) +
                                        ' AX',
                                style: textStyle(
                                    Colors.amberAccent, 14, false, false)),
                          ],
                        )),
                      ],
                    ),
                  ]),
                  Row(children: <Widget>[
                    // Buy
                    Container(
                        width: _width * 0.20,
                        height: 36,
                        decoration: boxDecoration(
                            Color.fromRGBO(254, 197, 0, 0.2),
                            100,
                            0,
                            Color.fromRGBO(254, 197, 0, 0.2)),
                        child: TextButton(
                            onPressed: () {
                              if (kIsWeb) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => BlocProvider(
                                        create: (BuildContext context) =>
                                            BuyDialogBloc(
                                                repo: RepositoryProvider.of<
                                                    GetBuyInfoUseCase>(context),
                                                wallet:
                                                    GetTotalTokenBalanceUseCase(
                                                        Get.find()),
                                                swapController: Get.find()),
                                        child: BuyDialog(
                                            athlete.name,
                                            athlete.longTokenBookPrice!,
                                            athlete.id,
                                            widget.goToTradePage)));
                              } else {
                                setState(() {
                                  curAthlete = athlete;
                                  athletePage = true;
                                });
                              }
                            },
                            child: Center(
                              child: buyText(),
                            ))),
                    if (view) ...[
                      Container(width: 25),
                      // Mint
                      Container(
                          width: 100,
                          height: 30,
                          decoration: boxDecoration(
                              Colors.transparent, 100, 2, Colors.white),
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  curAthlete = athlete;
                                  athletePage = true;
                                });
                              },
                              child: Container(
                                  width: 60,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text("View",
                                          style: textStyle(
                                              Colors.white, 16, false, false)),
                                      Icon(Icons.arrow_right,
                                          size: 25, color: Colors.white)
                                    ],
                                  ))))
                    ]
                  ])
                ])));
  }

  Widget createListCardsForWeb(AthleteScoutModel athlete) {
    double _width = MediaQuery.of(context).size.width;

    bool view = true;
    bool team = true;
    if (_width < 910) view = false;
    if (_width < 689) team = false;
    double athNameBx = _width * 0.15;
    if (_width < 685) athNameBx = 107;

    return Container(
        height: 70,
        child: OutlinedButton(
            onPressed: () {
              setState(() {
                curAthlete = athlete;
                athletePage = true;
              });
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      AthleteDetailsWidget(athlete)
                          .athleteDetailsCardsForWeb(team, _width, athNameBx),
                      // Market Price / Change
                      Container(
                        width: _width * 0.18,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: <Widget>[
                                Text(
                                    isLongToken
                                        ? athlete.longTokenPrice!
                                                .toStringAsFixed(4) +
                                            ' AX'
                                        : athlete.shortTokenPrice!
                                                .toStringAsFixed(4) +
                                            ' AX',
                                    style: textStyle(
                                        Colors.white, 16, false, false)),
                                Container(width: 10),
                                Text(
                                    isLongToken
                                        ? getPercentageDesc(
                                            athlete.longTokenPercentage!)
                                        : getPercentageDesc(
                                            athlete.shortTokenPercentage!),
                                    style: isLongToken
                                        ? textStyle(
                                            getPercentageColor(
                                                athlete.longTokenPercentage!),
                                            12,
                                            false,
                                            false)
                                        : textStyle(
                                            getPercentageColor(
                                                athlete.shortTokenPercentage!),
                                            12,
                                            false,
                                            false)),
                              ],
                            ),
                            Text(
                              isLongToken
                                  ? '\$' +
                                      athlete.longTokenPriceUsd!
                                          .toStringAsFixed(4)
                                  : '\$' +
                                      athlete.shortTokenPriceUsd!
                                          .toStringAsFixed(4),
                              style: textStyle(
                                  Colors.amberAccent, 14, false, false),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: <Widget>[
                              Text(
                                  isLongToken
                                      ? athlete.longTokenBookPrice!
                                              .toStringAsFixed(4) +
                                          ' AX'
                                      : athlete.shortTokenBookPrice!
                                              .toStringAsFixed(4) +
                                          'AX',
                                  style: textStyle(
                                      Colors.white, 16, false, false)),
                              Container(width: 10),
                              Text("-2%",
                                  style:
                                      textStyle(Colors.red, 12, false, false)),
                            ]),
                            Text(
                                isLongToken
                                    ? '\$' +
                                        athlete.longTokenBookPriceUsd!
                                            .toStringAsFixed(4)
                                    : '\$' +
                                        athlete.shortTokenBookPriceUsd!
                                            .toStringAsFixed(4),
                                style: textStyle(
                                    Colors.amberAccent, 14, false, false)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(children: <Widget>[
                    // Buy
                    Container(
                        width: _width * 0.20,
                        height: 36,
                        decoration: boxDecoration(
                            Color.fromRGBO(254, 197, 0, 0.2),
                            100,
                            0,
                            Color.fromRGBO(254, 197, 0, 0.2)),
                        child: TextButton(
                            onPressed: () {
                              if (kIsWeb) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => BlocProvider(
                                        create: (BuildContext context) =>
                                            BuyDialogBloc(
                                                repo: RepositoryProvider.of<
                                                    GetBuyInfoUseCase>(context),
                                                wallet:
                                                    GetTotalTokenBalanceUseCase(
                                                        Get.find()),
                                                swapController: Get.find()),
                                        child: BuyDialog(
                                            athlete.name,
                                            athlete.longTokenBookPrice!,
                                            athlete.id,
                                            widget.goToTradePage)));
                              } else {
                                setState(() {
                                  curAthlete = athlete;
                                  athletePage = true;
                                });
                              }
                            },
                            child: Center(
                              child: buyText(),
                            ))),
                    if (view) ...[
                      Container(width: 25),
                      // Mint
                      Container(
                          width: 100,
                          height: 30,
                          decoration: boxDecoration(
                              Colors.transparent, 100, 2, Colors.white),
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  curAthlete = athlete;
                                  athletePage = true;
                                });
                              },
                              child: Container(
                                  width: 60,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text("View",
                                          style: textStyle(
                                              Colors.white, 16, false, false)),
                                      Icon(Icons.arrow_right,
                                          size: 25, color: Colors.white)
                                    ],
                                  ))))
                    ]
                  ])
                ])));
  }

  Widget buyText() {
    Widget textWidget;
    if (kIsWeb) {
      textWidget = Text("Buy",
          style: textStyle(Color.fromRGBO(254, 197, 0, 1.0), 12, false, false));
    } else {
      textWidget = Text("View",
          style: textStyle(Color.fromRGBO(255, 198, 0, 1), 10, false, false));
    }
    return textWidget;
  }

  Widget createSearchBar(ScoutPageBloc bloc, SupportedSport selectedSport) {
    double widthSize = MediaQuery.of(context).size.width;
    return Container(
      width: searchWidth(widthSize),
      height: 160,
      decoration: boxDecoration(Color.fromRGBO(118, 118, 128, 0.24), 20, 1,
          Color.fromRGBO(118, 118, 128, 0.24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(width: 6),
          Container(
            child: Icon(
              Icons.search,
              color: Color.fromRGBO(235, 235, 245, 0.6),
              size: 20,
            ),
          ),
          Container(width: 35),
          Expanded(
            child: Container(
              child: TextFormField(
                controller: myController,
                onChanged: (value) {
                  setState(() {
                    input = value;
                  });
                  bloc.add(OnAthleteSearch(
                      searchedName: value, selectedSport: selectedSport));
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 8.5),
                  hintText: "Search an athlete",
                  hintStyle:
                      TextStyle(color: Color.fromRGBO(235, 235, 245, 0.6)),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-z. ]'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double searchWidth(double widthSize) {
    double _width;
    if (kIsWeb) {
      _width = widthSize * 0.26;
    } else {
      _width = widthSize * 0.66;
    }
    return _width;
  }

  TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold) if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: FontWeight.w400,
      );
    else if (isUline)
      return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline);
    else
      return TextStyle(
        color: color,
        fontFamily: 'OpenSans',
        fontSize: size,
      );
  }

  TextStyle textSwapState(bool condition, TextStyle fls, TextStyle tru) {
    if (condition) return tru;
    return fls;
  }

  BoxDecoration boxDecoration(
      Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
        color: col,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: borCol, width: borWid));
  }

  Container toggleTokenButton(double layoutWdt, double layoutHgt) {
    return Container(
      width: kIsWeb ? 250 : layoutWdt,
      height: 30,
      decoration: boxDecoration(Colors.grey[900]!, 100, 1, Colors.grey[400]!),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: kIsWeb ? 115 : (layoutWdt / 2) - 5,
              height: 20,
              decoration: isLongToken
                  ? boxDecoration(Colors.grey[600]!, 100, 0, Colors.transparent)
                  : boxDecoration(
                      Colors.transparent, 100, 0, Colors.transparent),
              child: TextButton(
                  onPressed: () {
                    if (!isLongToken) {
                      setState(() {
                        isLongToken = true;
                      });
                    }
                  },
                  child: Text("Long Token",
                      style: textStyle(Colors.white, 14, true, false)))),
          Container(
              width: kIsWeb ? 115 : (layoutWdt / 2) - 5,
              height: 20,
              decoration: isLongToken
                  ? boxDecoration(
                      Colors.transparent, 100, 0, Colors.transparent)
                  : boxDecoration(
                      Colors.grey[600]!, 100, 0, Colors.transparent),
              child: TextButton(
                  onPressed: () {
                    if (isLongToken) {
                      setState(() {
                        isLongToken = false;
                      });
                    }
                  },
                  child: Text("Short Token",
                      style: textStyle(Colors.white, 14, true, false))))
        ],
      ),
    );
  }
}
