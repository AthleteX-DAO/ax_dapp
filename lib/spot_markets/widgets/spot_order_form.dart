import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/spot_markets/bloc/bloc.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpotOrderForm extends StatefulWidget {
  const SpotOrderForm({
    super.key,
    required this.selectedMarket,
  });

  final String selectedMarket;

  @override
  State<SpotOrderForm> createState() => _SpotOrderFormState();
}

class _SpotOrderFormState extends State<SpotOrderForm> {
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.all(14.0),
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
            
            // Price input
            _buildInputField(
              controller: _priceController,
              label: 'Price (USD)',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 14),
            
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
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    label: 'SELL',
                    backgroundColor: primaryRedColor,
                    onPressed: () => _handleSellOrder(context),
                  ),
                ),
              ],
            ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
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
    return Container(
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: textStyle(
                Colors.white,
                13,
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
    if (_quantityController.text.isEmpty || _priceController.text.isEmpty) {
      _showError(context, 'Please enter both quantity and price');
      return;
    }

    context.read<SpotMarketsBloc>().add(
          SpotMarketBuyOrderPlaced(
            market: widget.selectedMarket,
            quantity: double.parse(_quantityController.text),
            price: double.parse(_priceController.text),
          ),
        );

    _quantityController.clear();
    _priceController.clear();
  }

  void _handleSellOrder(BuildContext context) {
    if (_quantityController.text.isEmpty || _priceController.text.isEmpty) {
      _showError(context, 'Please enter both quantity and price');
      return;
    }

    context.read<SpotMarketsBloc>().add(
          SpotMarketSellOrderPlaced(
            market: widget.selectedMarket,
            quantity: double.parse(_quantityController.text),
            price: double.parse(_priceController.text),
          ),
        );

    _quantityController.clear();
    _priceController.clear();
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
}
