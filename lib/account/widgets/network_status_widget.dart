import 'package:flutter/material.dart';
import 'package:wallet_repository/wallet_repository.dart';

class NetworkStatusWidget extends StatefulWidget {
  const NetworkStatusWidget({
    required this.chain,
    required this.gasTokenBalance,
    required this.gasPrice,
    super.key,
  });

  final EthereumChain chain;
  final double gasTokenBalance;
  final double gasPrice; // in gwei

  @override
  State<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<NetworkStatusWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;
      if (_showDetails) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Color get _gasPriceColor {
    if (widget.gasPrice < 10) return Colors.green;
    if (widget.gasPrice < 30) return Colors.yellow;
    return Colors.orange;
  }

  String get _gasPriceLabel {
    if (widget.gasPrice < 10) return 'Low';
    if (widget.gasPrice < 30) return 'Standard';
    return 'High';
  }

  Color get _gasTokenBalanceColor {
    if (widget.gasTokenBalance > 0.1) return Colors.green;
    if (widget.gasTokenBalance > 0.01) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: _toggleDetails,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Main row with network info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Chain info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.chain.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.gasPrice.toStringAsFixed(1)} gwei',
                        style: TextStyle(
                          color: _gasPriceColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                // Gas price indicator badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _gasPriceColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _gasPriceColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _gasPriceColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _gasPriceLabel,
                        style: TextStyle(
                          color: _gasPriceColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Expandable details
            if (_showDetails) ...[
              const SizedBox(height: 12),
              Divider(
                color: Colors.white.withOpacity(0.1),
                height: 1,
              ),
              const SizedBox(height: 12),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Gas Price',
                      '${widget.gasPrice.toStringAsFixed(1)} gwei ($_gasPriceLabel)',
                      _gasPriceColor,
                    ),
                    const SizedBox(height: 10),
                    _buildDetailRow(
                      'Gas Token',
                      '${widget.gasTokenBalance.toStringAsFixed(4)} ${widget.chain.gasTokenName}',
                      _gasTokenBalanceColor,
                    ),
                    const SizedBox(height: 10),
                    _buildDetailRow(
                      'RPC Status',
                      'Healthy',
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
