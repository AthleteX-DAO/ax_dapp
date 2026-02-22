import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/spot_markets/models/pending_order.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class OrderStatusDialog extends StatelessWidget {
  const OrderStatusDialog({
    super.key,
    required this.pendingOrder,
    required this.onRetry,
    required this.onClose,
  });

  final PendingOrder pendingOrder;
  final VoidCallback? onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final isBuy = pendingOrder.type == 'buy';
    final actionColor = isBuy ? primaryGreenColor : primaryRedColor;
    final isError = pendingOrder.status == PendingOrderStatus.failed;
    final isConfirmed = pendingOrder.status == PendingOrderStatus.confirmed;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Status Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isError
                          ? Colors.red.withOpacity(0.1)
                          : isConfirmed
                              ? primaryGreenColor.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                      border: Border.all(
                        color: isError
                            ? Colors.red
                            : isConfirmed
                                ? primaryGreenColor
                                : Colors.orange,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        isError
                            ? Icons.close
                            : isConfirmed
                                ? Icons.check
                                : Icons.hourglass_empty,
                        size: 40,
                        color: isError
                            ? Colors.red
                            : isConfirmed
                                ? primaryGreenColor
                                : Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Status title
                  Text(
                    isError
                        ? '${isBuy ? "Buy" : "Sell"} Order Failed'
                        : isConfirmed
                            ? '${isBuy ? "Buy" : "Sell"} Order Confirmed!'
                            : '${isBuy ? "Buy" : "Sell"} Order Processing...',
                    style: textStyle(
                      Colors.white,
                      18,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Market and amount
                  Text(
                    '${pendingOrder.quantity.toStringAsFixed(6)} ${pendingOrder.market}',
                    style: textStyle(
                      Colors.white.withOpacity(0.7),
                      14,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${pendingOrder.totalCost.toStringAsFixed(2)}',
                    style: textStyle(
                      actionColor,
                      16,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                  
                  if (isError && pendingOrder.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        pendingOrder.errorMessage!,
                        style: textStyle(
                          Colors.red,
                          12,
                          isBold: false,
                          isUline: false,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ] else if (!isError && !isConfirmed) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.orange.withOpacity(0.2),
                        color: Colors.orange,
                        minHeight: 3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pendingOrder.statusLabel,
                      style: textStyle(
                        Colors.orange,
                        12,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  ],
                  
                  if (pendingOrder.txHash != null) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        final txUrl =
                            'https://sepolia.basescan.org/tx/${pendingOrder.txHash}';
                        // In real implementation, use url_launcher to open
                        // For now, just show the hash
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Open in browser: $txUrl'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View Transaction',
                              style: textStyle(
                                Colors.blue,
                                12,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.open_in_new,
                              size: 12,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Actions
            Divider(
              color: Colors.white.withOpacity(0.1),
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isError && onRetry != null)
                    ElevatedButton(
                      onPressed: onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrangeColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: textStyle(
                          Colors.white,
                          12,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: onClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isConfirmed ? primaryGreenColor : Colors.grey[800],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isConfirmed ? 'Done' : 'Close',
                        style: textStyle(
                          Colors.white,
                          12,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
