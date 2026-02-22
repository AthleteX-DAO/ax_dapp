import 'package:ax_dapp/earn/bloc/earn_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Transaction stepper modal with 4-step animated flow
/// Approve → Confirm → Pending → Success with blockchain polling
class TransactionStepperModal extends StatelessWidget {
  const TransactionStepperModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarnPageBloc, EarnPageState>(
      buildWhen: (previous, current) =>
          previous.showTransactionModal != current.showTransactionModal ||
          previous.transactionStep != current.transactionStep ||
          previous.transactionStatus != current.transactionStatus,
      builder: (context, state) {
        if (!state.showTransactionModal) {
          return const SizedBox.shrink();
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[700]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        _getTitle(state),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getSubtitle(state),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ],
                  ),
                ),
                // Stepper
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildStep(
                        'Approve',
                        TransactionStep.approve,
                        state.transactionStep,
                      ),
                      const SizedBox(height: 16),
                      _buildStep(
                        'Confirm',
                        TransactionStep.confirm,
                        state.transactionStep,
                      ),
                      const SizedBox(height: 16),
                      _buildStep(
                        'Pending',
                        TransactionStep.pending,
                        state.transactionStep,
                      ),
                      const SizedBox(height: 16),
                      _buildStep(
                        'Success',
                        TransactionStep.success,
                        state.transactionStep,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Status message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildStatusMessage(context, state),
                ),
                const SizedBox(height: 24),
                // Action button
                if (state.transactionStatus == TransactionStatus.error)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<EarnPageBloc>().add(
                                const CloseTransactionModal(),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[400],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(
    String label,
    TransactionStep step,
    TransactionStep currentStep,
  ) {
    final isCompleted = _stepIndex(step) < _stepIndex(currentStep);
    final isCurrent = step == currentStep;
    final isNext = _stepIndex(step) > _stepIndex(currentStep);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isCurrent
            ? Colors.amber[400]!.withOpacity(0.2)
            : isCompleted
                ? Colors.green.withOpacity(0.1)
                : Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent
              ? Colors.amber[400]!
              : isCompleted
                  ? Colors.green
                  : Colors.grey[700]!,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent
                  ? Colors.amber[400]
                  : isCompleted
                      ? Colors.green
                      : Colors.grey[700],
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.black, size: 14)
                  : isCurrent
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCurrent ? Colors.black : Colors.grey[400]!,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                      : const SizedBox(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCurrent
                    ? Colors.amber[400]
                    : isCompleted
                        ? Colors.green
                        : Colors.grey[400],
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessage(BuildContext context, EarnPageState state) {
    if (state.transactionStatus == TransactionStatus.pending) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.amber[400]!,
                  ),
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Waiting for blockchain confirmation...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                  fontFamily: 'OpenSans',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (state.transactionHash.isNotEmpty)
            Text(
              'Tx: ${state.transactionHash.substring(0, 10)}...',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontFamily: 'monospace',
              ),
            ),
        ],
      );
    } else if (state.transactionStatus == TransactionStatus.success) {
      return Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.1),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Transaction Confirmed!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your transaction was successful',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      );
    } else if (state.transactionStatus == TransactionStatus.error) {
      return Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(0.1),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: const Icon(
              Icons.cancel,
              color: Colors.red,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Transaction Failed',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              state.transactionError,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  String _getTitle(EarnPageState state) {
    if (state.transactionStatus == TransactionStatus.success) {
      return 'Success!';
    } else if (state.transactionStatus == TransactionStatus.error) {
      return 'Error';
    }
    return 'Confirm Transaction';
  }

  String _getSubtitle(EarnPageState state) {
    if (state.transactionStatus == TransactionStatus.success) {
      return 'Your transaction is complete';
    } else if (state.transactionStatus == TransactionStatus.error) {
      return 'Please try again';
    }
    return 'Please review and confirm your action';
  }

  int _stepIndex(TransactionStep step) {
    switch (step) {
      case TransactionStep.approve:
        return 0;
      case TransactionStep.confirm:
        return 1;
      case TransactionStep.pending:
        return 2;
      case TransactionStep.success:
        return 3;
    }
  }
}
