import 'package:flutter/material.dart';

class SmartContextualAlerts extends StatelessWidget {
  const SmartContextualAlerts({
    required this.collateralRatio,
    required this.collateralAvailable,
    required this.debt,
    required this.onDepositTapped,
    required this.onWithdrawTapped,
    super.key,
  });

  final BigInt collateralRatio;
  final BigInt collateralAvailable;
  final BigInt debt;
  final VoidCallback onDepositTapped;
  final VoidCallback onWithdrawTapped;

  List<_Alert> _buildAlerts() {
    final alerts = <_Alert>[];

    // Collateral ratio alerts — three tiers:
    //   danger  : < 200%  → liquidation imminent  (severity 3)
    //   at-risk : < 300%  → approaching threshold (severity 2)
    //   warning : < 400%  → below target          (severity 1)
    if (debt > BigInt.zero) {
      final e18 = BigInt.from(10).pow(18);
      final dangerRatio  = BigInt.from(200) * e18; // 200% — liquidation risk
      final warningRatio = BigInt.from(300) * e18; // 300% — approaching limit
      final safeRatio    = BigInt.from(400) * e18; // 400% — target

      if (collateralRatio < safeRatio) {
        final ratioValue =
            collateralRatio.toDouble() / e18.toDouble();

        if (collateralRatio < dangerRatio) {
          // ❗ Liquidation imminent
          alerts.add(
            _Alert(
              type: _AlertType.danger,
              icon: Icons.emergency_rounded,
              title: '⚠️ Liquidation Risk!',
              description:
                  'C-ratio ${ratioValue.toStringAsFixed(0)}% is below the '
                  '200% danger threshold. Add collateral immediately to avoid '
                  'liquidation.',
              actionLabel: 'Add Collateral',
              severity: 3,
            ),
          );
        } else if (collateralRatio < warningRatio) {
          // 🔴 Below 300% — approaching liquidation
          alerts.add(
            _Alert(
              type: _AlertType.warning,
              icon: Icons.warning_rounded,
              title: 'Collateral Ratio Critical',
              description:
                  'Current: ${ratioValue.toStringAsFixed(0)}% — '
                  'below 300% threshold. Deposit more to stay safe.',
              actionLabel: 'Deposit More',
              severity: 2,
            ),
          );
        } else {
          // 🟠 Below 400% target
          alerts.add(
            _Alert(
              type: _AlertType.warning,
              icon: Icons.trending_down,
              title: 'Low Collateral Ratio',
              description:
                  'Current: ${ratioValue.toStringAsFixed(0)}% (Target: 400%)',
              actionLabel: 'Deposit More',
              severity: 1,
            ),
          );
        }
      }
    }

    // Available to withdraw alert
    if (collateralAvailable > BigInt.zero) {
      final availableValue = collateralAvailable.toDouble() /
          BigInt.from(10).pow(18).toDouble();
      alerts.add(
        _Alert(
          type: _AlertType.info,
          icon: Icons.arrow_circle_down,
          title: 'Available to Withdraw',
          description: '\$${availableValue.toStringAsFixed(2)} ready',
          actionLabel: 'Withdraw',
          severity: 0,
        ),
      );
    }

    // Sort by severity (high to low)
    alerts.sort((a, b) => b.severity.compareTo(a.severity));

    return alerts;
  }

  @override
  Widget build(BuildContext context) {
    final alerts = _buildAlerts();

    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        ...alerts.asMap().entries.map((entry) {
          final index = entry.key;
          final alert = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index < alerts.length - 1 ? 12 : 0),
            child: _AlertCard(
              alert: alert,
              onAction: () {
                if (alert.actionLabel == 'Deposit More' ||
                    alert.actionLabel == 'Add Collateral') {
                  onDepositTapped();
                } else if (alert.actionLabel == 'Withdraw') {
                  onWithdrawTapped();
                }
              },
            ),
          );
        }),
      ],
    );
  }
}

enum _AlertType { danger, warning, info, success }

class _Alert { // 0-3, higher = more severe

  _Alert({
    required this.type,
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.severity,
  });
  final _AlertType type;
  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final int severity;

  Color get backgroundColor {
    switch (type) {
      case _AlertType.danger:
        return Colors.red.withOpacity(0.18);
      case _AlertType.warning:
        return severity >= 2
            ? Colors.red.withOpacity(0.15)
            : Colors.orange.withOpacity(0.15);
      case _AlertType.info:
        return Colors.blue.withOpacity(0.15);
      case _AlertType.success:
        return Colors.green.withOpacity(0.15);
    }
  }

  Color get borderColor {
    switch (type) {
      case _AlertType.danger:
        return Colors.red.withOpacity(0.7);
      case _AlertType.warning:
        return severity >= 2
            ? Colors.red.withOpacity(0.4)
            : Colors.orange.withOpacity(0.4);
      case _AlertType.info:
        return Colors.blue.withOpacity(0.4);
      case _AlertType.success:
        return Colors.green.withOpacity(0.4);
    }
  }

  Color get iconColor {
    switch (type) {
      case _AlertType.danger:
        return Colors.red[300]!;
      case _AlertType.warning:
        return severity >= 2 ? Colors.red : Colors.orange;
      case _AlertType.info:
        return Colors.blue;
      case _AlertType.success:
        return Colors.green;
    }
  }
}

class _AlertCard extends StatefulWidget {
  const _AlertCard({
    required this.alert,
    required this.onAction,
  });

  final _Alert alert;
  final VoidCallback onAction;

  @override
  State<_AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<_AlertCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    if (widget.alert.severity >= 2) {
      // Pulse animation for critical/danger alerts
      _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      )..repeat();
    } else {
      _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: widget.alert.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.alert.borderColor,
              width: 1.5,
            ),
            boxShadow: widget.alert.severity >= 2
                ? [
                    BoxShadow(
                      color: widget.alert.iconColor.withOpacity(0.2),
                      blurRadius: 8 + (_pulseController.value * 4),
                      spreadRadius: _pulseController.value * 2,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.alert.iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.alert.icon,
                  color: widget.alert.iconColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.alert.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.alert.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.alert.iconColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: widget.onAction,
                child: Text(
                  widget.alert.actionLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
