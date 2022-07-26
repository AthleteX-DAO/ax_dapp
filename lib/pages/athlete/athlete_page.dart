import 'package:ax_dapp/pages/athlete/bloc/athlete_page_bloc.dart';
import 'package:ax_dapp/pages/athlete/components/athlete_page_tooltip.dart';
import 'package:ax_dapp/pages/athlete/components/build_long_chart.dart';
import 'package:ax_dapp/pages/athlete/components/build_short_chart.dart';
import 'package:ax_dapp/pages/athlete/components/buttons.dart';
import 'package:ax_dapp/pages/scout/desktop_scout.dart';
import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/pages/scout/widget_factories/athlete_details_widget.dart';
import 'package:ax_dapp/service/controller/create_wallet/web.dart';
import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/controller/wallet_controller.dart';
import 'package:ax_dapp/service/token_list.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/percent_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AthletePage extends StatefulWidget {
  const AthletePage({
    super.key,
    required this.athlete,
    required this.goToTradePage,
  });
  final AthleteScoutModel athlete;
  final void Function() goToTradePage;

  @override
  State<AthletePage> createState() => _AthletePageState();
}

class _AthletePageState extends State<AthletePage> {
  late AthleteScoutModel athlete;
  int listView = 0;

  int _widgetIndex = 0;
  int _longAptIndex = 0;
  Color indexUnselectedStackBackgroundColor = Colors.transparent;
  bool _isLongApt = true;
  bool _isDisplayingChart = true;
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _longToolTipBehavior;
  late TooltipBehavior _shortToolTipBehavior;
  bool _isPortraitMode = false;

  @override
  void initState() {
    super.initState();
    athlete = widget.athlete;
    Get.find<LSPController>().updateAptAddress(athlete.id);
    _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enablePanning: true,
      enablePinching: true,
    );
    _longToolTipBehavior = TooltipBehavior(enable: true);
    _shortToolTipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    final _mediaquery = MediaQuery.of(context);
    _isPortraitMode = _mediaquery.orientation == Orientation.portrait;
    if (listView == 1) return DesktopScout(goToTradePage: widget.goToTradePage);

    return kIsWeb
        ? BlocBuilder<AthletePageBloc, AthletePageState>(
            builder: (context, state) {
              final bloc = context.read<AthletePageBloc>();
              final chartStats = state.stats;
              if (state.status == BlocStatus.initial) {
                bloc.add(OnPageRefresh(playerId: athlete.id));
              }
              return buildWebView(athlete, chartStats);
            },
          )
        : buildMobileView(context);
  }

  IndexedStack buildWebViewContainer(BuildContext context) {
    final chartStats = <GraphData>[];
    return IndexedStack(
      index: _longAptIndex,
      children: [
        buildWebView(athlete, chartStats),
        buildWebView(athlete, chartStats)
      ],
    );
  }

  Widget buildWebView(AthleteScoutModel athlete, List<GraphData> chartStats) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    double _containerWdt, _containerHgt;

    // normal mode (dual)
    if (_width > 1160 && _height > 660) {
      _containerHgt = _height;
      _containerWdt = _width;
      return SizedBox(
        height: _containerHgt,
        width: _containerWdt,
        child: Center(
          child: SizedBox(
            width: _width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                graphSide(
                  context,
                  athlete.longTokenBookPrice!.toStringAsFixed(6),
                  athlete.shortTokenPrice!.toStringAsFixed(6),
                  athlete.longTokenPercentage!.toStringAsFixed(6),
                  athlete.shortTokenPercentage!.toStringAsFixed(6),
                  athlete.longTokenBookPrice!.toStringAsFixed(6),
                  athlete.shortTokenBookPrice!.toStringAsFixed(6),
                  athlete.longTokenPercentage!.toStringAsFixed(
                    6,
                  ),
                  // TODO(anyone): This percentage is for the market price, not
                  // book price. Change to book price change percentage when we
                  // have it.
                  athlete.shortTokenPercentage!.toStringAsFixed(6),
                  chartStats,
                  _containerHgt,
                  _containerWdt,
                ),
                statsSide(
                  context,
                  athlete.longTokenBookPrice!.toStringAsFixed(6),
                  athlete.shortTokenPrice!.toStringAsFixed(6),
                  athlete.longTokenPercentage!.toStringAsFixed(6),
                  athlete.shortTokenPercentage!.toStringAsFixed(6),
                  athlete.longTokenBookPrice!.toStringAsFixed(6),
                  athlete.shortTokenBookPrice!.toStringAsFixed(6),
                  athlete.longTokenPercentage!.toStringAsFixed(
                    6,
                  ),
                  // TODO(anyone): This percentage is for the market price, not
                  // book price. Change to book price change percentage when we
                  // have it.
                  athlete.shortTokenPercentage!.toStringAsFixed(6),
                )
              ],
            ),
          ),
        ),
      );
    }

    // dual scroll mode
    if (_width > 1160 && _height <= 660) {
      _containerHgt = _height * 0.95 - 57;
      _containerWdt = _width * 0.9;
      return SizedBox(
        height: _containerHgt,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: _containerWdt,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      graphSide(
                        context,
                        athlete.longTokenBookPrice!.toStringAsFixed(6),
                        athlete.shortTokenPrice!.toStringAsFixed(6),
                        athlete.longTokenPercentage!.toStringAsFixed(6),
                        athlete.shortTokenPercentage!.toStringAsFixed(6),
                        athlete.longTokenBookPrice!.toStringAsFixed(6),
                        athlete.shortTokenBookPrice!.toStringAsFixed(6),
                        athlete.longTokenPercentage!.toStringAsFixed(
                          6,
                        ),
                        // TODO(anyone): This percentage is for the market
                        // price, not book price. Change to book price change
                        // percentage when we have it.
                        athlete.shortTokenPercentage!.toStringAsFixed(6),
                        chartStats,
                        _containerHgt,
                        _containerWdt,
                      ),
                      statsSide(
                        context,
                        athlete.longTokenBookPrice!.toStringAsFixed(6),
                        athlete.shortTokenPrice!.toStringAsFixed(6),
                        athlete.longTokenPercentage!.toStringAsFixed(6),
                        athlete.shortTokenPercentage!.toStringAsFixed(6),
                        athlete.longTokenBookPrice!.toStringAsFixed(6),
                        athlete.shortTokenBookPrice!.toStringAsFixed(6),
                        athlete.longTokenPercentage!.toStringAsFixed(
                          6,
                        ),
                        // TODO(anyone): This percentage is for the market
                        // price, not book price. Change to book price change
                        // percentage when we have it.
                        athlete.shortTokenPercentage!.toStringAsFixed(6),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    // stacked scroll (portrait mode)
    _containerHgt = _height * 0.95 - 57;
    _containerWdt = _width * 0.95;
    return SizedBox(
      height: _containerHgt,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: _containerWdt,
              child: graphSide(
                context,
                athlete.longTokenBookPrice!.toStringAsFixed(6),
                athlete.shortTokenPrice!.toStringAsFixed(6),
                athlete.longTokenPercentage!.toStringAsFixed(6),
                athlete.shortTokenPercentage!.toStringAsFixed(6),
                athlete.longTokenBookPrice!.toStringAsFixed(6),
                athlete.shortTokenBookPrice!.toStringAsFixed(6),
                athlete.longTokenPercentage!.toStringAsFixed(
                  6,
                ),
                // TODO(anyone): This percentage is for the market price, not
                // book price. Change to book price change percentage when we
                // have it.
                athlete.shortTokenPercentage!.toStringAsFixed(6),
                chartStats,
                _containerHgt,
                _containerWdt,
              ),
            ),
            SizedBox(
              width: _containerWdt,
              child: statsSide(
                context,
                athlete.longTokenBookPrice!.toStringAsFixed(6),
                athlete.shortTokenPrice!.toStringAsFixed(6),
                athlete.longTokenPercentage!.toStringAsFixed(6),
                athlete.shortTokenPercentage!.toStringAsFixed(6),
                athlete.longTokenBookPrice!.toStringAsFixed(6),
                athlete.shortTokenBookPrice!.toStringAsFixed(6),
                athlete.longTokenPercentage!.toStringAsFixed(
                  6,
                ),
                // TODO(anyone): This percentage is for the market price, not
                // book price. Change to book price change percentage when we
                // have it.
                athlete.shortTokenPercentage!.toStringAsFixed(6),
              ),
            )
          ],
        ),
      ),
    );
  }

  SafeArea buildMobileView(BuildContext context) {
    const longMarketPrice = '4.18 AX';
    const longMarketPricePercent = '-2%';
    final longBookValue =
        '${athlete.longTokenBookPrice!.toStringAsFixed(2)} AX ';
    const longBookValuePercent = '+4%';

    const shortMarketPrice = '2.18 AX';
    const shortMarketPricePercent = '-1%';
    final shortBookValue =
        '${athlete.shortTokenBookPrice!.toStringAsFixed(2)} AX ';
    const shortBookValuePercent = '+2%';

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _buttonHeight = MediaQuery.of(context).size.height * 0.045;
    return SafeArea(
      child: IndexedStack(
        index: _longAptIndex,
        children: [
          buildPage(
            _width,
            _height,
            context,
            _buttonHeight,
            longMarketPrice,
            longMarketPricePercent,
            longBookValue,
            longBookValuePercent,
          ),
          buildPage(
            _width,
            _height,
            context,
            _buttonHeight,
            shortMarketPrice,
            shortMarketPricePercent,
            shortBookValue,
            shortBookValuePercent,
          ),
        ],
      ),
    );
  }

  Widget buildPage(
    double _width,
    double _height,
    BuildContext context,
    double _buttonHeight,
    String marketPrice,
    String marketPricePercent,
    String bookValue,
    String bookValuePercent,
  ) {
    return SizedBox(
      width: _width,
      child: Column(
        children: [
          Divider(
            color: secondaryGreyColor,
            thickness: 0.5,
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    listView = 1;
                  });
                },
                child:
                    const Icon(Icons.arrow_back, size: 24, color: Colors.white),
              ),
              // APT Icon
              Container(
                margin: const EdgeInsets.only(top: .5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      athlete.name,
                      style: textStyle(Colors.white, 20, false, false),
                    ),
                    Text(
                      'Seasonal APT',
                      style: textStyle(
                        const Color.fromRGBO(154, 154, 154, 1),
                        12,
                        false,
                        false,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.sports_baseball,
                size: 16,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(1.5),
                width: _width * .18,
                height: _height * .04,
                decoration: boxDecoration(
                  Colors.transparent,
                  10,
                  1,
                  secondaryGreyColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: boxDecoration(
                          _isLongApt
                              ? secondaryGreyColor
                              : indexUnselectedStackBackgroundColor,
                          8,
                          0,
                          Colors.transparent,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(15, 8),
                          ),
                          onPressed: () {
                            setState(() {
                              _longAptIndex = 0;
                              if (_longAptIndex == 0) {
                                _isLongApt = true;
                              }
                            });
                          },
                          child: Text(
                            'Long',
                            style: TextStyle(
                              color: _isLongApt
                                  ? primaryWhiteColor
                                  : const Color.fromRGBO(154, 154, 154, 1),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DecoratedBox(
                        decoration: boxDecoration(
                          _isLongApt
                              ? indexUnselectedStackBackgroundColor
                              : secondaryGreyColor,
                          8,
                          0,
                          Colors.transparent,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                          ),
                          onPressed: () {
                            setState(() {
                              _longAptIndex = 1;
                              if (_longAptIndex == 1) {
                                _isLongApt = false;
                              }
                            });
                          },
                          child: Text(
                            'Short',
                            style: TextStyle(
                              color: _isLongApt
                                  ? const Color.fromRGBO(154, 154, 154, 1)
                                  : primaryWhiteColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(right: 30),
                width: _width * 0.22,
                height: 20,
                decoration: boxDecoration(
                  const Color.fromRGBO(254, 197, 0, 0.2),
                  100,
                  0,
                  const Color.fromRGBO(254, 197, 0, 0.2),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                  ),
                  onPressed: () {},
                  child: const Center(
                    child: Text(
                      '+ Add to Wallet',
                      style: TextStyle(
                        color: Color.fromRGBO(254, 197, 0, 1),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Graph
          IndexedStack(
            index: _widgetIndex,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(1.5),
                    width: _width * .875,
                    height: _height * .04,
                    decoration: boxDecoration(
                      Colors.transparent,
                      10,
                      1,
                      secondaryGreyColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DecoratedBox(
                            decoration: boxDecoration(
                              _isDisplayingChart
                                  ? secondaryGreyColor
                                  : indexUnselectedStackBackgroundColor,
                              8,
                              0,
                              Colors.transparent,
                            ),
                            // TODO(anyone): remove button if not needed
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Chart',
                                style: TextStyle(
                                  color: _isDisplayingChart
                                      ? primaryWhiteColor
                                      : const Color.fromRGBO(154, 154, 154, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: boxDecoration(
                              _isDisplayingChart
                                  ? indexUnselectedStackBackgroundColor
                                  : secondaryGreyColor,
                              8,
                              0,
                              Colors.transparent,
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                              ),
                              onPressed: () {
                                setState(() {
                                  _widgetIndex = 1;
                                  if (_widgetIndex == 1) {
                                    _isDisplayingChart = false;
                                  }
                                });
                              },
                              child: Text(
                                'Stats',
                                style: TextStyle(
                                  color: _isDisplayingChart
                                      ? const Color.fromRGBO(154, 154, 154, 1)
                                      : primaryWhiteColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: _width * .875,
                    height: _height * .4,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: boxDecoration(
                      Colors.transparent,
                      10,
                      1,
                      secondaryGreyColor,
                    ),
                    child: Stack(
                      children: [
                        // Price
                        Align(
                          alignment: const Alignment(-.85, -.8),
                          child: SizedBox(
                            height: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Book Value Chart',
                                  style: textStyle(
                                    Colors.white,
                                    9,
                                    false,
                                    false,
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  height: 25,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        bookValue,
                                        style: textStyle(
                                          Colors.white,
                                          16,
                                          true,
                                          false,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          bookValuePercent,
                                          style: textStyle(
                                            Colors.green,
                                            12,
                                            false,
                                            false,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(1.5),
                    width: _width * .875,
                    height: _height * .035,
                    decoration: boxDecoration(
                      Colors.transparent,
                      10,
                      1,
                      secondaryGreyColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DecoratedBox(
                            decoration: boxDecoration(
                              _isDisplayingChart
                                  ? secondaryGreyColor
                                  : indexUnselectedStackBackgroundColor,
                              8,
                              0,
                              Colors.transparent,
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                              ),
                              onPressed: () {
                                setState(() {
                                  _widgetIndex = 0;
                                  if (_widgetIndex == 0) {
                                    _isDisplayingChart = true;
                                  }
                                });
                              },
                              child: Text(
                                'Chart',
                                style: TextStyle(
                                  color: _isDisplayingChart
                                      ? primaryWhiteColor
                                      : const Color.fromRGBO(154, 154, 154, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: boxDecoration(
                              _isDisplayingChart
                                  ? indexUnselectedStackBackgroundColor
                                  : secondaryGreyColor,
                              8,
                              0,
                              Colors.transparent,
                            ),
                            // TODO(anyone): remove button if not needed
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Stats',
                                style: TextStyle(
                                  color: _isDisplayingChart
                                      ? const Color.fromRGBO(154, 154, 154, 1)
                                      : primaryWhiteColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: _width * .875,
                    height: _height * .49,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        // Price Overview section
                        SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: _width * 0.4375,
                                    child: Text(
                                      'Price Overview',
                                      style: textStyle(
                                        Colors.white,
                                        15,
                                        false,
                                        false,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: _width * 0.4375,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            'Current',
                                            style: textStyle(
                                              greyTextColor,
                                              10,
                                              false,
                                              false,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            'All-Time High',
                                            style: textStyle(
                                              greyTextColor,
                                              10,
                                              false,
                                              false,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider(thickness: 1, color: greyTextColor),
                              SizedBox(
                                height: 15,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Market Price',
                                      style: textStyle(
                                        greyTextColor,
                                        12,
                                        false,
                                        false,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                marketPrice,
                                                style: textStyle(
                                                  Colors.white,
                                                  12,
                                                  false,
                                                  false,
                                                ),
                                              ),
                                              Text(
                                                marketPricePercent,
                                                style: textStyle(
                                                  Colors.red,
                                                  12,
                                                  false,
                                                  false,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '4.24 AX',
                                            style: textStyle(
                                              greyTextColor,
                                              12,
                                              false,
                                              false,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: _width * 0.175,
                                    child: Text(
                                      'Book Value',
                                      style: textStyle(
                                        greyTextColor,
                                        12,
                                        false,
                                        false,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              bookValue,
                                              style: textStyle(
                                                Colors.white,
                                                12,
                                                false,
                                                false,
                                              ),
                                            ),
                                            Text(
                                              bookValuePercent,
                                              style: textStyle(
                                                Colors.green,
                                                12,
                                                false,
                                                false,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          bookValue,
                                          style: textStyle(
                                            greyTextColor,
                                            12,
                                            false,
                                            false,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: _width * 0.175,
                                    child: Text(
                                      'MP:BV Ratio',
                                      style: textStyle(
                                        greyTextColor,
                                        12,
                                        false,
                                        false,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '80%',
                                              style: textStyle(
                                                greyTextColor,
                                                12,
                                                false,
                                                false,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '120%',
                                          style: textStyle(
                                            greyTextColor,
                                            12,
                                            false,
                                            false,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Detail Section
                        AthleteDetailsWidget(athlete).athletePageDetails(),
                        // Stats section
                        AthleteDetailsWidget(athlete)
                            .athletePageKeyStatistics(),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(top: .1),
              width: _width * .875,
              height: _height * .13,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buyButton(
                        context,
                        athlete,
                        _isPortraitMode,
                        _width,
                        widget.goToTradePage,
                      ),
                      sellButton(
                        context,
                        athlete,
                        _isPortraitMode,
                        _width,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      mintButton(
                        context,
                        athlete,
                        _isPortraitMode,
                        _width,
                      ),
                      redeemButton(
                        context,
                        athlete,
                        _isPortraitMode,
                        _width,
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget graphSide(
    BuildContext context,
    String longMarketPrice,
    String shortMarketPrice,
    String longMarketPricePercent,
    String shortMarketPricePercent,
    String longBookValue,
    String shortBookValue,
    String longBookValuePercent,
    String shortBookValuePercent,
    List<GraphData> chartStats,
    double containerHgt,
    double containerWdt,
  ) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var wid = _width * 0.4;
    final webWallet = Get.find<WebWallet>();
    if (_width < 1160) wid = containerWdt;
    return Container(
      height: _height / 1.5,
      constraints: const BoxConstraints(minHeight: 650, maxHeight: 850),
      child: Column(
        children: [
          // title
          SizedBox(
            width: wid,
            height: 100,
            child: Row(
              children: [
                // Back button
                SizedBox(
                  width: 70,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        listView = 1;
                      });
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                // APT Icon
                const SizedBox(
                  width: 10,
                ),
                // Player Name
                Text(
                  athlete.name,
                  style: textStyle(Colors.white, 26, false, false),
                ),
                // '|' Symbol
                Container(
                  width: 20,
                  alignment: Alignment.center,
                  child: Text(
                    '|',
                    style: textStyle(
                      const Color.fromRGBO(100, 100, 100, 1),
                      24,
                      false,
                      false,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Seasonal APT',
                      style: textStyle(
                        const Color.fromRGBO(154, 154, 154, 1),
                        24,
                        false,
                        false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(1.5),
                      width: _width * .10,
                      height: _height * .02,
                      decoration: boxDecoration(
                        Colors.transparent,
                        10,
                        1,
                        secondaryGreyColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: DecoratedBox(
                              decoration: boxDecoration(
                                _isLongApt
                                    ? secondaryGreyColor
                                    : indexUnselectedStackBackgroundColor,
                                8,
                                0,
                                Colors.transparent,
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(15, 8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _longAptIndex = 0;
                                    if (_longAptIndex == 0) {
                                      _isLongApt = true;
                                    }
                                  });
                                },
                                child: Text(
                                  'Long',
                                  style: TextStyle(
                                    color: _isLongApt
                                        ? primaryWhiteColor
                                        : const Color.fromRGBO(
                                            154,
                                            154,
                                            154,
                                            1,
                                          ),
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: DecoratedBox(
                              decoration: boxDecoration(
                                _isLongApt
                                    ? indexUnselectedStackBackgroundColor
                                    : secondaryGreyColor,
                                8,
                                0,
                                Colors.transparent,
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _longAptIndex = 1;
                                    if (_longAptIndex == 1) {
                                      _isLongApt = false;
                                    }
                                  });
                                },
                                child: Text(
                                  'Short',
                                  style: TextStyle(
                                    color: _isLongApt
                                        ? const Color.fromRGBO(154, 154, 154, 1)
                                        : primaryWhiteColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 4,
                  runSpacing: 64,
                  children: [
                    Container(
                      height: 20,
                      decoration: boxDecoration(
                        Colors.amber[500]!.withOpacity(0.20),
                        500,
                        1,
                        Colors.transparent,
                      ),
                      child: TextButton(
                        onPressed: () {
                          webWallet.addTokenToWallet(
                            _getCurrentTokenAddress(),
                            _getTokenImage(),
                          );
                        },
                        child: Text(
                          '+ Add to Wallet',
                          style:
                              textStyle(Colors.amber[500]!, 10, false, false),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // graph side
          SizedBox(
            width: wid,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //build graph
                Container(
                  width: wid * .875,
                  height: _height * .4,
                  decoration: boxDecoration(
                    Colors.transparent,
                    10,
                    1,
                    greyTextColor,
                  ),
                  child: Stack(
                    children: [
                      // Graph
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 28,
                          right: 28,
                          top: 14,
                        ),
                        child: (chartStats.isEmpty)
                            ? const Center(child: CircularProgressIndicator())
                            : IndexedStack(
                                index: _longAptIndex,
                                children: [
                                  buildLongChart(
                                    chartStats,
                                    _longToolTipBehavior,
                                    _zoomPanBehavior,
                                  ),
                                  buildShortChart(
                                    chartStats,
                                    _shortToolTipBehavior,
                                    _zoomPanBehavior,
                                  )
                                ],
                              ),
                      ),
                      // Price
                    ],
                  ),
                ),
                //give spacing between the graph and the buttons
                const SizedBox(
                  height: 12,
                ),
                //build buttons and tooltip
                SizedBox(
                  width: wid * .875,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buyButton(
                            context,
                            athlete,
                            _isPortraitMode,
                            containerWdt,
                            widget.goToTradePage,
                          ),
                          sellButton(
                            context,
                            athlete,
                            _isPortraitMode,
                            containerWdt,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          mintButton(
                            context,
                            athlete,
                            _isPortraitMode,
                            containerWdt,
                          ),
                          redeemButton(
                            context,
                            athlete,
                            _isPortraitMode,
                            containerWdt,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          athletePageToolTip(),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget statsSide(
    BuildContext context,
    String longMarketPrice,
    String shortMarketPrice,
    String longMarketPricePercent,
    String shortMarketPricePercent,
    String longBookValue,
    String shortBookValue,
    String longBookValuePercent,
    String shortBookValuePercent,
  ) {
    const longBookValuePercent = '+4%';
    const shortBookValuePercent = '+2%';
    final walletController = Get.find<WalletController>();
    final longCurrentBookValueRatio =
        (athlete.longTokenPrice! / athlete.longTokenBookPrice!) * 100;
    final shortCurrentBookValueRatio =
        (athlete.shortTokenPrice! / athlete.shortTokenBookPrice!) * 100;
    final _width = MediaQuery.of(context).size.width;
    var wid = _width * 0.4;
    if (_width < 1160) wid = _width * 0.95;

    // Stats-Side
    return Container(
      width: wid,
      height: 580,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price Overview section
          SizedBox(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price Overview',
                      style: textStyle(
                        Colors.white,
                        24,
                        false,
                        false,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      height: 20,
                      child: FutureBuilder<String>(
                        future: _isLongApt
                            ? walletController.getTokenSymbol(
                                getLongAptAddress(athlete.id),
                              )
                            : walletController.getTokenSymbol(
                                getShortAptAddress(athlete.id),
                              ),
                        builder: (context, snapshot) {
                          //Check API response data
                          if (snapshot.hasError) {
                            // can't get symbol
                            return showSymbol('---');
                          } else if (snapshot.hasData) {
                            // got the balance
                            return showSymbol(snapshot.data!);
                          } else {
                            // loading
                            return const Center(
                              child: SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  color: Colors.amber,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Current',
                        style: textStyle(
                          greyTextColor,
                          14,
                          false,
                          false,
                        ),
                      ),
                    ),
                    // TODO(anyone): get the all time high book value and \
                    // market value prices
                    // Container(
                    //     alignment: Alignment.bottomRight,
                    //     child: Text("All-Time High",
                    //         style: textStyle(greyTextColor,
                    //             14, false, false)))
                  ],
                ),
                Divider(thickness: 1, color: greyTextColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Market Price',
                      style: textStyle(
                        greyTextColor,
                        20,
                        false,
                        false,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            (_longAptIndex == 0)
                                ? '''${athlete.longTokenPrice!.toStringAsFixed(2)} AX'''
                                : '''${athlete.shortTokenPrice!.toStringAsFixed(2)} AX''',
                            style: textStyle(
                              Colors.white,
                              14,
                              false,
                              false,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 2),
                            child: Text(
                              (_longAptIndex == 0)
                                  ? getPercentageDesc(
                                      athlete.longTokenPercentage!,
                                    )
                                  : getPercentageDesc(
                                      athlete.shortTokenPercentage!,
                                    ),
                              style: (_longAptIndex == 0)
                                  ? textStyle(
                                      getPercentageColor(
                                        athlete.longTokenPercentage!,
                                      ),
                                      12,
                                      false,
                                      false,
                                    )
                                  : textStyle(
                                      getPercentageColor(
                                        athlete.shortTokenPercentage!,
                                      ),
                                      12,
                                      false,
                                      false,
                                    ),
                            ),
                          ),
                          // TODO(anyone): get the all time high book value and
                          // market value prices
                          // Text("4.24 AX",
                          //     style: textStyle(greyTextColor, 14,
                          //         false, false))
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _width * 0.175,
                      child: Text(
                        'Book Value',
                        style: textStyle(
                          greyTextColor,
                          20,
                          false,
                          false,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          (_longAptIndex == 0)
                              ? '''${athlete.longTokenBookPrice!.toStringAsFixed(2)} AX'''
                              : '''${athlete.shortTokenBookPrice!.toStringAsFixed(2)} AX''',
                          style: textStyle(
                            Colors.white,
                            14,
                            false,
                            false,
                          ),
                        ),
                        Text(
                          (_longAptIndex == 0)
                              ? longBookValuePercent
                              : shortBookValuePercent,
                          style: textStyle(
                            Colors.green,
                            12,
                            false,
                            false,
                          ),
                        ),
                        // TODO(anyone): get the all time high book value and
                        // market value prices
                        // Text(shortBookValue, style: textStyle(greyTextColor,
                        // 14, false, false))
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _width * 0.175,
                      child: Text(
                        'MP:BV Ratio',
                        style: textStyle(
                          greyTextColor,
                          20,
                          false,
                          false,
                        ),
                      ),
                    ),
                    Text(
                      '''${_isLongApt ? longCurrentBookValueRatio.toStringAsFixed(2) : shortCurrentBookValueRatio.toStringAsFixed(2)}%''',
                      style: textStyle(
                        greyTextColor,
                        16,
                        false,
                        false,
                      ),
                    ),
                    // TODO(anyone): get the all time high book value and
                    // market value prices
                    // Container(
                    //   child: Text("120%", style: textStyle(greyTextColor, 16,
                    //false, false)),),
                  ],
                ),
              ],
            ),
          ),
          // Detail Section
          AthleteDetailsWidget(athlete).athletePageDetails(),
          // Stats section
          AthleteDetailsWidget(athlete).athletePageKeyStatistics(),
        ],
      ),
    );
  }

  Widget showSymbol(String symbol) {
    return Center(
      child: Text(
        'Symbol: \$$symbol',
        style: textStyle(greyTextColor, 10, false, false),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _getCurrentTokenAddress() {
    return _isLongApt
        ? getLongAptAddress(athlete.id)
        : getShortAptAddress(athlete.id);
  }

  String _getTokenImage() {
    return _isLongApt
        ? 'https://raw.githubusercontent.com/SportsToken/ax_dapp/develop/assets/images/apt_noninverted.png'
        : 'https://raw.githubusercontent.com/SportsToken/ax_dapp/develop/assets/images/apt_inverted.png';
  }
}
