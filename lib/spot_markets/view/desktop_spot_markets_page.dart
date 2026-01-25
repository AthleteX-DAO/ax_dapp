import 'package:ax_dapp/app/widgets/crypto_ticker_tape.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/spot_markets/bloc/bloc.dart';
import 'package:ax_dapp/spot_markets/models/models.dart';
import 'package:ax_dapp/spot_markets/widgets/widgets.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Desktop Spot Markets trading page with glass morphism design
class DesktopSpotMarketsPage extends StatelessWidget {
  const DesktopSpotMarketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<SpotMarketsBloc, SpotMarketsState>(
        listener: (context, state) {
          if (state is SpotMarketOrderPlaced) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is SpotMarketsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: BlocBuilder<SpotMarketsBloc, SpotMarketsState>(
          builder: (context, state) {
            if (state is SpotMarketsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SpotMarketsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<SpotMarketsBloc>()
                            .add(const SpotMarketsInitialize());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is SpotMarketsLoaded) {
              if (state.markets.isEmpty) {
                return const Center(
                  child: Text(
                    'No markets available',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final selectedMarketData =
                  state.marketData[state.selectedMarket];
              final showSidebar = state.showSidebar;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Ticker at top of page (glass card)
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.08),
                              Colors.white.withOpacity(0.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1.5,
                          ),
                        ),
                        child: const CryptoTickerTape(),
                      ),
                      const SizedBox(height: 24),
                      // Header with controls in glass card
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.08),
                              Colors.white.withOpacity(0.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Spot Markets',
                              style: textStyle(
                                Colors.white,
                                18,
                                isBold: true,
                                isUline: false,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  tooltip: showSidebar
                                      ? 'Hide markets'
                                      : 'Show markets',
                                  onPressed: () {
                                    context.read<SpotMarketsBloc>().add(
                                        const SpotSidebarVisibilityToggled());
                                  },
                                  icon: Icon(
                                    showSidebar
                                        ? Icons.view_sidebar
                                        : Icons.view_sidebar_outlined,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Main content row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left section - Chart and Order form
                          Expanded(
                            child: selectedMarketData != null
                                ? Column(
                                    children: [
                                      // Chart Card (Glass)
                                      Container(
                                        height: 480,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.08),
                                              Colors.white.withOpacity(0.06),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            width: 1.5,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: SpotMarketChart(
                                          symbol: selectedMarketData.symbol,
                                          price: selectedMarketData.currentPrice,
                                          change24h:
                                              selectedMarketData.change24h,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      // Order Form Card (Glass)
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.08),
                                              Colors.white.withOpacity(0.06),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            width: 1.5,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: SpotOrderForm(
                                          selectedMarket:
                                              state.selectedMarket,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: 400,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.08),
                                          Colors.white.withOpacity(0.06),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            Colors.white.withOpacity(0.1),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Select a market to trade',
                                        style: textStyle(
                                          Colors.white54,
                                          16,
                                          isBold: false,
                                          isUline: false,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 20),
                          // Right section - Markets sidebar
                          if (showSidebar)
                            SizedBox(
                              width: 256,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.08),
                                      Colors.white.withOpacity(0.06),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1.5,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Available Markets',
                                        style: textStyle(
                                          Colors.white,
                                          14,
                                          isBold: true,
                                          isUline: false,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ...state.markets.map((market) {
                                        final marketData =
                                            state.marketData[market];
                                        final isSelected =
                                            market == state.selectedMarket;

                                        return GestureDetector(
                                          onTap: () {
                                            context.read<SpotMarketsBloc>().add(
                                                SpotMarketSelected(market));
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            margin:
                                                const EdgeInsets.only(bottom: 6),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? primaryOrangeColor
                                                      .withOpacity(0.15)
                                                  : Colors.white
                                                      .withOpacity(0.05),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isSelected
                                                    ? primaryOrangeColor
                                                    : Colors.white
                                                        .withOpacity(0.1),
                                                width: 1.2,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      market,
                                                      style: textStyle(
                                                        isSelected
                                                            ? primaryOrangeColor
                                                            : Colors.white,
                                                        13,
                                                        isBold: true,
                                                        isUline: false,
                                                      ),
                                                    ),
                                                    if (marketData != null)
                                                      Text(
                                                        marketData.change24h >= 0
                                                            ? '+${marketData.change24h.toStringAsFixed(1)}%'
                                                            : '${marketData.change24h.toStringAsFixed(1)}%',
                                                        style: TextStyle(
                                                          color: marketData.change24h >=
                                                                  0
                                                              ? Colors.green
                                                              : Colors
                                                                  .redAccent,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                if (marketData != null)
                                                  Text(
                                                    '\$${marketData.currentPrice.toStringAsFixed(2)}',
                                                    style: textStyle(
                                                      Colors.white70,
                                                      12,
                                                      isBold: false,
                                                      isUline: false,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: Text('Unknown state'),
            );
          },
        ),
      ),
    );
  }
}
