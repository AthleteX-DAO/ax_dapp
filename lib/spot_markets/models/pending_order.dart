import 'package:equatable/equatable.dart';

enum PendingOrderStatus {
  waitingForConfirmation,  // Awaiting user confirmation
  approvalNeeded,          // Waiting for token approval
  approvingToken,          // Token approval in progress
  executingOrder,          // Order execution in progress
  pending,                 // Submitted, waiting for confirmation
  confirmed,               // Transaction confirmed on-chain
  failed,                  // Transaction failed
}

class PendingOrder extends Equatable {
  const PendingOrder({
    required this.orderId,
    required this.type, // 'buy' or 'sell'
    required this.market,
    required this.quantity,
    required this.price,
    required this.totalCost,
    required this.expectedOutput,
    required this.slippage,
    required this.gasEstimate,
    required this.status,
    this.txHash,
    this.approvalTxHash,
    this.errorMessage,
    required this.createdAt,
  });

  final String orderId;
  final String type; // 'buy' or 'sell'
  final String market;
  final double quantity;
  final double price;
  final double totalCost; // USD for buy, units for sell
  final double expectedOutput; // Synth for buy, USD for sell
  final double slippage; // e.g., 0.01 for 1%
  final Map<String, dynamic> gasEstimate; // {gasLimit, gasPrice, totalCostEth}
  final PendingOrderStatus status;
  final String? txHash;
  final String? approvalTxHash;
  final String? errorMessage;
  final DateTime createdAt;

  String get statusLabel {
    switch (status) {
      case PendingOrderStatus.waitingForConfirmation:
        return 'Awaiting Confirmation';
      case PendingOrderStatus.approvalNeeded:
        return 'Approval Needed';
      case PendingOrderStatus.approvingToken:
        return 'Approving Token...';
      case PendingOrderStatus.executingOrder:
        return 'Executing...';
      case PendingOrderStatus.pending:
        return 'Pending';
      case PendingOrderStatus.confirmed:
        return 'Confirmed';
      case PendingOrderStatus.failed:
        return 'Failed';
    }
  }

  bool get isProcessing =>
      status == PendingOrderStatus.approvingToken ||
      status == PendingOrderStatus.executingOrder ||
      status == PendingOrderStatus.pending;

  PendingOrder copyWith({
    String? orderId,
    String? type,
    String? market,
    double? quantity,
    double? price,
    double? totalCost,
    double? expectedOutput,
    double? slippage,
    Map<String, dynamic>? gasEstimate,
    PendingOrderStatus? status,
    String? txHash,
    String? approvalTxHash,
    String? errorMessage,
    DateTime? createdAt,
  }) {
    return PendingOrder(
      orderId: orderId ?? this.orderId,
      type: type ?? this.type,
      market: market ?? this.market,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalCost: totalCost ?? this.totalCost,
      expectedOutput: expectedOutput ?? this.expectedOutput,
      slippage: slippage ?? this.slippage,
      gasEstimate: gasEstimate ?? this.gasEstimate,
      status: status ?? this.status,
      txHash: txHash ?? this.txHash,
      approvalTxHash: approvalTxHash ?? this.approvalTxHash,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        orderId,
        type,
        market,
        quantity,
        price,
        totalCost,
        expectedOutput,
        slippage,
        gasEstimate,
        status,
        txHash,
        approvalTxHash,
        errorMessage,
        createdAt,
      ];
}
