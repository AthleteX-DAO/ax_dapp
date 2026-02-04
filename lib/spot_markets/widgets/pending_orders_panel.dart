import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/spot_markets/models/pending_order.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class PendingOrdersPanel extends StatelessWidget {
  const PendingOrdersPanel({
    super.key,
    required this.orders,
  });

  final List<PendingOrder> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Center(
          child: Text(
            'No pending orders',
            style: textStyle(
              Colors.white.withOpacity(0.5),
              12,
              isBold: false,
              isUline: false,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Recent Orders (${orders.length})',
              style: textStyle(
                Colors.white,
                14,
                isBold: true,
                isUline: false,
              ),
            ),
          ),
          Divider(
            color: Colors.white.withOpacity(0.1),
            height: 1,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (_, __) => Divider(
              color: Colors.white.withOpacity(0.05),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderRow(context, order);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderRow(BuildContext context, PendingOrder order) {
    final isBuy = order.type == 'buy';
    final actionColor = isBuy ? primaryGreenColor : primaryRedColor;
    final statusColor = _getStatusColor(order.status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Order icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: actionColor.withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                isBuy ? Icons.arrow_downward : Icons.arrow_upward,
                color: actionColor,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Order details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${isBuy ? 'Buy' : 'Sell'} ${order.quantity.toStringAsFixed(4)} ${order.market}',
                  style: textStyle(
                    Colors.white,
                    12,
                    isBold: true,
                    isUline: false,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${order.totalCost.toStringAsFixed(2)} • ${_formatTime(order.createdAt)}',
                  style: textStyle(
                    Colors.white.withOpacity(0.5),
                    10,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: statusColor.withOpacity(0.3),
              ),
            ),
            child: Text(
              order.statusLabel,
              style: textStyle(
                statusColor,
                9,
                isBold: true,
                isUline: false,
              ),
            ),
          ),
          
          if (order.txHash != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Copy tx hash or open in browser
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tx: ${order.txHash!.substring(0, 10)}...'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Icon(
                Icons.open_in_new,
                size: 14,
                color: Colors.blue.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(PendingOrderStatus status) {
    switch (status) {
      case PendingOrderStatus.waitingForConfirmation:
        return Colors.orange;
      case PendingOrderStatus.approvalNeeded:
        return Colors.blue;
      case PendingOrderStatus.approvingToken:
        return Colors.blue;
      case PendingOrderStatus.executingOrder:
        return Colors.orange;
      case PendingOrderStatus.pending:
        return Colors.orange;
      case PendingOrderStatus.confirmed:
        return primaryGreenColor;
      case PendingOrderStatus.failed:
        return Colors.red;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
