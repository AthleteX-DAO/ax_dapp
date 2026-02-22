import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/perps/bloc/perps_trading_bloc.dart';
import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';

/// Trading column widget for placing market and limit orders
class PerpsTradingColumn extends StatefulWidget {
  const PerpsTradingColumn({
    super.key,
    required this.symbol,
  });

  final String symbol;

  @override
  State<PerpsTradingColumn> createState() => _PerpsTradingColumnState();
}

class _PerpsTradingColumnState extends State<PerpsTradingColumn> {
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  bool _isMarketOrder = true;
  bool _isLong = true;

  @override
  void dispose() {
    _sizeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Long / Short toggle (prominent, like Synthetix Perps) ──
        _buildDirectionSelector(),
        const SizedBox(height: 14),
        // ── Market / Limit tabs ──
        _buildOrderTypeSelector(),
        const SizedBox(height: 14),
        // ── Size input ──
        _buildSizeInput(),
        if (!_isMarketOrder) ...[
          const SizedBox(height: 12),
          _buildPriceInput(),
        ],
        const SizedBox(height: 18),
        // ── Place Order button ──
        _buildTradeButton(),
        const SizedBox(height: 12),
        // ── Trade details / errors ──
        _buildOrderInfo(),
      ],
    );
  }

  Widget _buildOrderTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildTabButton(
            label: 'Market',
            isSelected: _isMarketOrder,
            onTap: () => setState(() => _isMarketOrder = true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTabButton(
            label: 'Limit',
            isSelected: !_isMarketOrder,
            onTap: () => setState(() => _isMarketOrder = false),
          ),
        ),
      ],
    );
  }

  Widget _buildDirectionSelector() {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDirectionTab(
              label: 'Long',
              isSelected: _isLong,
              color: Colors.green,
              onTap: () => setState(() => _isLong = true),
              isLeft: true,
            ),
          ),
          Expanded(
            child: _buildDirectionTab(
              label: 'Short',
              isSelected: !_isLong,
              color: Colors.red,
              onTap: () => setState(() => _isLong = false),
              isLeft: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.12)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.3)
                : Colors.grey.shade700,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.grey.shade500,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionTab({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: isLeft ? const Radius.circular(7) : Radius.zero,
            bottomLeft: isLeft ? const Radius.circular(7) : Radius.zero,
            topRight: !isLeft ? const Radius.circular(7) : Radius.zero,
            bottomRight: !isLeft ? const Radius.circular(7) : Radius.zero,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade500,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSizeInput() {
    final accountState = context.watch<AccountBloc>().state;
    final availableCollateral = accountState.synthetixCollateralAvailable;
    // Convert from wei (18 decimals) to USD
    final availableUSD = availableCollateral / BigInt.from(10).pow(18);
    final availableDisplay = availableUSD;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Position Size',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
            ),
            Text(
              'Available: \$${availableDisplay.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _sizeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: _darkInputDecoration(hint: '0.00', suffix: 'USD'),
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        const SizedBox(height: 8),
        _buildPercentageButtons(availableDisplay),
      ],
    );
  }

  Widget _buildPercentageButtons(double available) {
    return Row(
      children: [
        _buildPercentButton('25%', available * 0.25),
        const SizedBox(width: 4),
        _buildPercentButton('50%', available * 0.50),
        const SizedBox(width: 4),
        _buildPercentButton('75%', available * 0.75),
        const SizedBox(width: 4),
        _buildPercentButton('100%', available),
      ],
    );
  }

  Widget _buildPercentButton(String label, double amount) {
    return Expanded(
      child: OutlinedButton(
        onPressed: amount > 0
            ? () {
                setState(() {
                  _sizeController.text = amount.toStringAsFixed(2);
                });
              }
            : null,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 4),
          minimumSize: const Size(0, 28),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildPriceInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Limit Price',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: _darkInputDecoration(hint: '0.00', suffix: 'USD'),
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }

  /// Shared dark input decoration for text fields
  InputDecoration _darkInputDecoration({
    required String hint,
    String? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade600),
      suffixText: suffix,
      suffixStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildTradeButton() {
    final walletState = context.watch<WalletBloc>().state;
    final accountState = context.watch<AccountBloc>().state;

    // Gate 1: Wallet not connected
    if (walletState.isWalletDisconnected) {
      return ElevatedButton(
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade700,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Connect Wallet',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    // Gate 2: No Synthetix account
    if (!accountState.hasSynthetixAccount) {
      return ElevatedButton(
        onPressed: accountState.isSynthetixAccountLoading
            ? null
            : () {
                context
                    .read<AccountBloc>()
                    .add(const CreateSynthetixAccountRequested());
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: accountState.isSynthetixAccountLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Create Synthetix Account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      );
    }

    // Gate 3: Normal trade button
    return BlocBuilder<PerpsTradingBloc, PerpsTradingState>(
      builder: (context, state) {
        final isLoading = state is PerpsTradingLoading;
        final color = _isLong ? Colors.green : Colors.red;

        return ElevatedButton(
          onPressed: isLoading ? null : _handleTrade,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  '${_isLong ? 'Long' : 'Short'} ${_isMarketOrder ? 'Market' : 'Limit'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildOrderInfo() {
    return BlocBuilder<PerpsTradingBloc, PerpsTradingState>(
      builder: (context, state) {
        if (state is PerpsTradingError) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade300, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.red.shade300,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is PerpsTradingSuccess) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green.shade300, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Order placed successfully',
                    style: TextStyle(
                      color: Colors.green.shade300,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildInfoRow('Est. Execution Price', '--'),
            _buildInfoRow('Spread', '<0.001%'),
            _buildInfoRow('Max Slippage', '1%'),
            _buildInfoRow('Fees', '~0.07%'),
            _buildInfoRow('Liq. Price', '--'),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTrade() {
    final size = double.tryParse(_sizeController.text);
    if (size == null || size <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid size')),
      );
      return;
    }

    // Check available margin
    final accountState = context.read<AccountBloc>().state;
    final availableWei = accountState.synthetixCollateralAvailable;
    final availableUSD =
        (availableWei / BigInt.from(10).pow(18));
    if (size > availableUSD && availableUSD > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Insufficient margin. Available: \$${availableUSD.toStringAsFixed(2)}',
          ),
        ),
      );
      return;
    }

    double? limitPrice;
    if (!_isMarketOrder) {
      limitPrice = double.tryParse(_priceController.text);
      if (limitPrice == null || limitPrice <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid limit price')),
        );
        return;
      }
    }

    context.read<PerpsTradingBloc>().add(
          PlacePerpsOrder(
            symbol: widget.symbol,
            size: size,
            isLong: _isLong,
            isMarketOrder: _isMarketOrder,
            limitPrice: limitPrice,
          ),
        );
  }
}
