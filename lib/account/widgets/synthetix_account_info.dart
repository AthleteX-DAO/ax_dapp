import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
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

  final BigInt accountId;
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
      return Container(
        padding: const EdgeInsets.all(32),
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
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (accountId == BigInt.zero) {
      return Container(
        padding: const EdgeInsets.all(24),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 48,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No AthleteX Account',
              style: textStyle(
                Colors.white,
                18,
                isBold: true,
                isUline: false,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create an AthleteX account to deposit collateral, earn yield, and access features.',
              textAlign: TextAlign.center,
              style: textStyle(
                Colors.white54,
                14,
                isBold: false,
                isUline: false,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onCreateAccount,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create AthleteX Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrangeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AthleteX Account #$accountId',
                style: textStyle(
                  Colors.white,
                  18,
                  isBold: true,
                  isUline: false,
                ),
              ),
              _buildHealthBadge(),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            'Total Deposited',
            _formatCollateral(collateralDeposited),
            Icons.account_balance_wallet,
          ),
          const Divider(color: Colors.white24, height: 24),
          _buildInfoRow(
            'Delegated to Pools',
            _formatCollateral(collateralAssigned),
            Icons.pie_chart,
          ),
          const Divider(color: Colors.white24, height: 24),
          _buildInfoRow(
            'Available to Withdraw',
            _formatCollateral(collateralAvailable),
            Icons.arrow_circle_down,
            color: Colors.green,
          ),
          const Divider(color: Colors.white24, height: 24),
          _buildInfoRow(
            'Current Debt',
            _formatDebt(debt),
            Icons.monetization_on,
            color: debt > BigInt.zero ? Colors.red : Colors.white54,
          ),
          const Divider(color: Colors.white24, height: 24),
        ],
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
            Icon(icon, size: 20, color: color ?? Colors.white54),
            const SizedBox(width: 8),
            Text(
              label,
              style: textStyle(
                Colors.white54,
                14,
                isBold: false,
                isUline: false,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.white,
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
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.4),
          ),
        ),
        child: Text(
          'No Debt',
          style: textStyle(
            Colors.white54,
            12,
            isBold: false,
            isUline: false,
          ),
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
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withOpacity(0.5),
        ),
      ),
      child: Text(
        badgeText,
        style: TextStyle(fontSize: 12, color: badgeColor, fontWeight: FontWeight.w600),
      ),
    );
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
}
