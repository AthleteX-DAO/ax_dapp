import 'package:flutter/material.dart';

/// Displays user's current position summary with P&L and risk metrics
class PositionSummaryCard extends StatelessWidget {
  const PositionSummaryCard({
    Key? key,
    required this.hasPosition,
    this.size = 0.0,
    this.side = 'LONG',
    this.entryPrice = 0.0,
    this.markPrice = 0.0,
    this.realizedPnl = 0.0,
    this.unrealizedPnl = 0.0,
    this.unrealizedPnlPercent = 0.0,
    this.liquidationPrice = 0.0,
    this.collateral = 0.0,
    this.leverage = 1.0,
    this.funding = 0.0,
  }) : super(key: key);

  final bool hasPosition;
  final double size;
  final String side;
  final double entryPrice;
  final double markPrice;
  final double realizedPnl;
  final double unrealizedPnl;
  final double unrealizedPnlPercent;
  final double liquidationPrice;
  final double collateral;
  final double leverage;
  final double funding;

  @override
  Widget build(BuildContext context) {
    if (!hasPosition) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF2a2a2a),
        ),
        child: Center(
          child: Text(
            'No open position',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ),
      );
    }

    final sideColor = side == 'LONG' ? Colors.green : Colors.red;
    final pnlColor = unrealizedPnl >= 0 ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF2a2a2a),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with side badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Open Position',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: sideColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: sideColor),
                ),
                child: Text(
                  '$side ${(leverage * 1.0).toStringAsFixed(1)}x',
                  style: TextStyle(
                    color: sideColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Position size
          _buildMetricRow(
            context,
            'Size',
            '${size.toStringAsFixed(2)} USD',
            Colors.white,
          ),
          
          // Entry price vs Mark price
          _buildMetricRow(
            context,
            'Entry Price',
            '\$${entryPrice.toStringAsFixed(2)}',
            Colors.grey,
          ),
          _buildMetricRow(
            context,
            'Mark Price',
            '\$${markPrice.toStringAsFixed(2)}',
            Colors.white,
          ),
          
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade700, height: 1),
          const SizedBox(height: 8),
          
          // P&L section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unrealized P&L',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  Text(
                    '\$${unrealizedPnl.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: pnlColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: pnlColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${unrealizedPnlPercent >= 0 ? '+' : ''}${unrealizedPnlPercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: pnlColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade700, height: 1),
          const SizedBox(height: 8),
          
          // Risk metrics
          _buildMetricRow(
            context,
            'Liq. Price',
            '\$${liquidationPrice.toStringAsFixed(2)}',
            liquidationPrice > 0 ? Colors.orange : Colors.grey,
          ),
          _buildMetricRow(
            context,
            'Collateral',
            '\$${collateral.toStringAsFixed(2)}',
            Colors.white,
          ),
          
          const SizedBox(height: 8),
          
          // Funding
          if (funding != 0)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (funding > 0 ? Colors.red : Colors.green)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: (funding > 0 ? Colors.red : Colors.green)
                      .withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Funding Accrued',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  Text(
                    '${funding >= 0 ? '+' : ''}\$${funding.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: funding > 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
