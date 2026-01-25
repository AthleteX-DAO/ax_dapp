import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/prediction/widgets/buttons.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class StatsSide extends StatefulWidget {
  const StatsSide({
    super.key,
    required this.predictionModel,
  });

  final PredictionModel predictionModel;

  @override
  State<StatsSide> createState() => _StatsSideState();
}

class _StatsSideState extends State<StatsSide> {
  bool _isYesSelected = true;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.sizeOf(context).width;
    var wid = _width * 0.4;
    if (_width < 1160) wid = _width * 0.95;

    return Container(
      width: wid,
      padding: const EdgeInsets.all(16),
      decoration: GoldTheme.panel(radius: 24),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Market Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Market Info',
                      style: textStyle(
                        Colors.white,
                        20,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Yes/No toggle
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: GoldTheme.emphasis(radius: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildToggleChip(
                              label: 'Yes',
                              selected: _isYesSelected,
                              onTap: () {
                                setState(() => _isYesSelected = true);
                              }),
                          const SizedBox(width: 8),
                          _buildToggleChip(
                              label: 'No',
                              selected: !_isYesSelected,
                              onTap: () {
                                setState(() => _isYesSelected = false);
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Yes Price',
                          style: textStyle(
                            Colors.white.withOpacity(0.7),
                            14,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                        Text(
                          '${widget.predictionModel.longTokenPrice?.toStringAsFixed(4) ?? '0.00'}',
                          style: textStyle(
                            _isYesSelected ? Colors.white : Colors.white70,
                            14,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'No Price',
                          style: textStyle(
                            Colors.white.withOpacity(0.7),
                            14,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                        Text(
                          '${widget.predictionModel.shortTokenPrice?.toStringAsFixed(4) ?? '0.00'}',
                          style: textStyle(
                            !_isYesSelected ? Colors.white : Colors.white70,
                            14,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Volume',
                          style: textStyle(
                            Colors.white.withOpacity(0.7),
                            14,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                        Text(
                          '${widget.predictionModel.tradingVolume.toStringAsFixed(2)}',
                          style: textStyle(
                            Colors.white,
                            14,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Trade Info Message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryOrangeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryOrangeColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Click "Buy" or "Sell" buttons below to trade',
                    style: textStyle(
                      primaryOrangeColor,
                      13,
                      isBold: false,
                      isUline: false,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Buy/Sell buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBuyButton(context, wid),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSellButton(context, wid),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? primaryOrangeColor.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                selected ? primaryOrangeColor : Colors.white.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: textStyle(
            selected ? primaryOrangeColor : Colors.white70,
            12,
            isBold: true,
            isUline: false,
          ),
        ),
      ),
    );
  }

  Widget _buildBuyButton(BuildContext context, double wid) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final initialOutcome = _isYesSelected ? 'Yes' : 'No';
    return BuyEventButton(
      predictionModel: widget.predictionModel,
      isPortraitMode: isPortrait,
      containerWdt: wid,
      initialOutcome: initialOutcome,
    );
  }

  Widget _buildSellButton(BuildContext context, double wid) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final initialOutcome = _isYesSelected ? 'Yes' : 'No';
    return SellEventButton(
      predictionModel: widget.predictionModel,
      isPortraitMode: isPortrait,
      containerWdt: wid,
      initialOutcome: initialOutcome,
    );
  }
}
