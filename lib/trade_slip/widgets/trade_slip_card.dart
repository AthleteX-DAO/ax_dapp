import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/trade_slip/models/trade_slip_data.dart';
import 'package:flutter/material.dart';

/// Premium branded trade slip card.
///
/// Renders a dark card with gold accents showing trade details.
/// Designed to be captured as PNG via [RepaintBoundary] for sharing.
///
/// Works for prediction markets (YES/NO + odds + payout) and
/// spot markets (BUY/SELL + price + quantity).
class TradeSlipCard extends StatelessWidget {
  const TradeSlipCard({
    required this.slip,
    this.isCompact = false,
    super.key,
  });

  /// The trade data to display.
  final TradeSlipData slip;

  /// When true, uses a condensed single-row layout (for portfolio).
  final bool isCompact;

  // ── Design tokens ─────────────────────────────────────────────
  static const Color _cardBg = Color(0xFF0D0D0D);
  static const Color _yesColor = Color(0xFF3ABD4A);
  static const Color _noColor = Color(0xFFEC2131);
  static const Color _buyColor = Color(0xFFFFD700);
  static const Color _sellColor = Color(0xFFEC2131);
  static const Color _payoutColor = Color(0xFFFFD700);
  static const Color _labelColor = Color(0xB3FFFFFF); // white 70%
  static const Color _mutedColor = Color(0x99FFFFFF); // white 60%
  static const String _fontFamily = 'OpenSans';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: GoldTheme.gold.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: GoldTheme.gold.withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBrandBar(),
            const SizedBox(height: 20),
            _buildMarketSection(),
            const SizedBox(height: 20),
            _buildDetailsSection(),
            const SizedBox(height: 16),
            _buildHighlightRow(),
            if (slip.unrealizedPnl != null) ...[
              const SizedBox(height: 12),
              _buildPnlRow(),
            ],
            const SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ── Brand bar ─────────────────────────────────────────────────

  Widget _buildBrandBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'AthleteX',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: GoldTheme.gold,
            fontFamily: _fontFamily,
            letterSpacing: 0.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: GoldTheme.gold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: GoldTheme.gold.withOpacity(0.4),
            ),
          ),
          child: Text(
            _slipTypeLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: GoldTheme.gold,
              fontFamily: _fontFamily,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  String get _slipTypeLabel {
    switch (slip.type) {
      case SlipType.prediction:
        return 'PREDICTION';
      case SlipType.spot:
        return 'SPOT TRADE';
      case SlipType.perp:
        return 'PERPETUAL';
    }
  }

  // ── Market section ────────────────────────────────────────────

  Widget _buildMarketSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: GoldTheme.panel(radius: 14),
      child: Column(
        children: [
          Text(
            slip.marketName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: _fontFamily,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          _buildSideBadge(),
        ],
      ),
    );
  }

  Widget _buildSideBadge() {
    final label = _sideLabel;
    final color = _sideColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: color,
          fontFamily: _fontFamily,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  String get _sideLabel {
    switch (slip.side) {
      case SlipSide.yes:
        return '▲ YES';
      case SlipSide.no:
        return '▼ NO';
      case SlipSide.buy:
        return '▲ BUY';
      case SlipSide.sell:
        return '▼ SELL';
    }
  }

  Color get _sideColor {
    switch (slip.side) {
      case SlipSide.yes:
        return _yesColor;
      case SlipSide.no:
        return _noColor;
      case SlipSide.buy:
        return _buyColor;
      case SlipSide.sell:
        return _sellColor;
    }
  }

  // ── Details section ───────────────────────────────────────────

  Widget _buildDetailsSection() {
    if (slip.type == SlipType.prediction) {
      return _buildPredictionDetails();
    }
    return _buildSpotDetails();
  }

  Widget _buildPredictionDetails() {
    return Row(
      children: [
        Expanded(
          child: _DetailCell(
            label: 'Odds',
            value: slip.price.toStringAsFixed(2),
            valueColor: _payoutColor,
          ),
        ),
        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
        Expanded(
          child: _DetailCell(
            label: 'Amount',
            value: '\$${slip.amount.toStringAsFixed(2)}',
            suffix: 'axUSD',
          ),
        ),
      ],
    );
  }

  Widget _buildSpotDetails() {
    return Row(
      children: [
        Expanded(
          child: _DetailCell(
            label: 'Entry Price',
            value: '\$${slip.price.toStringAsFixed(4)}',
            valueColor: _labelColor,
          ),
        ),
        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
        Expanded(
          child: _DetailCell(
            label: 'Quantity',
            value: _formatQuantity(slip.quantity ?? 0),
            suffix: _extractSymbol(slip.marketName),
          ),
        ),
      ],
    );
  }

  // ── Highlight row (payout / total) ────────────────────────────

  Widget _buildHighlightRow() {
    final label =
        slip.type == SlipType.prediction ? 'Potential Payout' : 'Total';
    final value = slip.type == SlipType.prediction
        ? '\$${(slip.potentialPayout ?? 0).toStringAsFixed(2)}'
        : '\$${slip.amount.toStringAsFixed(2)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: GoldTheme.goldPanel(radius: 12),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _mutedColor,
              fontFamily: _fontFamily,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: _payoutColor,
              fontFamily: _fontFamily,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── P/L row (for live tickets) ────────────────────────────────

  Widget _buildPnlRow() {
    final pnl = slip.unrealizedPnl ?? 0;
    final isPositive = pnl >= 0;
    final pnlColor = isPositive ? _yesColor : _noColor;
    final pnlPercent = slip.price > 0
        ? ((slip.currentPrice ?? slip.price) - slip.price) / slip.price * 100
        : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: pnlColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: pnlColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: pnlColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            '${isPositive ? "+" : ""}\$${pnl.toStringAsFixed(2)} '
            '(${isPositive ? "+" : ""}${pnlPercent.toStringAsFixed(1)}%)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: pnlColor,
              fontFamily: _fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────

  Widget _buildFooter() {
    final dateStr = _formatDate(slip.timestamp);
    final txStr = slip.txHash != null && slip.txHash!.length > 12
        ? '${slip.txHash!.substring(0, 8)}...${slip.txHash!.substring(slip.txHash!.length - 4)}'
        : slip.txHash ?? '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            '$dateStr${txStr.isNotEmpty ? " · $txStr" : ""}',
            style: const TextStyle(
              fontSize: 10,
              color: _mutedColor,
              fontFamily: 'monospace',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _StatusDot(status: slip.status),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} $h:$min $amPm';
  }

  String _formatQuantity(double q) {
    if (q >= 1000) return '${(q / 1000).toStringAsFixed(1)}K';
    if (q >= 1) return q.toStringAsFixed(2);
    return q.toStringAsFixed(4);
  }

  String _extractSymbol(String marketName) {
    // "AX/axUSD" → "AX"
    final slash = marketName.indexOf('/');
    if (slash > 0) return marketName.substring(0, slash);
    return '';
  }
}

// ─────────────────────────────────────────────────────────────────────
// Internal widgets
// ─────────────────────────────────────────────────────────────────────

class _DetailCell extends StatelessWidget {
  const _DetailCell({
    required this.label,
    required this.value,
    this.valueColor,
    this.suffix,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0x99FFFFFF),
            fontFamily: 'OpenSans',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: valueColor ?? Colors.white,
            fontFamily: 'OpenSans',
          ),
        ),
        if (suffix != null) ...[
          const SizedBox(height: 2),
          Text(
            suffix!,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0x80FFFFFF),
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final SlipStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;
    final label = _statusLabel;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
            fontFamily: 'OpenSans',
          ),
        ),
      ],
    );
  }

  Color get _statusColor {
    switch (status) {
      case SlipStatus.pending:
        return const Color(0xFFFFC600);
      case SlipStatus.confirmed:
        return const Color(0xFF3ABD4A);
      case SlipStatus.failed:
        return const Color(0xFFEC2131);
      case SlipStatus.settled:
        return const Color(0xFF6C7BFF);
    }
  }

  String get _statusLabel {
    switch (status) {
      case SlipStatus.pending:
        return 'Pending';
      case SlipStatus.confirmed:
        return 'Confirmed';
      case SlipStatus.failed:
        return 'Failed';
      case SlipStatus.settled:
        return 'Settled';
    }
  }
}
