import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/spot_markets/models/pending_order.dart';
import 'package:ax_dapp/trade_slip/trade_slip.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderConfirmationDialog extends StatelessWidget {
  const OrderConfirmationDialog({
    super.key,
    required this.pendingOrder,
    required this.onConfirm,
    required this.onCancel,
  });

  final PendingOrder pendingOrder;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isBuy = pendingOrder.type == 'buy';
    final actionColor = isBuy ? primaryGreenColor : primaryRedColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Confirm ${isBuy ? 'Buy' : 'Sell'} Order',
                        style: textStyle(
                          Colors.white,
                          18,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onCancel,
                      child: Icon(
                        Icons.close,
                        color: Colors.white.withOpacity(0.5),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.white.withOpacity(0.1),
                height: 1,
              ),
              
              // Details
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Market',
                      pendingOrder.market,
                      Colors.white,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      isBuy ? 'Buying' : 'Selling',
                      '${pendingOrder.quantity.toStringAsFixed(6)} ${pendingOrder.market}',
                      Colors.white,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      isBuy ? 'Price per Unit' : 'Price per Unit',
                      '\$${pendingOrder.price.toStringAsFixed(2)}',
                      Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            isBuy ? 'Total Cost' : 'Total Receive',
                            isBuy 
                                ? '\$${pendingOrder.totalCost.toStringAsFixed(2)}'
                                : '\$${pendingOrder.totalCost.toStringAsFixed(2)}',
                            actionColor,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            'Expected Output',
                            isBuy
                                ? '${pendingOrder.expectedOutput.toStringAsFixed(6)} sUSD'
                                : '\$${pendingOrder.expectedOutput.toStringAsFixed(2)}',
                            actionColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Max Slippage',
                      '${(pendingOrder.slippage * 100).toStringAsFixed(2)}%',
                      Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gas Fee',
                            style: textStyle(
                              Colors.blue.withOpacity(0.7),
                              11,
                              isBold: true,
                              isUline: false,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${pendingOrder.gasEstimate['totalCostEth'] ?? 'N/A'} ETH',
                            style: textStyle(
                              Colors.blue,
                              14,
                              isBold: true,
                              isUline: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.white.withOpacity(0.1),
                height: 1,
              ),
              
              // Actions
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: textStyle(
                            Colors.white.withOpacity(0.7),
                            14,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<TrackingCubit>().trackSpotOrderSuccess(
                            marketName: pendingOrder.market,
                            orderType: pendingOrder.type,
                            amount: pendingOrder.quantity,
                            valueInUsd: pendingOrder.totalCost,
                            walletId: '',
                          );
                          onConfirm();

                          // Show trade slip after confirmation
                          if (context.mounted) {
                            Navigator.of(context).pop(); // Close this dialog
                            TradeSlipDialog.show(
                              context,
                              slip: TradeSlipData(
                                type: SlipType.spot,
                                side: isBuy
                                    ? SlipSide.buy
                                    : SlipSide.sell,
                                status: SlipStatus.pending,
                                marketName: pendingOrder.market,
                                amount: pendingOrder.totalCost,
                                price: pendingOrder.price,
                                quantity: pendingOrder.quantity,
                                slippage: pendingOrder.slippage,
                                txHash: pendingOrder.txHash,
                                timestamp: DateTime.now(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: actionColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Confirm ${isBuy ? 'Buy' : 'Sell'}',
                          style: textStyle(
                            Colors.white,
                            14,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ),
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

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyle(
            Colors.white.withOpacity(0.6),
            12,
            isBold: false,
            isUline: false,
          ),
        ),
        Text(
          value,
          style: textStyle(
            valueColor,
            12,
            isBold: true,
            isUline: false,
          ),
        ),
      ],
    );
  }
}
