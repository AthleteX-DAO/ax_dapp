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

  @override
  Widget build(BuildContext context) {
    const sportFilterTxSz = 14.0;
    final bloc = context.read<PredictPageBloc>();
    var _selectedMarket = context.read<PredictPageBloc>().state.selectedMarket;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
          ),
          height: 40,
          child: Row(
            children: [
              Text(
                'Athlete Performance Markets',
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
            ],
          ),
        );
      },
    );
  }
}
