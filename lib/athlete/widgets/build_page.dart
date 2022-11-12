import 'package:ax_dapp/athlete/bloc/athlete_page_bloc.dart';
import 'package:ax_dapp/athlete/widgets/widgets.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/scout/widgets/widget_factories/widget_factories.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tokens_repository/tokens_repository.dart';

class BuildPage extends StatefulWidget {
  const BuildPage({
    super.key,
    required this.marketPrice,
    required this.marketPricePercent,
    required this.bookValue,
    required this.bookValuePercent,
    required this.athlete,
  });

  final String marketPrice;
  final String marketPricePercent;
  final String bookValue;
  final String bookValuePercent;
  final AthleteScoutModel athlete;

  @override
  State<BuildPage> createState() => _BuildPageState();
}

class _BuildPageState extends State<BuildPage> {
  Color indexUnselectedStackBackgroundColor = Colors.transparent;
  int _widgetIndex = 0;
  bool _isDisplayingChart = true;
  final bool _isPortraitMode = false;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
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
                  context.goNamed('scout');
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
                      widget.athlete.name,
                      style: textStyle(
                        Colors.white,
                        20,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    Text(
                      'Seasonal APT',
                      style: textStyle(
                        const Color.fromRGBO(154, 154, 154, 1),
                        12,
                        isBold: false,
                        isUline: false,
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
                      child: BlocSelector<AthletePageBloc, AthletePageState,
                          AptType>(
                        selector: (state) => state.aptTypeSelection,
                        builder: (context, aptTypeSelection) {
                          return DecoratedBox(
                            decoration: boxDecoration(
                              aptTypeSelection.isLong
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
                              onPressed: () =>
                                  context.read<AthletePageBloc>().add(
                                        const AptTypeSelectionChanged(
                                          AptType.long,
                                        ),
                                      ),
                              child: Text(
                                'Long',
                                style: TextStyle(
                                  color: aptTypeSelection.isLong
                                      ? primaryWhiteColor
                                      : const Color.fromRGBO(154, 154, 154, 1),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: BlocSelector<AthletePageBloc, AthletePageState,
                          AptType>(
                        selector: (state) => state.aptTypeSelection,
                        builder: (context, aptTypeSelection) {
                          return DecoratedBox(
                            decoration: boxDecoration(
                              aptTypeSelection.isLong
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
                              onPressed: () =>
                                  context.read<AthletePageBloc>().add(
                                        const AptTypeSelectionChanged(
                                          AptType.short,
                                        ),
                                      ),
                              child: Text(
                                'Short',
                                style: TextStyle(
                                  color: aptTypeSelection.isLong
                                      ? const Color.fromRGBO(154, 154, 154, 1)
                                      : primaryWhiteColor,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          );
                        },
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
                                    isBold: false,
                                    isUline: false,
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
                                        widget.bookValue,
                                        style: textStyle(
                                          Colors.white,
                                          16,
                                          isBold: true,
                                          isUline: false,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          widget.bookValuePercent,
                                          style: textStyle(
                                            Colors.green,
                                            12,
                                            isBold: false,
                                            isUline: false,
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
                            // ignore: todo
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
                                        isBold: false,
                                        isUline: false,
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
                                              isBold: false,
                                              isUline: false,
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
                                              isBold: false,
                                              isUline: false,
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
                                        isBold: false,
                                        isUline: false,
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
                                                widget.marketPrice,
                                                style: textStyle(
                                                  Colors.white,
                                                  12,
                                                  isBold: false,
                                                  isUline: false,
                                                ),
                                              ),
                                              Text(
                                                widget.marketPricePercent,
                                                style: textStyle(
                                                  Colors.red,
                                                  12,
                                                  isBold: false,
                                                  isUline: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '4.24 AX',
                                            style: textStyle(
                                              greyTextColor,
                                              12,
                                              isBold: false,
                                              isUline: false,
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
                                        isBold: false,
                                        isUline: false,
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
                                              widget.bookValue,
                                              style: textStyle(
                                                Colors.white,
                                                12,
                                                isBold: false,
                                                isUline: false,
                                              ),
                                            ),
                                            Text(
                                              widget.bookValuePercent,
                                              style: textStyle(
                                                Colors.green,
                                                12,
                                                isBold: false,
                                                isUline: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          widget.bookValue,
                                          style: textStyle(
                                            greyTextColor,
                                            12,
                                            isBold: false,
                                            isUline: false,
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
                                        isBold: false,
                                        isUline: false,
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
                                                isBold: false,
                                                isUline: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '120%',
                                          style: textStyle(
                                            greyTextColor,
                                            12,
                                            isBold: false,
                                            isUline: false,
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
                        AthleteDetailsWidget(widget.athlete)
                            .athletePageDetails(),
                        // Stats section
                        AthleteDetailsWidget(widget.athlete)
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
                      BlocSelector<AthletePageBloc, AthletePageState, AptType>(
                        selector: (state) => state.aptTypeSelection,
                        builder: (context, aptTypeSelection) {
                          return BuyButton(
                            athlete: widget.athlete,
                            isPortraitMode: _isPortraitMode,
                            containerWdt: _width,
                            isLongApt: aptTypeSelection.isLong,
                          );
                        },
                      ),
                      BlocSelector<AthletePageBloc, AthletePageState, AptType>(
                        selector: (state) => state.aptTypeSelection,
                        builder: (context, aptTypeSelection) {
                          return SellButton(
                            athlete: widget.athlete,
                            isPortraitMode: _isPortraitMode,
                            containerWdt: _width,
                            isLongApt: aptTypeSelection.isLong,
                          );
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MintButton(
                        athlete: widget.athlete,
                        isPortraitMode: _isPortraitMode,
                        containerWdt: _width,
                      ),
                      RedeemButton(
                        athlete: widget.athlete,
                        inputLongApt: '',
                        inputShortApt: '',
                        valueInAX: '',
                        isPortraitMode: _isPortraitMode,
                        containerWdt: _width,
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
}
