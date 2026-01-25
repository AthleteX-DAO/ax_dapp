import 'package:ax_dapp/perps/bloc/perps_page_bloc.dart';
import 'package:ax_dapp/service/controller/perps/perps_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/perps/widgets/trading_view_chart.dart';
import 'package:ax_dapp/perps/widgets/perps_trading_column.dart';

/// Desktop Perpetuals page displaying BTC Perps data.
class DesktopPerpetualsPage extends StatefulWidget {
  const DesktopPerpetualsPage({Key? key}) : super(key: key);

  @override
  State<DesktopPerpetualsPage> createState() => _DesktopPerpetualsPageState();
}

class _DesktopPerpetualsPageState extends State<DesktopPerpetualsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<PerpsPageBloc>().add(const PerpsPageInitialize());
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Perpetuals Futures Markets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PerpsPageBloc>().add(const PerpsPageRefresh());
            },
          ),
        ],
      ),
      body: BlocBuilder<PerpsPageBloc, PerpsPageState>(
        builder: (context, state) {
          if (state is PerpsPageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PerpsPageLoaded) {
            final data = state.btcPerpsData;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildTabBar(),
                    const SizedBox(height: 16),
                    _buildTabContent(data),
                    const SizedBox(height: 24),
                    _buildTimestamp(data),
                  ],
                ),
              ),
            );
          } else if (state is PerpsPageError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<PerpsPageBloc>()
                          .add(const PerpsPageRefresh());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bitcoin Perpetual Futures',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Live data from Synthetix V3 on Base Sepolia Testnet',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Chart'),
                      SizedBox(height: 8),
                      TradingViewChart(
                        symbol: 'BINANCE:BTCUSDT',
                        interval: '60',
                        height: 420,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const PerpsTradingColumn(symbol: 'BTC'),
          ],
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 48,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Balances'),
          Tab(text: 'Positions'),
          Tab(text: 'Open Orders'),
          Tab(text: 'Trade History'),
          Tab(text: 'Funding History'),
          Tab(text: 'Order History'),
        ],
        isScrollable: false,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  Widget _buildTabContent(BtcPerpsData data) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBalancesView(),
              _buildPositionsView(data),
              _buildOpenOrdersView(),
              _buildTradeHistoryView(),
              _buildFundingHistoryView(),
              _buildOrderHistoryView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalancesView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wallet, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No balances yet',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildPositionsView(BtcPerpsData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Open Positions',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              IconButton(
                icon: const Icon(Icons.filter_list, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 32,
              columns: const [
                DataColumn(label: Text('POSITION')),
                DataColumn(label: Text('SIZE')),
                DataColumn(label: Text('NET VALUE')),
                DataColumn(label: Text('COLLATERAL')),
                DataColumn(label: Text('ENTRY PRICE')),
                DataColumn(label: Text('MARK PRICE')),
                DataColumn(label: Text('LIQ. PRICE')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('--')),
                  DataCell(Text('--')),
                  DataCell(Text('--')),
                  DataCell(Text('--')),
                  DataCell(Text('--')),
                  DataCell(Text('--')),
                  DataCell(Text('--')),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'No open positions',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildOpenOrdersView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No open orders',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildTradeHistoryView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.history, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No trades yet',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildFundingHistoryView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.paid, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No funding history',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildOrderHistoryView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.receipt_long, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No order history',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildTimestamp(BtcPerpsData data) {
    return Center(
      child: Text(
        'Last updated: ${data.timestamp.toLocal().toString().split('.')[0]}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
      ),
    );
  }
}
