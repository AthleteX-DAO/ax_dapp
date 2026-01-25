import 'package:flutter/material.dart';

/// Displays Synthetix V3 account information including collateral, debt, and c-ratio
class SynthetixAccountInfo extends StatelessWidget {
  const SynthetixAccountInfo({
    required this.accountId,
    required this.collateralDeposited,
    required this.collateralAssigned,
    required this.collateralAvailable,
    required this.debt,
    required this.collateralRatio,
    required this.isLoading,
    required this.onCreateAccount,
    super.key,
  });

  final int accountId;
  final BigInt collateralDeposited;
  final BigInt collateralAssigned;
  final BigInt collateralAvailable;
  final BigInt debt;
  final BigInt collateralRatio; // 18 decimals
  final bool isLoading;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (accountId == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No Synthetix Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create a Synthetix account to deposit collateral, earn yield, and access protocol features.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onCreateAccount,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Create Synthetix Account'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Synthetix Account #$accountId',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildHealthBadge(),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Total Deposited',
              _formatCollateral(collateralDeposited),
              Icons.account_balance_wallet,
            ),
            const Divider(height: 20),
            _buildInfoRow(
              'Delegated to Pools',
              _formatCollateral(collateralAssigned),
              Icons.pie_chart,
            ),
            const Divider(height: 20),
            _buildInfoRow(
              'Available to Withdraw',
              _formatCollateral(collateralAvailable),
              Icons.arrow_circle_down,
              color: Colors.green,
            ),
            const Divider(height: 20),
            _buildInfoRow(
              'Current Debt',
              _formatDebt(debt),
              Icons.monetization_on,
              color: debt > BigInt.zero ? Colors.red : Colors.grey,
            ),
            const Divider(height: 20),
            _buildInfoRow(
              'Collateral Ratio',
              _formatCRatio(collateralRatio),
              Icons.trending_up,
              color: _getCRatioColor(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color ?? Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthBadge() {
    if (debt == BigInt.zero) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'No Debt',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      );
    }

    // C-ratio thresholds (18 decimals)
    final safeRatio = BigInt.from(400) * BigInt.from(10).pow(18); // 400%
    final warningRatio = BigInt.from(300) * BigInt.from(10).pow(18); // 300%

    Color badgeColor;
    String badgeText;

    if (collateralRatio >= safeRatio) {
      badgeColor = Colors.green;
      badgeText = 'Healthy';
    } else if (collateralRatio >= warningRatio) {
      badgeColor = Colors.orange;
      badgeText = 'Warning';
    } else {
      badgeColor = Colors.red;
      badgeText = 'At Risk';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badgeText,
        style: TextStyle(fontSize: 12, color: badgeColor),
      ),
    );
  }

  Color _getCRatioColor() {
    if (debt == BigInt.zero) return Colors.grey;

    final safeRatio = BigInt.from(400) * BigInt.from(10).pow(18);
    final warningRatio = BigInt.from(300) * BigInt.from(10).pow(18);

    if (collateralRatio >= safeRatio) return Colors.green;
    if (collateralRatio >= warningRatio) return Colors.orange;
    return Colors.red;
  }

  String _formatCollateral(BigInt amount) {
    if (amount == BigInt.zero) return r'$0.00';
    // Assuming 18 decimals
    final value = amount.toDouble() / BigInt.from(10).pow(18).toDouble();
    return '\$${value.toStringAsFixed(2)}';
  }

  String _formatDebt(BigInt amount) {
    if (amount == BigInt.zero) return r'$0.00';
    // Debt is in sUSD (18 decimals)
    final value = amount.toDouble() / BigInt.from(10).pow(18).toDouble();
    return '\$${value.toStringAsFixed(2)}';
  }

  String _formatCRatio(BigInt ratio) {
    if (ratio == BigInt.zero) return 'N/A';
    // C-ratio has 18 decimals (e.g., 400e18 = 400%)
    final value = ratio.toDouble() / BigInt.from(10).pow(18).toDouble();
    return '${value.toStringAsFixed(0)}%';
  }
}
