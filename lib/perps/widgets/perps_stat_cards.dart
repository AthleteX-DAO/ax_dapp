import 'package:flutter/material.dart';

/// Displays quick stat cards showing key market and account metrics
/// Updates in real-time and on-demand based on data frequency
class PerpStatCards extends StatelessWidget {
  const PerpStatCards({
    super.key,
    required this.price,
    required this.pnlPercent,
    required this.fundingRate,
    required this.marketSkewPercent,
    required this.openInterest,
    required this.availableMargin,
    this.isLoading = false,
  });

  /// Current oracle price
  final double price;

  /// User's P&L as percentage
  final double pnlPercent;

  /// Current funding rate (per hour or per period)
  final double fundingRate;

  /// Market skew as percentage (0-100, where 50 is balanced)
  final double marketSkewPercent;

  /// Current open interest in market
  final double openInterest;

  /// User's available margin for new trades
  final double availableMargin;

  /// Whether data is loading
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard(
            context,
            title: 'Price',
            value: '\$${price.toStringAsFixed(2)}',
            subtitle: 'BTC/USD',
            icon: Icons.trending_up,
            isLoading: isLoading,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            context,
            title: 'Your P&L',
            value: '${pnlPercent.toStringAsFixed(2)}%',
            subtitle: 'Unrealized',
            icon: Icons.show_chart,
            isLoading: isLoading,
            color: pnlPercent >= 0 ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            context,
            title: 'Funding Rate',
            value: '${(fundingRate * 100).toStringAsFixed(3)}%',
            subtitle: 'Per 8 hours',
            icon: Icons.paid,
            isLoading: isLoading,
            color: fundingRate >= 0 ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            context,
            title: 'Market Skew',
            value: '${marketSkewPercent.toStringAsFixed(1)}%',
            subtitle: 'Long / Short',
            icon: Icons.balance,
            isLoading: isLoading,
            color: _getSkewColor(marketSkewPercent),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            context,
            title: 'Open Interest',
            value: '\$${_formatLargeNumber(openInterest)}',
            subtitle: 'Total OI',
            icon: Icons.shopping_cart,
            isLoading: isLoading,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            context,
            title: 'Available Margin',
            value: '\$${availableMargin.toStringAsFixed(2)}',
            subtitle: 'For new trades',
            icon: Icons.account_balance,
            isLoading: isLoading,
            color: availableMargin > 0 ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required bool isLoading,
    Color? color,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Icon(
                      icon,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color ?? Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
    );
  }

  /// Format large numbers with K, M, B suffixes
  String _formatLargeNumber(double number) {
    if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(2);
  }

  /// Get color based on market skew
  Color _getSkewColor(double skewPercent) {
    final distance = (skewPercent - 50).abs();
    if (distance < 10) return Colors.grey; // Balanced
    if (skewPercent > 50) return Colors.green; // More longs
    return Colors.red; // More shorts
  }
}
