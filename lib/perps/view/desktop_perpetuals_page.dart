import 'package:ax_dapp/perps/bloc/perps_page_bloc.dart';
import 'package:ax_dapp/perps/bloc/perps_trading_bloc.dart';
import 'package:ax_dapp/service/controller/perps/perps_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/perps/widgets/trading_view_chart.dart';
import 'package:ax_dapp/perps/widgets/perps_trading_column.dart';
import 'package:ax_dapp/perps/widgets/perps_stat_cards.dart';
import 'package:ax_dapp/perps/widgets/amm_price_impact_curve.dart';
import 'package:ax_dapp/perps/widgets/position_summary_card.dart';
import 'package:ax_dapp/perps/utils/perps_responsive.dart';

/// Desktop Perpetuals page displaying BTC Perps data with responsive 3-column layout
class DesktopPerpetualsPage extends StatefulWidget {
  const DesktopPerpetualsPage({Key? key}) : super(key: key);

  @override
  State<DesktopPerpetualsPage> createState() => _DesktopPerpetualsPageState();
}

class _DesktopPerpetualsPageState extends State<DesktopPerpetualsPage> {
  double _tradeSize = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<PerpsPageBloc>().add(const PerpsPageInitialize());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            // Listen to trading bloc and trigger order fetch when trade succeeds
            BlocListener<PerpsTradingBloc, PerpsTradingState>(
              listener: (context, state) {
                if (state is PerpsTradingSuccess) {
                  // Fetch orders after successful trade placement
                  context
                      .read<PerpsPageBloc>()
                      .add(const OrdersRequested(offset: 0, limit: 25));
                }
              },
          ),
        ],
        child: BlocBuilder<PerpsPageBloc, PerpsPageState>(
          builder: (context, state) {
            if (state is PerpsPageLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PerpsPageError) {
              return _buildErrorState(state.message);
            }

            if (state is PerpsPageLoaded) {
              final data = state.btcPerpsData;
              return _buildContent(data);
            }

            // Initial state - trigger initialization
            if (state is PerpsPageInitial) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<PerpsPageBloc>().add(const PerpsPageInitialize());
              });
              return const Center(child: CircularProgressIndicator());
            }

            return const SizedBox.shrink();
          },
        ),
        ),
    ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PerpsPageBloc>().add(const PerpsPageRefresh());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BtcPerpsData data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with title, subtitle, and refresh button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bitcoin Perpetual Futures',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Live data from Synthetix V3 on Base Sepolia Testnet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
                // Refresh button
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<PerpsPageBloc>().add(const PerpsPageRefresh());
                  },
                  tooltip: 'Refresh data',
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Stat cards row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  PerpStatCards(
                    price: data.priceInUSD,
                    pnlPercent: 0.0,
                    fundingRate: data.fundingRatePercentage,
                    marketSkewPercent: _calculateSkewPercent(data.skewUSD),
                    openInterest: data.openInterestUSD,
                    availableMargin: 0.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Main content area
            SizedBox(
              height: 500,
              child: ResponsivePerpsLayoutWithoutTabs(
                chart: _buildChartSection(data),
                visualizer: _buildAmmVisualizerSection(data),
                trading: _buildTradingSection(),
              ),
            ),
            const SizedBox(height: 32),
            // Bottom tabs panel (full width)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade800)),
              ),
              child: _buildTabsPanelBottom(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(BtcPerpsData data) {
    return Card(
      elevation: 0,
      color: const Color(0xFF1a1a1a),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chart',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: PerpResponsive.getChartHeight(context),
              child: const TradingViewChart(
                symbol: 'BINANCE:BTCUSDT',
                interval: '60',
                height: 420,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmmVisualizerSection(BtcPerpsData data) {
    return Card(
      elevation: 0,
      color: const Color(0xFF1a1a1a),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: AmmPriceImpactCurve(
          currentPrice: data.priceInUSD,
          currentSkew: data.skewUSD,
          skewScale: 1000000, // Default Synthetix skew scale
          size: _tradeSize,
          onSizeChanged: (size) {
            setState(() => _tradeSize = size);
          },
          isLong: true,
        ),
      ),
    );
  }

  Widget _buildTradingSection() {
    return Card(
      elevation: 0,
      color: const Color(0xFF1a1a1a),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const PerpsTradingColumn(symbol: 'BTC'),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade700, height: 1),
            const SizedBox(height: 16),
            PositionSummaryCard(
              hasPosition: false, // TODO: Fetch from user positions
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabsPanelBottom() {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'Balances'),
              Tab(text: 'Positions'),
              Tab(text: 'Open Orders'),
            ],
          ),
          SizedBox(
            height: 180,
            child: TabBarView(
              children: [
                // Balances tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No balances yet',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
                // Positions tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No open positions',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
                // Open Orders tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No open orders',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateSkewPercent(double skew) {
    // Skew as percentage: 50% = neutral, >50% = more longs, <50% = more shorts
    final skewScale = 1000000.0;
    final pd = skew / skewScale;
    return 50 + (pd * 50); // Convert to 0-100 scale
  }
}
