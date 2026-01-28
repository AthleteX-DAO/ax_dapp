import 'package:flutter/material.dart';
import 'package:ax_dapp/perps/models/perps_order_model.dart';

/// Right-side collapsible tab panel for displaying trade data
/// Slides in from the right edge with toggle button
class PerpTabsPanel extends StatefulWidget {
  const PerpTabsPanel({
    Key? key,
    required this.openOrders,
    required this.orderHistory,
    required this.tradeHistory,
    required this.balances,
    required this.onTabChanged,
  }) : super(key: key);

  final List<PerpsOrderModel> openOrders;
  final List<PerpsOrderModel> orderHistory;
  final List<PerpsOrderModel> tradeHistory;
  final Map<String, double> balances;
  final ValueChanged<int> onTabChanged;

  @override
  State<PerpTabsPanel> createState() => _PerpTabsPanelState();
}

class _PerpTabsPanelState extends State<PerpTabsPanel>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  bool _isExpanded = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _togglePanel() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main panel (slides in from right)
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(_slideController),
          child: Container(
            width: 350,
            color: const Color(0xFF1a1a1a),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Account',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: _togglePanel,
                        tooltip: 'Close panel',
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade700, height: 1),
                
                // Tabs
                TabBar(
                  controller: _tabController,
                  onTap: widget.onTabChanged,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'Balances'),
                    Tab(text: 'Positions'),
                    Tab(text: 'Open Orders'),
                    Tab(text: 'Trade Hist.'),
                    Tab(text: 'Funding'),
                    Tab(text: 'Order Hist.'),
                  ],
                ),
                
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBalancesTab(),
                      _buildPositionsTab(),
                      _buildOpenOrdersTab(),
                      _buildTradeHistoryTab(),
                      _buildFundingHistoryTab(),
                      _buildOrderHistoryTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Toggle button (always visible on right edge)
        Positioned(
          right: _isExpanded ? 350 : 0,
          top: 100,
          child: GestureDetector(
            onTap: _togglePanel,
            child: Container(
              width: 40,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a2a),
                border: Border(
                  left: BorderSide(color: Colors.grey.shade700),
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: RotatedBox(
                  quarterTurns: _isExpanded ? 2 : 0,
                  child: const Icon(
                    Icons.chevron_left,
                    size: 24,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalancesTab() {
    if (widget.balances.isEmpty) {
      return _buildEmptyState('No balances yet');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.balances.length,
      itemBuilder: (context, index) {
        final entry = widget.balances.entries.toList()[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade700),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '\$${entry.value.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPositionsTab() {
    return _buildEmptyState('No open positions');
  }

  Widget _buildOpenOrdersTab() {
    if (widget.openOrders.isEmpty) {
      return _buildEmptyState('No open orders');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.openOrders.length,
      itemBuilder: (context, index) {
        final order = widget.openOrders[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildTradeHistoryTab() {
    if (widget.tradeHistory.isEmpty) {
      return _buildEmptyState('No trades yet');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.tradeHistory.length,
      itemBuilder: (context, index) {
        final trade = widget.tradeHistory[index];
        return _buildOrderCard(context, trade);
      },
    );
  }

  Widget _buildFundingHistoryTab() {
    return _buildEmptyState('No funding history');
  }

  Widget _buildOrderHistoryTab() {
    if (widget.orderHistory.isEmpty) {
      return _buildEmptyState('No order history');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.orderHistory.length,
      itemBuilder: (context, index) {
        final order = widget.orderHistory[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, PerpsOrderModel order) {
    final sideColor = order.side == 'LONG' ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFF2a2a2a),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: sideColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  order.side,
                  style: TextStyle(
                    color: sideColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '\$${order.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Size: ${order.size.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          Text(
            order.timestamp.toString().split('.')[0],
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 48,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
