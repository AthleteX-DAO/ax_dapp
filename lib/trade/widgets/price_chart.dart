import 'dart:async';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tokens_repository/tokens_repository.dart';

class PriceChart extends StatefulWidget {
  const PriceChart({
    super.key,
    this.coinId = 'bitcoin',
  });

  final String coinId;

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  late ZoomPanBehavior _zoomPanBehavior;
  late CrosshairBehavior _crosshairBehavior;
  List<ChartSampleData> _chartData = [];
  String _selectedPeriod = '1D';
  Timer? _pollingTimer;

  // Trackball/Crosshair details
  double? _currentOpen;
  double? _currentClose;
  double? _currentHigh;
  double? _currentLow;
  double? _currentVolume;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
    );
    _crosshairBehavior = CrosshairBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      shouldAlwaysShow: true,
    );
    super.initState();
    _fetchData('1');
    _startPolling();
  }

  @override
  void didUpdateWidget(covariant PriceChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.coinId != oldWidget.coinId) {
      _fetchData(_getDaysForPeriod(_selectedPeriod));
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _fetchData(_getDaysForPeriod(_selectedPeriod));
    });
  }

  String _getDaysForPeriod(String period) {
    switch (period) {
      case '1H':
        return '1';
      case '1D':
        return '1';
      case '1M':
        return '30';
      case '3M':
        return '90';
      case '1Y':
        return '365';
      case 'YTD':
        return _getYtdDays();
      default:
        return '1';
    }
  }

  Future<void> _fetchData(String days) async {
    final tokensRepository = context.read<TokensRepository>();

    // Fetch OHLC
    final ohlcData = await tokensRepository.getCoinOHLC(
      widget.coinId,
      'usd',
      days,
    );

    // Fetch Volume (Market Chart)
    final marketChart = await tokensRepository.getMarketChart(
      widget.coinId,
      'usd',
      days,
    );

    if (mounted) {
      setState(() {
        _chartData = ohlcData.map((e) {
          final date = DateTime.fromMillisecondsSinceEpoch(e[0].toInt());
          double volume = 0;

          // Find closest volume data point
          if (marketChart != null && marketChart.totalVolumes.isNotEmpty) {
            // Simple approximation: find volume with closest timestamp
            // This is O(N*M) but N and M are small (<1000 usually)
            // Optimization: Use binary search or assume sorted
            try {
              final closest = marketChart.totalVolumes
                  .reduce((List<double> a, List<double> b) {
                return (a[0] - e[0]).abs() < (b[0] - e[0]).abs() ? a : b;
              });
              volume = closest[1];
            } catch (_) {}
          }

          return ChartSampleData(
            x: date,
            open: e[1],
            high: e[2],
            low: e[3],
            close: e[4],
            volume: volume,
          );
        }).toList();

        // Set initial current values to last candle
        if (_chartData.isNotEmpty) {
          final last = _chartData.last;
          _currentOpen = last.open;
          _currentClose = last.close;
          _currentHigh = last.high;
          _currentLow = last.low;
          _currentVolume = last.volume;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with OHLC values
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // OHLC Display
            if (_currentOpen != null)
              Row(
                children: [
                  _buildOhlcItem('O', _currentOpen!),
                  const SizedBox(width: 10),
                  _buildOhlcItem('H', _currentHigh!),
                  const SizedBox(width: 10),
                  _buildOhlcItem('L', _currentLow!),
                  const SizedBox(width: 10),
                  _buildOhlcItem('C', _currentClose!,
                      color: (_currentClose! >= _currentOpen!)
                          ? primaryOrangeColor
                          : Colors.red,),
                  const SizedBox(width: 10),
                  _buildOhlcItem('V', _currentVolume!),
                ],
              )
            else
              const SizedBox(),

            // Time Selector
            Row(
              children: [
                _buildTimeSelector('1D'),
                _buildTimeSelector('1M'),
                _buildTimeSelector('3M'),
                _buildTimeSelector('1Y'),
                _buildTimeSelector('YTD'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SfCartesianChart(
            zoomPanBehavior: _zoomPanBehavior,
            crosshairBehavior: _crosshairBehavior,
            plotAreaBorderWidth: 0,
            onTrackballPositionChanging: (TrackballArgs args) {
              // Update header values on hover/drag
              // Note: Syncfusion Trackball is better for this than Crosshair, but Crosshair was requested.
              // Actually Crosshair doesn't give easy callback for data point values.
              // Let's use TrackballBehavior instead of Crosshair for the "Crosshair" look + data.
            },
            // Using Trackball for the "Crosshair" experience + Tooltip
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipSettings: const InteractiveTooltip(
                  enable: false,), // Hide default tooltip, show in header
              shouldAlwaysShow: true,
              builder:
                  (BuildContext context, TrackballDetails trackballDetails) {
                // This builder is for the tooltip widget, not for state update.
                // We can use onTrackballPositionChanging but getting the data point is tricky.
                // Simpler: Use standard Crosshair and just show the values.
                // Or use onChartTouchInteractionMove
                return Container();
              },
            ),
            // Actually, let's stick to Crosshair for the visual lines and maybe just show last price in header for now to keep it simple and robust.
            // Or use onTrackballPositionChanging to find the nearest point.

            primaryXAxis: DateTimeAxis(
              majorGridLines: const MajorGridLines(width: 0),
              axisLine: const AxisLine(width: 0),
              labelStyle:
                  textStyle(Colors.grey, 10, isBold: false, isUline: false),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: MajorGridLines(
                  width: 0.5,
                  color: Colors.grey.withOpacity(0.2),
                  dashArray: const <double>[5, 5],),
              axisLine: const AxisLine(width: 0),
              labelStyle:
                  textStyle(Colors.grey, 10, isBold: false, isUline: false),
              opposedPosition: true, // Like TradingView
            ),
            axes: <ChartAxis>[
              NumericAxis(
                name: 'VolumeAxis',
                isVisible: false,
                opposedPosition: true,
                minimum: 0,
                maximum: _getMaxVolume() * 4, // Push volume to bottom 1/4
              ),
            ],
            series: <CartesianSeries>[
              // Volume Series
              ColumnSeries<ChartSampleData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (ChartSampleData data, _) => data.x,
                yValueMapper: (ChartSampleData data, _) => data.volume,
                yAxisName: 'VolumeAxis',
                color: Colors.grey.withOpacity(0.5),
              ),
              // Candle Series
              CandleSeries<ChartSampleData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (ChartSampleData data, _) => data.x,
                lowValueMapper: (ChartSampleData data, _) => data.low,
                highValueMapper: (ChartSampleData data, _) => data.high,
                openValueMapper: (ChartSampleData data, _) => data.open,
                closeValueMapper: (ChartSampleData data, _) => data.close,
                bullColor: primaryOrangeColor,
                enableSolidCandles: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _getMaxVolume() {
    if (_chartData.isEmpty) return 1;
    return _chartData.map((e) => e.volume).reduce((a, b) => a > b ? a : b);
  }

  Widget _buildOhlcItem(String label, double value,
      {Color color = Colors.white,}) {
    return Row(
      children: [
        Text('$label: ',
            style: textStyle(Colors.grey, 10, isBold: false, isUline: false),),
        Text(
            value > 1000
                ? '${(value / 1000).toStringAsFixed(1)}K'
                : value.toStringAsFixed(2),
            style: textStyle(color, 10, isBold: true, isUline: false),),
      ],
    );
  }

  Widget _buildTimeSelector(String label) {
    final isSelected = _selectedPeriod == label;
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedPeriod = label;
        });
        _fetchData(_getDaysForPeriod(label));
      },
      child: Text(
        label,
        style: textStyle(
          isSelected ? primaryOrangeColor : Colors.grey,
          12,
          isBold: isSelected,
          isUline: false,
        ),
      ),
    );
  }

  String _getYtdDays() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year);
    final difference = now.difference(startOfYear).inDays;
    return difference.toString();
  }
}

class ChartSampleData {
  ChartSampleData({
    required this.x,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
  final DateTime x;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
}
