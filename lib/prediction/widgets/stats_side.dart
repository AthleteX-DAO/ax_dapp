import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/prediction/bloc/prediction_page_bloc.dart';
import 'package:ax_dapp/prediction/widgets/buttons.dart';
import 'package:ax_dapp/service/controller/usecases/get_total_token_balance_use_case.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  double _tradeAmount = 0;
  final _amountController = TextEditingController();
  double _maxBalance = 0;

  @override
  void initState() {
    super.initState();
    _loadWalletBalance();
  }

  Future<void> _loadWalletBalance() async {
    try {
      final balance = await context
          .read<GetTotalTokenBalanceUseCase>()
          .getTotalAxBalance();
      if (mounted) {
        setState(() => _maxBalance = balance);
      }
    } catch (_) {
      // Wallet not connected — leave at 0
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setAmount(double amount) {
    setState(() {
      _tradeAmount = amount.clamp(0, _maxBalance);
      _amountController.text = _tradeAmount.toStringAsFixed(2);
    });
  }

  double get _selectedPrice =>
      _isYesSelected
          ? (widget.predictionModel.longTokenPrice ?? 0.5)
          : (widget.predictionModel.shortTokenPrice ?? 0.5);

  double get _expectedPayout => _tradeAmount / _selectedPrice;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.sizeOf(context).width;
    var wid = _width * 0.4;
    if (_width < 1160) wid = _width * 0.95;

    return Container(
      width: wid,
      padding: const EdgeInsets.all(16),
      decoration: GoldTheme.glowPanel(radius: 24),
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
                      decoration: GoldTheme.emphasis(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildToggleChip(
                              label: 'Yes',
                              selected: _isYesSelected,
                              onTap: () {
                                setState(() => _isYesSelected = true);
                              },),
                          const SizedBox(width: 8),
                          _buildToggleChip(
                              label: 'No',
                              selected: !_isYesSelected,
                              onTap: () {
                                setState(() => _isYesSelected = false);
                              },),
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
                          widget.predictionModel.longTokenPrice?.toStringAsFixed(4) ?? '0.00',
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
                          widget.predictionModel.shortTokenPrice?.toStringAsFixed(4) ?? '0.00',
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
                          widget.predictionModel.tradingVolume.toStringAsFixed(2),
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
              // Amount Input Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trade Amount',
                      style: textStyle(
                        Colors.white,
                        16,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Amount Display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount',
                            style: textStyle(
                              Colors.white.withOpacity(0.7),
                              14,
                              isBold: false,
                              isUline: false,
                            ),
                          ),
                          Text(
                            '\$${_tradeAmount.toStringAsFixed(2)}',
                            style: textStyle(
                              Colors.white,
                              18,
                              isBold: true,
                              isUline: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Quick Add Buttons
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildQuickAddButton('+\$1', 1),
                        _buildQuickAddButton('+\$5', 5),
                        _buildQuickAddButton('+\$10', 10),
                        _buildQuickAddButton('+\$100', 100),
                        _buildQuickAddButton('Max', _maxBalance),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Amount Input Field
                    TextField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: textStyle(
                        Colors.white,
                        14,
                        isBold: false,
                        isUline: false,
                      ),
                      onChanged: (value) {
                        _setAmount(double.tryParse(value) ?? 0);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter amount in USD',
                        hintStyle: textStyle(
                          Colors.white.withOpacity(0.4),
                          14,
                          isBold: false,
                          isUline: false,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: primaryOrangeColor.withOpacity(0.5),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Payout Info
                    if (_tradeAmount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: primaryGreenColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: primaryGreenColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Expected if Correct:',
                              style: textStyle(
                                primaryGreenColor,
                                12,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                            Text(
                              '\$${_expectedPayout.toStringAsFixed(2)}',
                              style: textStyle(
                                primaryGreenColor,
                                12,
                                isBold: true,
                                isUline: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Trade Button
                    GestureDetector(
                      onTap: _tradeAmount > 0
                          ? () => _executeTrade(context)
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: _tradeAmount > 0
                            ? GoldTheme.goldGlowButton(radius: 12)
                            : BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                        alignment: Alignment.center,
                        child: Text(
                          'Buy ${_isYesSelected ? 'YES' : 'NO'}',
                          style: textStyle(
                            _tradeAmount > 0 ? Colors.black : Colors.white38,
                            16,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ),
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

  Widget _buildQuickAddButton(String label, double amount) {
    return GestureDetector(
      onTap: () => _setAmount(_tradeAmount + amount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: primaryOrangeColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: primaryOrangeColor.withOpacity(0.25),
          ),
        ),
        child: Text(
          label,
          style: textStyle(
            primaryOrangeColor,
            12,
            isBold: true,
            isUline: false,
          ),
        ),
      ),
    );
  }

  void _executeTrade(BuildContext context) {
    if (_tradeAmount <= 0) return;

    // Dispatch BuyPredictionTokens event to PredictionPageBloc
    context.read<PredictionPageBloc>().add(
      BuyPredictionTokens(
        axUsdAmount: _tradeAmount,
        isYes: _isYesSelected,
      ),
    );

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Placing \$$_tradeAmount ${_isYesSelected ? 'YES' : 'NO'} prediction on-chain…',
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    // Clear amount after trade
    setState(() {
      _tradeAmount = 0;
      _amountController.clear();
    });
  }
}
