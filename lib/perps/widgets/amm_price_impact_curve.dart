import 'package:flutter/material.dart';
import 'dart:math';

/// Displays an interactive price impact curve using Synthetix V3 AMM formula
/// Shows how different trade sizes affect fill price and slippage
class AmmPriceImpactCurve extends StatefulWidget {
  const AmmPriceImpactCurve({
    Key? key,
    required this.currentPrice,
    required this.currentSkew,
    required this.skewScale,
    required this.size,
    required this.onSizeChanged,
    this.isLong = true,
  }) : super(key: key);

  /// Current oracle price
  final double currentPrice;

  /// Current market skew (net position imbalance in USD)
  final double currentSkew;

  /// Skew scale parameter (sensitivity to skew)
  final double skewScale;

  /// Current trade size input
  final double size;

  /// Callback when user adjusts size
  final ValueChanged<double> onSizeChanged;

  /// Whether this is a long or short trade
  final bool isLong;

  @override
  State<AmmPriceImpactCurve> createState() => _AmmPriceImpactCurveState();
}

class _AmmPriceImpactCurveState extends State<AmmPriceImpactCurve> {
  late List<_PriceImpactPoint> _longImpactPoints;
  late List<_PriceImpactPoint> _shortImpactPoints;

  @override
  void initState() {
    super.initState();
    _calculateImpactCurves();
  }

  @override
  void didUpdateWidget(AmmPriceImpactCurve oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentSkew != widget.currentSkew ||
        oldWidget.skewScale != widget.skewScale ||
        oldWidget.currentPrice != widget.currentPrice) {
      _calculateImpactCurves();
    }
  }

  /// Calculate price impact points for trade sizes from 0 to max
  void _calculateImpactCurves() {
    const numPoints = 20;
    final maxSize = widget.skewScale * 0.5; // Max realistic size

    _longImpactPoints = [];
    _shortImpactPoints = [];

    for (int i = 0; i <= numPoints; i++) {
      final tradeSize = (maxSize / numPoints) * i;

      // Calculate impact for long trade
      final longImpact = _calculateFillPrice(
        tradeSize: tradeSize,
        isLong: true,
      );
      _longImpactPoints.add(_PriceImpactPoint(
        size: tradeSize,
        fillPrice: longImpact['fillPrice'] as double,
        slippagePercent: longImpact['slippagePercent'] as double,
      ));

      // Calculate impact for short trade
      final shortImpact = _calculateFillPrice(
        tradeSize: tradeSize,
        isLong: false,
      );
      _shortImpactPoints.add(_PriceImpactPoint(
        size: tradeSize,
        fillPrice: shortImpact['fillPrice'] as double,
        slippagePercent: shortImpact['slippagePercent'] as double,
      ));
    }
  }

  /// Calculate fill price using Synthetix skew-based pricing formula
  /// fillPrice = price × ((1 + pd_before) + (1 + pd_after)) / 2
  /// where pd = skew / skewScale
  Map<String, double> _calculateFillPrice({
    required double tradeSize,
    required bool isLong,
  }) {
    final direction = isLong ? 1.0 : -1.0;

    // Premium/discount before trade
    final pdBefore = widget.currentSkew / widget.skewScale;

    // Premium/discount after trade
    final skewAfter = widget.currentSkew + (direction * tradeSize);
    final pdAfter = skewAfter / widget.skewScale;

    // Average fill price
    final fillPrice =
        widget.currentPrice * ((1 + pdBefore) + (1 + pdAfter)) / 2;

    // Slippage percentage
    final slippagePercent = ((fillPrice - widget.currentPrice) /
            widget.currentPrice *
            100)
        .abs();

    return {
      'fillPrice': fillPrice,
      'slippagePercent': slippagePercent,
    };
  }

  @override
  Widget build(BuildContext context) {
    final impactPoints = widget.isLong ? _longImpactPoints : _shortImpactPoints;

    return Card(
      elevation: 0,
      color: const Color(0xFF1a1a1a),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price Impact Curve',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  widget.isLong ? 'LONG' : 'SHORT',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isLong ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Price impact chart
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: _PriceImpactPainter(
                  points: impactPoints,
                  currentSize: widget.size,
                  isLong: widget.isLong,
                ),
                child: const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 16),
            // Impact data for current size
            if (widget.size > 0) _buildCurrentImpactInfo(impactPoints),
            const SizedBox(height: 12),
            // Size input slider
            _buildSizeSlider(impactPoints),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentImpactInfo(List<_PriceImpactPoint> points) {
    // Find closest point to current size for display
    late _PriceImpactPoint closestPoint;
    double minDiff = double.infinity;

    for (final point in points) {
      final diff = (point.size - widget.size).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestPoint = point;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildInfoCard(
            title: 'Fill Price',
            value: '\$${closestPoint.fillPrice.toStringAsFixed(2)}',
            subtitle: 'at \$${widget.size.toStringAsFixed(0)} size',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            title: 'Slippage',
            value: '${closestPoint.slippagePercent.toStringAsFixed(3)}%',
            subtitle: 'Price impact',
            color: _getSlippageColor(closestPoint.slippagePercent),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String subtitle,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSlider(List<_PriceImpactPoint> points) {
    final maxSize = points.last.size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trade Size: \$${widget.size.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Slider(
          value: widget.size.clamp(0, maxSize),
          max: maxSize,
          divisions: 50,
          label: '\$${widget.size.toStringAsFixed(0)}',
          onChanged: widget.onSizeChanged,
        ),
      ],
    );
  }

  Color _getSlippageColor(double slippagePercent) {
    if (slippagePercent < 0.1) return Colors.green;
    if (slippagePercent < 0.3) return Colors.yellow;
    return Colors.red;
  }
}

/// Data point on the price impact curve
class _PriceImpactPoint {
  _PriceImpactPoint({
    required this.size,
    required this.fillPrice,
    required this.slippagePercent,
  });

  final double size;
  final double fillPrice;
  final double slippagePercent;
}

/// Custom painter for the price impact curve
class _PriceImpactPainter extends CustomPainter {
  _PriceImpactPainter({
    required this.points,
    required this.currentSize,
    required this.isLong,
  });

  final List<_PriceImpactPoint> points;
  final double currentSize;
  final bool isLong;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = isLong ? Colors.green : Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = isLong ? Colors.green : Colors.red
      ..style = PaintingStyle.fill;

    final currentPointPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Calculate bounds
    final maxSize = points.last.size;
    final minPrice = points.map((p) => p.fillPrice).reduce(min);
    final maxPrice = points.map((p) => p.fillPrice).reduce(max);
    final priceRange = maxPrice - minPrice;

    // Draw grid lines
    _drawGridLines(canvas, size, maxSize, minPrice, maxPrice, priceRange);

    // Draw curve
    Path path = Path();
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final x = (point.size / maxSize) * size.width;
      final y = size.height -
          ((point.fillPrice - minPrice) / priceRange) * (size.height - 20);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw points
    for (final point in points) {
      final x = (point.size / maxSize) * size.width;
      final y = size.height -
          ((point.fillPrice - minPrice) / priceRange) * (size.height - 20);
      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }

    // Draw current size indicator
    if (currentSize > 0 && currentSize <= maxSize) {
      final closestPoint = points.reduce((a, b) =>
          (a.size - currentSize).abs() < (b.size - currentSize).abs() ? a : b);
      final x = (closestPoint.size / maxSize) * size.width;
      final y = size.height -
          ((closestPoint.fillPrice - minPrice) / priceRange) *
              (size.height - 20);
      canvas.drawCircle(Offset(x, y), 5, currentPointPaint);
    }

    // Draw axes
    final axisPaint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height),
        axisPaint);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), axisPaint);
  }

  void _drawGridLines(
    Canvas canvas,
    Size size,
    double maxSize,
    double minPrice,
    double maxPrice,
    double priceRange,
  ) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 0.5;

    // Vertical grid lines
    for (int i = 0; i <= 4; i++) {
      final x = (size.width / 4) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(_PriceImpactPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.currentSize != currentSize;
  }
}
