import 'package:ax_dapp/app/widgets/crypto_ticker_tape.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/spot_markets/bloc/bloc.dart';
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
          // Show order confirmation dialog when awaiting user confirmation
          if (state is SpotMarketOrderAwaitingConfirmation) {
            showDialog<void>(
              context: context,
              barrierColor: Colors.black.withOpacity(0.7),
              builder: (context) => OrderConfirmationDialog(
                pendingOrder: state.pendingOrder,
                onConfirm: () {
                  Navigator.pop(context);
                  context.read<SpotMarketsBloc>().add(
                        SpotMarketOrderConfirmed(state.pendingOrder.orderId),
                      );
                },
                onCancel: () {
                  Navigator.pop(context);
                  context.read<SpotMarketsBloc>().add(
                        SpotMarketOrderCancelled(state.pendingOrder.orderId),
                      );
                },
              ),
            );
          }
          // Show order status dialog when executing order
          else if (state is SpotMarketOrderProcessing) {
            showDialog<void>(
              context: context,
              barrierColor: Colors.black.withOpacity(0.7),
              barrierDismissible: false,
              builder: (context) => OrderStatusDialog(
                pendingOrder: state.pendingOrder,
                onRetry: () {
                  Navigator.pop(context);
                  context.read<SpotMarketsBloc>().add(
                        SpotMarketOrderConfirmed(state.pendingOrder.orderId),
                      );
                },
                onClose: () {
                  Navigator.pop(context);
                },
              ),
            );
          }
          // Hide status dialog on success
          else if (state is SpotMarketsLoaded) {
            // Close status dialog if one is open
            if (Navigator.canPop(context)) {
              final previousState = context.read<SpotMarketsBloc>().state;
              if (previousState is SpotMarketOrderProcessing) {
                Navigator.pop(context);
              }
            }
          }
          // Handle legacy states
          else if (state is SpotMarketOrderPlaced) {
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

              final screenHeight = MediaQuery.of(context).size.height;
              final sidebarMaxHeight = (screenHeight - 220).clamp(360.0, 720.0);

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
                                      // Chart Card (Glass) - compact height
                                      Container(
                                        height: 320,
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
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          children: [
                                            _ChartRangeSelector(
                                              selectedRange:
                                                  state.selectedRange,
                                              onSelected: (range) {
                                                context
                                                    .read<SpotMarketsBloc>()
                                                    .add(
                                                      SpotMarketRangeSelected(
                                                        range,
                                                      ),
                                                    );
                                              },
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: SpotMarketChart(
                                                symbol:
                                                    selectedMarketData.symbol,
                                                price: selectedMarketData
                                                    .currentPrice,
                                                change24h: selectedMarketData
                                                    .change24h,
                                                priceHistory: state
                                                        .priceHistory[
                                                            '${selectedMarketData.symbol}_${state.selectedRange.name}'] ??
                                                    const [],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Order Form Card (Glass) - larger
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
                                        padding: const EdgeInsets.all(16),
                                        child: SpotOrderForm(
                                          selectedMarket:
                                              state.selectedMarket,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Pending Orders Panel (Glass) - shows order history
                                      if (state.pendingOrders.isNotEmpty)
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
                                          padding: const EdgeInsets.all(16),
                                          child:
                                              PendingOrdersPanel(
                                                orders: state.pendingOrders,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    SizedBox(
                                      height: sidebarMaxHeight,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
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
                                  ],
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

class _ChartRangeSelector extends StatelessWidget {
  const _ChartRangeSelector({
    required this.selectedRange,
    required this.onSelected,
  });

  final SpotMarketChartRange selectedRange;
  final ValueChanged<SpotMarketChartRange> onSelected;

  @override
  Widget build(BuildContext context) {
    final ranges = <_RangeOption>[
      const _RangeOption('24HR', SpotMarketChartRange.day),
      const _RangeOption('6 Mo', SpotMarketChartRange.sixMonths),
      const _RangeOption('1Yr', SpotMarketChartRange.oneYear),
      const _RangeOption('YTD', SpotMarketChartRange.yearToDate),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: ranges.map((option) {
        final isSelected = option.range == selectedRange;
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onSelected(option.range),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.12)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withOpacity(0.3)
                      : Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                option.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RangeOption {
  const _RangeOption(this.label, this.range);

  final String label;
  final SpotMarketChartRange range;
}
