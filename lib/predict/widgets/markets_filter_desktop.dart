import 'package:ax_dapp/predict/bloc/predict_page_bloc.dart';
import 'package:ax_dapp/predict/models/models.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PredictionMarketsFilterDesktop extends StatefulWidget {
  const PredictionMarketsFilterDesktop({super.key});

  @override
  State<PredictionMarketsFilterDesktop> createState() =>
      _PredictionMarketsFilterDesktopState();
}

class _PredictionMarketsFilterDesktopState
    extends State<PredictionMarketsFilterDesktop> {
  final marketsSearchController = TextEditingController();
  bool _searchExpanded = false;

  @override
  Widget build(BuildContext context) {
    const sportFilterTxSz = 14.0;
    final bloc = context.read<PredictPageBloc>();
    var _selectedMarket = context.read<PredictPageBloc>().state.selectedMarket;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        return Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
          ),
          height: 60,
          child: Row(
            children: [
              Text(
                isNarrow ? 'AX Markets' : 'AthleteX Prediction Markets',
                style: textStyle(
                  Colors.white,
                  isNarrow ? 15 : 18,
                  isBold: false,
                  isUline: false,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '|',
                style: textStyle(
                  Colors.white,
                  18,
                  isBold: false,
                  isUline: false,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedMarket =
                                SupportedPredictionMarkets.college;
                          });

                          bloc
                            ..add(
                              const SelectedPredictionMarketsChanged(
                                selectedMarkets:
                                    SupportedPredictionMarkets.college,
                              ),
                            )
                            ..add(const CollegePredictionMarketsRequested());
                        },
                        child: Text(
                          'College',
                          style: textSwapState(
                            condition: _selectedMarket ==
                                SupportedPredictionMarkets.college,
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
                          setState(() {
                            _selectedMarket =
                                SupportedPredictionMarkets.basketball;
                          });

                          marketsSearchController.clear();
                          bloc
                            ..add(
                              const SelectedPredictionMarketsChanged(
                                selectedMarkets:
                                    SupportedPredictionMarkets.basketball,
                              ),
                            )
                            ..add(const BasketballPredictionMarketsRequested());
                        },
                        child: Text(
                          'Basketball',
                          style: textSwapState(
                            condition: _selectedMarket ==
                                SupportedPredictionMarkets.basketball,
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
                          setState(() {
                            _selectedMarket =
                                SupportedPredictionMarkets.football;
                          });
                          marketsSearchController.clear();
                          bloc
                            ..add(
                              const SelectedPredictionMarketsChanged(
                                selectedMarkets:
                                    SupportedPredictionMarkets.football,
                              ),
                            )
                            ..add(const FootballPredictionMarketsRequested());
                        },
                        child: Text(
                          'Football',
                          style: textSwapState(
                            condition: _selectedMarket ==
                                SupportedPredictionMarkets.football,
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
                          setState(() {
                            _selectedMarket = SupportedPredictionMarkets.hockey;
                          });
                          marketsSearchController.clear();
                          bloc
                            ..add(
                              const SelectedPredictionMarketsChanged(
                                selectedMarkets:
                                    SupportedPredictionMarkets.hockey,
                              ),
                            )
                            ..add(const HockeyPredictionMarketsRequested());
                        },
                        child: Text(
                          'Hockey',
                          style: textSwapState(
                            condition: _selectedMarket ==
                                SupportedPredictionMarkets.hockey,
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
                          setState(() {
                            _selectedMarket =
                                SupportedPredictionMarkets.baseball;
                          });
                          marketsSearchController.clear();
                          bloc
                            ..add(
                              const SelectedPredictionMarketsChanged(
                                selectedMarkets:
                                    SupportedPredictionMarkets.baseball,
                              ),
                            )
                            ..add(const BaseballPredictionMarketsRequested());
                        },
                        child: Text(
                          'Baseball',
                          style: textSwapState(
                            condition: _selectedMarket ==
                                SupportedPredictionMarkets.baseball,
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
                          setState(() {
                            _selectedMarket = SupportedPredictionMarkets.soccer;
                          });
                          marketsSearchController.clear();
                          bloc
                            ..add(
                              const SelectedPredictionMarketsChanged(
                                selectedMarkets:
                                    SupportedPredictionMarkets.soccer,
                              ),
                            )
                            ..add(const SoccerPredictionMarketsRequested());
                        },
                        child: Text(
                          'Soccer',
                          style: textSwapState(
                            condition: _selectedMarket ==
                                SupportedPredictionMarkets.soccer,
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
                          setState(() {
                            _selectedMarket = SupportedPredictionMarkets.voted;
                          });
                          marketsSearchController.clear();
                          bloc
                            ..add(
                              const SelectedPredictionMarketsChanged(
                                selectedMarkets:
                                    SupportedPredictionMarkets.voted,
                              ),
                            )
                            ..add(const VotedPredictionMarketsRequested());
                        },
                        child: Text(
                          'Voted',
                          style: textSwapState(
                            condition: _selectedMarket ==
                                SupportedPredictionMarkets.voted,
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
                          setState(() {
                            _selectedMarket = SupportedPredictionMarkets.exotic;
                          });

                          marketsSearchController.clear();
                          bloc
                            ..add(
                              const SelectedPredictionMarketsChanged(
                                selectedMarkets:
                                    SupportedPredictionMarkets.exotic,
                              ),
                            )
                            ..add(const ExoticPredictionMarketsRequested());
                        },
                        child: Text(
                          'Exotic',
                          style: textSwapState(
                            condition: _selectedMarket ==
                                SupportedPredictionMarkets.exotic,
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
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: _searchExpanded ? 260 : 40,
                height: 40,
                child: _searchExpanded
                    ? TextField(
                        controller: marketsSearchController,
                        autofocus: true,
                        onSubmitted: (_) {
                          if (marketsSearchController.text.isEmpty) {
                            setState(() => _searchExpanded = false);
                          }
                        },
                        style: textStyle(
                          Colors.white,
                          14,
                          isBold: false,
                          isUline: false,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Search markets',
                          hintStyle: textStyle(
                            Colors.grey[500]!,
                            14,
                            isBold: false,
                            isUline: false,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 18,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 16,
                            ),
                            onPressed: () {
                              marketsSearchController.clear();
                              setState(() => _searchExpanded = false);
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.04),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.white24,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.amber,
                              width: 1.2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() => _searchExpanded = true);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
