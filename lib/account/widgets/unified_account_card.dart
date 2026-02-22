import 'dart:math' as math;

import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/widgets/account_assets_filter.dart';
import 'package:ax_dapp/account/widgets/account_assets_list.dart';
import 'package:ax_dapp/account/widgets/smart_contextual_alerts.dart';
import 'package:ax_dapp/account/widgets/synthetix_health_gauge.dart';
import 'package:ax_dapp/service/controller/earn/vault_repository.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnifiedAccountCard extends StatefulWidget {
  const UnifiedAccountCard({
    required this.accountId,
    required this.collateralDeposited,
    required this.collateralAssigned,
    required this.collateralAvailable,
    required this.debt,
    required this.collateralRatio,
    required this.isSynthetixLoading,
    required this.vaults,
    required this.isVaultsLoading,
    required this.vaultsError,
    required this.onCreateAccount,
    required this.onViewSpotPositions,
    required this.onViewPerpsPositions,
    required this.onViewPredictionPositions,
    required this.onViewVaultYields,
    this.axUsdBalance,
    super.key,
  });

  final int accountId;
  final BigInt collateralDeposited;
  final BigInt collateralAssigned;
  final BigInt collateralAvailable;
  final BigInt debt;
  final BigInt collateralRatio;
  final bool isSynthetixLoading;
  final List<VaultData> vaults;
  final bool isVaultsLoading;
  final String? vaultsError;
  final VoidCallback onCreateAccount;
  final VoidCallback onViewSpotPositions;
  final VoidCallback onViewPerpsPositions;
  final VoidCallback onViewPredictionPositions;
  final VoidCallback onViewVaultYields;
  /// axUSD balance held in the user's wallet (18-decimal BigInt).
  final BigInt? axUsdBalance;

  @override
  State<UnifiedAccountCard> createState() => _UnifiedAccountCardState();
}

enum _OverviewTab { health, assets, positions }

class _UnifiedAccountCardState extends State<UnifiedAccountCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  bool _isExpanded = false;
  _OverviewTab _selectedTab = _OverviewTab.health;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Color get _healthColor {
    if (widget.debt == BigInt.zero) return Colors.white38;
    final safeRatio = BigInt.from(400) * BigInt.from(10).pow(18);
    final warningRatio = BigInt.from(300) * BigInt.from(10).pow(18);

    if (widget.collateralRatio >= safeRatio) return Colors.green;
    if (widget.collateralRatio >= warningRatio) return Colors.orange;
    return Colors.redAccent;
  }

  String get _healthText {
    if (widget.debt == BigInt.zero) return 'No Debt';
    final safeRatio = BigInt.from(400) * BigInt.from(10).pow(18);
    final warningRatio = BigInt.from(300) * BigInt.from(10).pow(18);

    if (widget.collateralRatio >= safeRatio) return 'Healthy';
    if (widget.collateralRatio >= warningRatio) return 'Warning';
    return 'At Risk';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSynthetixLoading) {
      return _buildLoadingCard();
    }

    if (widget.accountId == 0) {
      return _buildCreateAccountCard();
    }

    return DecoratedBox(
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
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Overview',
                            style: textStyle(
                              Colors.white,
                              16,
                              isBold: true,
                              isUline: false,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AthleteX Account #${widget.accountId}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _healthColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _healthColor.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              _healthText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _healthColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _isExpanded
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                            color: Colors.white70,
                            size: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildQuickStat(
                        'Collateral',
                        _formatCurrency(widget.collateralDeposited),
                        Icons.account_balance_wallet_rounded,
                      ),
                      const SizedBox(width: 16),
                      _buildQuickStat(
                        'Debt',
                        _formatCurrency(widget.debt),
                        Icons.trending_down_rounded,
                      ),
                      const SizedBox(width: 16),
                      _buildQuickStat(
                        'C-Ratio',
                        _formatCRatio(widget.collateralRatio),
                        Icons.pie_chart_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to see ${_isExpanded ? 'less' : 'details & assets'}',
                    style: const TextStyle(
                      color: Colors.white30,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(color: Colors.white24, height: 1),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTabSelector(),
                    const SizedBox(height: 20),
                    if (_selectedTab == _OverviewTab.health)
                      _buildHealthTab(),
                    if (_selectedTab == _OverviewTab.assets)
                      _buildAssetsTab(),
                    if (_selectedTab == _OverviewTab.positions)
                      _buildPositionsTab(),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Row(
      children: [
        _buildTabButton('Health', _OverviewTab.health, Icons.favorite_rounded),
        const SizedBox(width: 12),
        _buildTabButton(
          'Assets',
          _OverviewTab.assets,
          Icons.account_balance_wallet_rounded,
        ),
        const SizedBox(width: 12),
        _buildTabButton(
          'Positions & Yields',
          _OverviewTab.positions,
          Icons.layers_rounded,
        ),
      ],
    );
  }

  Widget _buildTabButton(String label, _OverviewTab tab, IconData icon) {
    final isSelected = _selectedTab == tab;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = tab),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryOrangeColor.withOpacity(0.15)
                : Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? primaryOrangeColor.withOpacity(0.5)
                  : Colors.white.withOpacity(0.1),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? primaryOrangeColor : Colors.white54,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? primaryOrangeColor : Colors.white70,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: Colors.white54),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTab() {
    return Column(
      children: [
        SynthetixHealthGauge(
          collateralRatio: widget.collateralRatio,
          debt: widget.debt,
        ),
        const SizedBox(height: 16),
        SmartContextualAlerts(
          collateralRatio: widget.collateralRatio,
          collateralAvailable: widget.collateralAvailable,
          debt: widget.debt,
          onDepositTapped: () {
            context
                .read<AccountBloc>()
                .add(const AccountDepositViewRequested());
          },
        ),
        const SizedBox(height: 16),
        _buildDetailRow(
          'Total Deposited',
          _formatCurrency(widget.collateralDeposited),
          Icons.account_balance_wallet_rounded,
          Colors.white70,
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Delegated to Pools',
          _formatCurrency(widget.collateralAssigned),
          Icons.pie_chart_rounded,
          Colors.blueAccent,
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Available to Withdraw',
          _formatCurrency(widget.collateralAvailable),
          Icons.arrow_circle_down_rounded,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Current Debt',
          _formatCurrency(widget.debt),
          Icons.trending_down_rounded,
          widget.debt > BigInt.zero ? Colors.redAccent : Colors.white54,
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Collateral Ratio',
          _formatCRatio(widget.collateralRatio),
          Icons.trending_up_rounded,
          _healthColor,
        ),
        if ((widget.axUsdBalance ?? BigInt.zero) > BigInt.zero) ...
          _buildAxUsdRow(),
        if ((widget.axUsdBalance ?? BigInt.zero) > BigInt.zero ||
            widget.collateralAssigned > BigInt.zero) ...
          _buildTradingCta(),
      ],
    );
  }

  List<Widget> _buildAxUsdRow() => [
        const SizedBox(height: 12),
        _buildDetailRow(
          'axUSD in Wallet',
          _formatCurrency(widget.axUsdBalance ?? BigInt.zero),
          Icons.attach_money_rounded,
          Colors.greenAccent,
        ),
      ];

  List<Widget> _buildTradingCta() => [
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.onViewSpotPositions,
            icon: const Icon(Icons.swap_horiz_rounded, size: 20),
            label: const Text(
              'Start Trading',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryOrangeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context
                .read<AccountBloc>()
                .add(const AccountWrapViewRequested()),
            icon: const Icon(Icons.currency_exchange_rounded, size: 18),
            label: const Text('Wrap Token → axUSD'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.purpleAccent,
              side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ];

  Widget _buildAssetsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AccountAssetsFilter(),
        SizedBox(
          height: 220,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const WalletAssetsList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPositionsTab() {
    final vaults = widget.vaults;
    final totalTvl = vaults.fold<double>(0, (sum, v) => sum + v.tvl);
    final bestApy = vaults.isEmpty
        ? 0.0
        : vaults.map((v) => v.apy).reduce(math.max);
    final activeVaults = vaults.where((v) => v.balance > 0).length;

    return Column(
      children: [
        _buildSummaryCard(
          title: 'Spot Positions',
          subtitle: 'No open spot positions yet',
          icon: Icons.swap_horiz_rounded,
          ctaLabel: 'View all spot markets',
          onTap: widget.onViewSpotPositions,
        ),
        const SizedBox(height: 12),
        _buildSummaryCard(
          title: 'Perp Positions',
          subtitle: 'No open perp positions yet',
          icon: Icons.show_chart_rounded,
          ctaLabel: 'View perpetuals',
          onTap: widget.onViewPerpsPositions,
        ),
        const SizedBox(height: 12),
        _buildSummaryCard(
          title: 'Prediction Markets',
          subtitle: 'No active predictions yet',
          icon: Icons.sports_basketball_rounded,
          ctaLabel: 'View prediction markets',
          onTap: widget.onViewPredictionPositions,
        ),
        const SizedBox(height: 12),
        _buildSummaryCard(
          title: 'Vault Yields',
          subtitle: widget.isVaultsLoading
              ? 'Loading live yields…'
              : widget.vaultsError != null
                  ? 'Unable to load yields'
                  : 'Top APY ${bestApy.toStringAsFixed(2)}% • TVL ${_formatCompactUsd(totalTvl)}',
          icon: Icons.savings_rounded,
          ctaLabel: 'View all vaults',
          onTap: widget.onViewVaultYields,
          trailing: widget.isVaultsLoading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : _buildMiniBadge(
                  '$activeVaults active',
                  activeVaults > 0 ? Colors.green : Colors.white30,
                ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String ctaLabel,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: Colors.white70),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: Text(ctaLabel),
              style: TextButton.styleFrom(
                foregroundColor: primaryOrangeColor,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountCard() {
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
            padding: const EdgeInsets.all(16),
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
          const Text(
            'Create an account to deposit collateral, earn yield, and access features.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: widget.onCreateAccount,
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text('Create AthleteX Account'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryOrangeColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
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

  Widget _buildLoadingCard() {
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
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  String _formatCurrency(BigInt amount) {
    if (amount == BigInt.zero) return r'$0.00';
    final value = amount.toDouble() / BigInt.from(10).pow(18).toDouble();
    return '\$${value.toStringAsFixed(2)}';
  }

  // Synthetix returns uint256.max (~1.15e77) when there is no debt.
  static final _uint256Max =
      BigInt.parse('115792089237316195423570985008687907853269984665640564039457584007913129639935');
  static final _cRatioSentinel = _uint256Max >> 64; // anything above ~1e58 is sentinel

  String _formatCRatio(BigInt ratio) {
    if (ratio == BigInt.zero) return 'N/A';
    if (ratio >= _cRatioSentinel) return '∞';
    final value = ratio.toDouble() / BigInt.from(10).pow(18).toDouble();
    if (value == 0) return '0%';
    return '${value.toStringAsFixed(1)}%';
  }

  String _formatCompactUsd(double value) {
    if (value >= 1e9) {
      return '\$${(value / 1e9).toStringAsFixed(2)}B';
    }
    if (value >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(2)}M';
    }
    if (value >= 1e3) {
      return '\$${(value / 1e3).toStringAsFixed(1)}K';
    }
    return '\$${value.toStringAsFixed(2)}';
  }
}