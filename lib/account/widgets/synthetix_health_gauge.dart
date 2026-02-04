import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class SynthetixHealthGauge extends StatelessWidget {
  const SynthetixHealthGauge({
    required this.collateralRatio,
    required this.debt,
    super.key,
  });

  final BigInt collateralRatio;
  final BigInt debt;

  Color get _statusColor {
    if (debt == BigInt.zero) return Colors.grey;
    final safeRatio = BigInt.from(400) * BigInt.from(10).pow(18);
    final warningRatio = BigInt.from(300) * BigInt.from(10).pow(18);

    if (collateralRatio >= safeRatio) return Colors.green;
    if (collateralRatio >= warningRatio) return Colors.orange;
    return Colors.red;
  }

  String get _statusText {
    if (debt == BigInt.zero) return 'No Debt';
    final safeRatio = BigInt.from(400) * BigInt.from(10).pow(18);
    final warningRatio = BigInt.from(300) * BigInt.from(10).pow(18);

    if (collateralRatio >= safeRatio) return 'Healthy';
    if (collateralRatio >= warningRatio) return 'Warning';
    return 'At Risk';
  }

  double get _gaugeProgress {
    if (debt == BigInt.zero) return 1.0;
    // Target is 400%, warning is 300%
    // 0-300% = 0, 300-400% = 0-1, 400%+ = 1
    final ratio = collateralRatio.toDouble() /
        (BigInt.from(10).pow(18).toDouble());
    if (ratio <= 300) return 0;
    if (ratio >= 400) return 1;
    return (ratio - 300) / 100;
  }

  String _formatCRatio(BigInt ratio) {
    if (ratio == BigInt.zero) return 'N/A';
    final value = ratio.toDouble() / BigInt.from(10).pow(18).toDouble();
    return '${value.toStringAsFixed(0)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Status badge and title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Account Health',
                style: textStyle(
                  Colors.white,
                  14,
                  isBold: true,
                  isUline: false,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _statusColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  _statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Gauge visualization
          if (debt > BigInt.zero) ...[
            SizedBox(
              height: 120,
              child: CustomPaint(
                painter: _GaugePainter(
                  progress: _gaugeProgress,
                  statusColor: _statusColor,
                ),
                size: Size.fromHeight(120),
              ),
            ),
            const SizedBox(height: 20),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 48,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No Debt',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          // C-ratio and target info
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current C-Ratio',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCRatio(collateralRatio),
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Target Range',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '300% - 400%',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color statusColor;

  _GaugePainter({
    required this.progress,
    required this.statusColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 12.0;
    const startAngle = 0.5;
    const sweepAngle = 3.14159; // 180 degrees in radians

    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.6),
        width: size.width * 0.6,
        height: size.height * 0.6,
      ),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..color = statusColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.6),
        width: size.width * 0.6,
        height: size.height * 0.6,
      ),
      startAngle,
      sweepAngle * progress,
      false,
      progressPaint,
    );

    // Center text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toStringAsFixed(0)}%',
        style: TextStyle(
          color: statusColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height * 0.4,
      ),
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.statusColor != statusColor;
  }
}
