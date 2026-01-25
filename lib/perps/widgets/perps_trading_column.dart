import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/perps/bloc/perps_trading_bloc.dart';

/// Trading column widget for placing market and limit orders
class PerpsTradingColumn extends StatefulWidget {
  const PerpsTradingColumn({
    Key? key,
    required this.symbol,
  }) : super(key: key);

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
    return Card(
      elevation: 2,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildOrderTypeSelector(),
            const SizedBox(height: 16),
            _buildDirectionSelector(),
            const SizedBox(height: 16),
            _buildSizeInput(),
            if (!_isMarketOrder) ...[
              const SizedBox(height: 12),
              _buildPriceInput(),
            ],
            const SizedBox(height: 20),
            _buildTradeButton(),
            const SizedBox(height: 12),
            _buildOrderInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Trade ${widget.symbol}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          icon: const Icon(Icons.settings, size: 20),
          onPressed: () {},
          tooltip: 'Trading Settings',
        ),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
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
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade600,
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
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSizeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Size',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              'Available: \$0.00',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
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
          decoration: InputDecoration(
            hintText: '0.00',
            suffixText: 'USD',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildPercentageButtons(),
      ],
    );
  }

  Widget _buildPercentageButtons() {
    return Row(
      children: [
        _buildPercentButton('25%'),
        const SizedBox(width: 4),
        _buildPercentButton('50%'),
        const SizedBox(width: 4),
        _buildPercentButton('75%'),
        const SizedBox(width: 4),
        _buildPercentButton('100%'),
      ],
    );
  }

  Widget _buildPercentButton(String label) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          // TODO: Calculate and set size based on percentage
        },
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
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            hintText: '0.00',
            suffixText: 'USD',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTradeButton() {
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
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade700, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.red.shade700,
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
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Order placed successfully',
                    style: TextStyle(
                      color: Colors.green.shade700,
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
            _buildInfoRow('Entry Price', '--'),
            _buildInfoRow('Est. Liq. Price', '--'),
            _buildInfoRow('Fee', '~0.00%'),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
