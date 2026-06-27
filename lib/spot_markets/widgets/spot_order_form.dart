import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/spot_markets/bloc/bloc.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpotOrderForm extends StatefulWidget {
  const SpotOrderForm({
    super.key,
    required this.selectedMarket,
    this.currentPrice = 0,
  });

  final String selectedMarket;
  final double currentPrice;

  @override
  State<SpotOrderForm> createState() => _SpotOrderFormState();
}

class _SpotOrderFormState extends State<SpotOrderForm> {
  late TextEditingController _quantityController;
  double _selectedSlippage = 0.01; // Default 1%

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _quantityController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trading Order',
                        style: textStyle(
                          Colors.white,
                          15,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.selectedMarket,
                        style: textStyle(
                          primaryOrangeColor,
                          12,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              'Synthetix v3 Spot Market',
              style: textStyle(
                greyTextColor,
                10,
                isBold: false,
                isUline: false,
              ),
            ),
            const SizedBox(height: 14),
            
            // Quantity input
            _buildInputField(
              controller: _quantityController,
              label: 'Quantity',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            
            // Live market price (read-only)
            _buildPriceDisplay(),
            const SizedBox(height: 16),
            
            // Slippage selector
            _buildSlippageSelector(),
            const SizedBox(height: 16),
            
            // Buy/Sell buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'BUY',
                    backgroundColor: primaryGreenColor,
                    onPressed: () => _handleBuyOrder(context),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildActionButton(
                    label: 'SELL',
                    backgroundColor: primaryRedColor,
                    onPressed: () => _handleSellOrder(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: textStyle(
          Colors.white,
          13,
          isBold: false,
          isUline: false,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: textStyle(
            greyTextColor,
            11,
            isBold: false,
            isUline: false,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: textStyle(
                Colors.white,
                14,
                isBold: true,
                isUline: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleBuyOrder(BuildContext context) {
    if (_quantityController.text.isEmpty) {
      _showError(context, 'Please enter a quantity');
      return;
    }
    if (widget.currentPrice <= 0) {
      _showError(context, 'Market price not available');
      return;
    }

    context.read<TrackingCubit>().trackSpotOrderBuyPressed(
      marketName: widget.selectedMarket,
      amount: double.parse(_quantityController.text),
      walletId: '',
    );

    context.read<SpotMarketsBloc>().add(
          SpotMarketBuyOrderPlaced(
            market: widget.selectedMarket,
            quantity: double.parse(_quantityController.text),
            price: widget.currentPrice,
            slippage: _selectedSlippage,
          ),
        );

    _quantityController.clear();
  }

  void _handleSellOrder(BuildContext context) {
    if (_quantityController.text.isEmpty) {
      _showError(context, 'Please enter a quantity');
      return;
    }
    if (widget.currentPrice <= 0) {
      _showError(context, 'Market price not available');
      return;
    }

    context.read<TrackingCubit>().trackSpotOrderSellPressed(
      marketName: widget.selectedMarket,
      amount: double.parse(_quantityController.text),
      walletId: '',
    );

    context.read<SpotMarketsBloc>().add(
          SpotMarketSellOrderPlaced(
            market: widget.selectedMarket,
            quantity: double.parse(_quantityController.text),
            price: widget.currentPrice,
            slippage: _selectedSlippage,
          ),
        );

    _quantityController.clear();
  }

  Widget _buildPriceDisplay() {
    final qty = double.tryParse(_quantityController.text) ?? 0;
    final total = widget.currentPrice * qty;
    final priceStr = widget.currentPrice > 0
        ? '\$${widget.currentPrice.toStringAsFixed(2)}'
        : '—';
    final totalStr = total > 0 ? '\$${total.toStringAsFixed(2)}' : '';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Market Price',
                  style: textStyle(
                    greyTextColor,
                    11,
                    isBold: false,
                    isUline: false,
                  ),
                ),
                Text(
                  priceStr,
                  style: textStyle(
                    Colors.white,
                    13,
                    isBold: true,
                    isUline: false,
                  ),
                ),
              ],
            ),
            if (totalStr.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Est. Total',
                    style: textStyle(
                      greyTextColor,
                      11,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                  Text(
                    totalStr,
                    style: textStyle(
                      primaryOrangeColor,
                      13,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildSlippageSelector() {
    const slippageOptions = [0.001, 0.005, 0.01, 0.05]; // 0.1%, 0.5%, 1%, 5%
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Max Slippage',
          style: textStyle(
            Colors.white.withOpacity(0.7),
            11,
            isBold: true,
            isUline: false,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: slippageOptions.map((slippage) {
            final isSelected = (_selectedSlippage - slippage).abs() < 0.0001;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSlippage = slippage;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? primaryOrangeColor : Colors.white.withOpacity(0.1),
                      width: isSelected ? 2 : 1,
                    ),
                    color: isSelected 
                        ? primaryOrangeColor.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Text(
                    '${(slippage * 100).toStringAsFixed(1)}%',
                    textAlign: TextAlign.center,
                    style: textStyle(
                      isSelected ? primaryOrangeColor : Colors.white.withOpacity(0.6),
                      10,
                      isBold: isSelected,
                      isUline: false,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
