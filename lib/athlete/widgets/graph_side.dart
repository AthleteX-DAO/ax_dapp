import 'package:ax_dapp/athlete/bloc/athlete_page_bloc.dart';
import 'package:ax_dapp/athlete/widgets/widgets.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/widgets/widgets.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tokens_repository/tokens_repository.dart';

class GraphSide extends StatelessWidget {
  const GraphSide({
    super.key,
    required this.athlete,
    required this.chartStats,
    required this.containerHeight,
    required this.containerWidth,
  });

  final AthleteScoutModel athlete;
  final List<GraphData> chartStats;
  final double containerHeight;
  final double containerWidth;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var wid = _width * 0.4;
    if (_width < 1160) wid = containerWidth;
    const indexUnselectedStackBackgroundColor = Colors.transparent;
    final _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enablePanning: true,
      enablePinching: true,
    );
    final _longToolTipBehavior = TooltipBehavior(enable: true);
    final _shortToolTipBehavior = TooltipBehavior(enable: true);
    final _isPortraitMode = MediaQuery.of(context).orientation == Orientation.portrait;
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
                      context.goNamed('scout');
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                // APT Icon
                BlocSelector<AthletePageBloc, AthletePageState, AptType>(
                  selector: (state) => state.aptTypeSelection,
                  builder: (context, aptTypeSelection) {
                    return Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: aptTypeSelection.isLong
                              ? const AssetImage(
                                  'assets/images/apt_noninverted.png',
                                )
                              : const AssetImage(
                                  'assets/images/apt_inverted.png',
                                ),
                        ),
                      ),
                    );
                  },
                ),
                // Player Name
                Text(
                  athlete.name,
                  style: textStyle(
                    Colors.white,
                    26,
                    isBold: false,
                    isUline: false,
                  ),
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
                      isBold: false,
                      isUline: false,
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
                        isBold: false,
                        isUline: false,
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
                            child: BlocSelector<AthletePageBloc,
                                AthletePageState, AptType>(
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
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: BlocSelector<AthletePageBloc,
                                AthletePageState, AptType>(
                              selector: (state) {
                                return state.aptTypeSelection;
                              },
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
                                            ? const Color.fromRGBO(
                                                154,
                                                154,
                                                154,
                                                1,
                                              )
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
                          context
                              .read<AthletePageBloc>()
                              .add(const AddTokenToWalletRequested());
                          final formattedWalletAddress = context
                              .read<WalletBloc>()
                              .state
                              .formattedWalletAddress;
                          context.read<TrackingCubit>().trackAddToWallet(
                                athleteName: athlete.name,
                                walletId: formattedWalletAddress,
                              );
                        },
                        child: Text(
                          '+ Add to Wallet',
                          style: textStyle(
                            Colors.amber[500]!,
                            10,
                            isBold: false,
                            isUline: false,
                          ),
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
                            ? const Loader(dimension: 36)
                            : BlocSelector<AthletePageBloc, AthletePageState,
                                AptType>(
                                selector: (state) => state.aptTypeSelection,
                                builder: (context, aptTypeSelection) {
                                  return IndexedStack(
                                    index: aptTypeSelection.index - 1,
                                    children: [
                                      AthletePageLongGraph(
                                        chartStats: chartStats,
                                        longToolTipBehavior:
                                            _longToolTipBehavior,
                                        zoomPanBehavior: _zoomPanBehavior,
                                      ),
                                      AthletePageShortGraph(
                                        chartStats: chartStats,
                                        shortToolTipBehavior:
                                            _shortToolTipBehavior,
                                        zoomPanBehavior: _zoomPanBehavior,
                                      )
                                    ],
                                  );
                                },
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
                          BlocSelector<AthletePageBloc, AthletePageState,
                              AptType>(
                            selector: (state) => state.aptTypeSelection,
                            builder: (context, aptTypeSelection) {
                              return BuyButton(
                                athlete: athlete,
                                isPortraitMode: _isPortraitMode,
                                containerWdt: containerWidth,
                                isLongApt: aptTypeSelection.isLong,
                              );
                            },
                          ),
                          BlocSelector<AthletePageBloc, AthletePageState,
                              AptType>(
                            selector: (state) => state.aptTypeSelection,
                            builder: (context, aptTypeSelection) {
                              return SellButton(
                                athlete: athlete,
                                isPortraitMode: _isPortraitMode,
                                containerWdt: containerWidth,
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
                            athlete: athlete,
                            isPortraitMode: _isPortraitMode,
                            containerWdt: containerWidth,
                          ),
                          RedeemButton(
                            athlete: athlete,
                            inputLongApt: '',
                            inputShortApt: '',
                            valueInAX: '',
                            isPortraitMode: _isPortraitMode,
                            containerWdt: containerWidth,
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
}
