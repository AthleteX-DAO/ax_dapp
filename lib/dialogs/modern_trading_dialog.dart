import 'dart:ui' as ui;

import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

/// Modern, glassmorphic trading dialog with enhanced UX
class ModernTradingDialog extends StatefulWidget {
  const ModernTradingDialog({
    super.key,
    required this.predictionModel,
    required this.isBuy,
    this.yesPrice = 0.88,
    this.noPrice = 0.12,
    this.initialOutcome = 'Yes',
  });

  final PredictionModel predictionModel;
  final bool isBuy;
  final double yesPrice;
  final double noPrice;
  final String initialOutcome;

  @override
  State<ModernTradingDialog> createState() => _ModernTradingDialogState();
}

class _ModernTradingDialogState extends State<ModernTradingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  bool _showAdvanced = false;
  late String _selectedOutcome;
  String _inputAmount = '';
  String _selectedCurrency = 'USD';
  bool _limitOrderEnabled = false;
  late bool _isBuyLocal;
  double _balance = 2500.0; // TODO: wire real balance

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _selectedOutcome = widget.initialOutcome;
    _isBuyLocal = widget.isBuy;
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleAdvanced() {
    setState(() {
      _showAdvanced = !_showAdvanced;
      if (_showAdvanced) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive width based on screen size
    final dialogWidth = screenWidth < 600
        ? screenWidth - 32 // Mobile: full width minus margins
        : screenWidth < 1200
            ? screenWidth * 0.5 // Tablet: half width
            : 520.0; // Desktop: fixed width

    // Max height to prevent overflow
    final maxHeight = screenHeight * 0.85;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(maxHeight: maxHeight),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 24),

                    // Market Info
                    _buildMarketInfo(),
                    const SizedBox(height: 24),

                    // Outcome Selection
                    _buildOutcomeSelector(),
                    const SizedBox(height: 24),

                    // Currency Selector
                    _buildCurrencySelector(),
                    const SizedBox(height: 20),

                    // Amount Input
                    _buildAmountInput(),
                    const SizedBox(height: 16),

                    // Quick Action Buttons
                    _buildQuickActionButtons(),
                    const SizedBox(height: 24),

                    // Order Summary
                    _buildOrderSummary(),
                    const SizedBox(height: 20),

                    // Advanced Options
                    _buildAdvancedOptions(),
                    if (_showAdvanced) ...[
                      const SizedBox(height: 16),
                      _buildAdvancedSettings(),
                    ],
                    const SizedBox(height: 28),

                    // Action Buttons
                    _buildActionButtons(),
                    const SizedBox(height: 12),

                    // Terms
                    _buildTermsText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buy/Sell toggle tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeaderTab(
                        label: 'Buy',
                        selected: _isBuyLocal,
                        onTap: () {
                          setState(() => _isBuyLocal = true);
                        }),
                    const SizedBox(width: 8),
                    _buildHeaderTab(
                        label: 'Sell',
                        selected: !_isBuyLocal,
                        onTap: () {
                          setState(() => _isBuyLocal = false);
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.predictionModel.prompt,
                style: textStyle(
                  Colors.white70,
                  12,
                  isBold: false,
                  isUline: false,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white70, size: 24),
          tooltip: 'Close',
        ),
      ],
    );
  }

  Widget _buildHeaderTab(
      {required String label,
      required bool selected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.white : Colors.white.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: textStyle(
            selected ? Colors.white : Colors.white70,
            13,
            isBold: true,
            isUline: false,
          ),
        ),
      ),
    );
  }

  Widget _buildMarketInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPriceCard('Yes', widget.yesPrice, const Color(0xFFFFD700)),
          const SizedBox(width: 12),
          _buildPriceCard('No', widget.noPrice, Colors.white70),
        ],
      ),
    );
  }

  Widget _buildPriceCard(String label, double price, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: textStyle(
                color,
                12,
                isBold: false,
                isUline: false,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: textStyle(
                color,
                18,
                isBold: true,
                isUline: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Outcome',
          style: textStyle(
            Colors.white,
            14,
            isBold: true,
            isUline: false,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOutcomeButton(
                label: 'Yes',
                color: const Color(0xFFFFD700),
                priceCents: (widget.yesPrice * 100).round(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOutcomeButton(
                label: 'No',
                color: Colors.white70,
                priceCents: (widget.noPrice * 100).round(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOutcomeButton(
      {required String label, required Color color, required int priceCents}) {
    final isSelected = _selectedOutcome == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedOutcome = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    color.withOpacity(0.4),
                    color.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: textStyle(
                  isSelected ? color : Colors.white70,
                  16,
                  isBold: isSelected,
                  isUline: false,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.25)
                      : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${priceCents}¢',
                  style: textStyle(
                    isSelected ? Colors.white : Colors.white70,
                    12,
                    isBold: true,
                    isUline: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency',
          style: textStyle(
            Colors.white,
            14,
            isBold: true,
            isUline: false,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: DropdownButton<String>(
            value: _selectedCurrency,
            underline: const SizedBox(),
            isExpanded: true,
            icon: const Icon(Icons.expand_more, color: Colors.white54),
            items: ['USD', 'AX', 'USDC'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: textStyle(
                    Colors.white,
                    14,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                setState(() => _selectedCurrency = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Amount',
              style: textStyle(
                Colors.white,
                14,
                isBold: true,
                isUline: false,
              ),
            ),
            Text(
              'Balance: \$2,500.00',
              style: textStyle(
                Colors.white54,
                12,
                isBold: false,
                isUline: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: primaryOrangeColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryOrangeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.attach_money,
                  color: primaryOrangeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (value) => setState(() => _inputAmount = value),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: textStyle(
                    Colors.white,
                    18,
                    isBold: false,
                    isUline: false,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: textStyle(
                      Colors.white30,
                      18,
                      isBold: false,
                      isUline: false,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickButton('25%', () {
          setState(() => _inputAmount = (_balance * 0.25).toStringAsFixed(2));
        }),
        _buildQuickButton('50%', () {
          setState(() => _inputAmount = (_balance * 0.50).toStringAsFixed(2));
        }),
        _buildQuickButton('Max', () {
          setState(() => _inputAmount = (_balance).toStringAsFixed(2));
        }),
      ],
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: textStyle(
            Colors.white70,
            12,
            isBold: true,
            isUline: false,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primaryOrangeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryOrangeColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow('You\'ll spend',
              '\$${_inputAmount.isEmpty ? "0.00" : _inputAmount}'),
          const SizedBox(height: 10),
          _buildSummaryRow('You\'ll receive',
              '${(_inputAmount.isNotEmpty ? double.parse(_inputAmount) * 1.14 : 0).toStringAsFixed(2)} shares'),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: primaryOrangeColor.withOpacity(0.2),
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            'Est. Profit',
            '${(_inputAmount.isNotEmpty ? double.parse(_inputAmount) * 0.14 : 0).toStringAsFixed(2)}',
            isHighlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyle(
            isHighlight ? primaryOrangeColor : Colors.white70,
            13,
            isBold: isHighlight,
            isUline: false,
          ),
        ),
        Text(
          value,
          style: textStyle(
            isHighlight ? primaryOrangeColor : Colors.white,
            13,
            isBold: isHighlight,
            isUline: false,
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedOptions() {
    return GestureDetector(
      onTap: _toggleAdvanced,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  _showAdvanced ? Icons.expand_less : Icons.expand_more,
                  color: primaryOrangeColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Advanced Options',
                  style: textStyle(
                    Colors.white,
                    13,
                    isBold: true,
                    isUline: false,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryOrangeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Pro',
                style: textStyle(
                  primaryOrangeColor,
                  10,
                  isBold: true,
                  isUline: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Limit Order Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Limit Order',
              style: textStyle(
                Colors.white,
                13,
                isBold: true,
                isUline: false,
              ),
            ),
            Switch(
              value: _limitOrderEnabled,
              onChanged: (value) => setState(() => _limitOrderEnabled = value),
              activeColor: primaryOrangeColor,
              inactiveTrackColor: Colors.white.withOpacity(0.1),
            ),
          ],
        ),
        if (_limitOrderEnabled) ...[
          const SizedBox(height: 12),
          Text(
            'Limit Price',
            style: textStyle(
              Colors.white,
              13,
              isBold: true,
              isUline: false,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: textStyle(
                Colors.white,
                14,
                isBold: false,
                isUline: false,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: textStyle(
                  Colors.white30,
                  14,
                  isBold: false,
                  isUline: false,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        // Slippage Settings
        Text(
          'Slippage Tolerance',
          style: textStyle(
            Colors.white,
            13,
            isBold: true,
            isUline: false,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSlippageButton('0.5%'),
            const SizedBox(width: 8),
            _buildSlippageButton('1%'),
            const SizedBox(width: 8),
            _buildSlippageButton('2%'),
          ],
        ),
      ],
    );
  }

  Widget _buildSlippageButton(String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            value,
            style: textStyle(
              Colors.white70,
              12,
              isBold: false,
              isUline: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryOrangeColor,
                primaryOrangeColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: primaryOrangeColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            '${_isBuyLocal ? "Buy" : "Sell"} ${_selectedOutcome}',
            textAlign: TextAlign.center,
            style: textStyle(
              Colors.black,
              16,
              isBold: true,
              isUline: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsText() {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'By trading, you agree to the ',
              style: textStyle(
                Colors.white54,
                11,
                isBold: false,
                isUline: false,
              ),
            ),
            TextSpan(
              text: 'Terms of Use',
              style: textStyle(
                primaryOrangeColor,
                11,
                isBold: true,
                isUline: true,
              ),
            ),
            TextSpan(
              text: '.',
              style: textStyle(
                Colors.white54,
                11,
                isBold: false,
                isUline: false,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
