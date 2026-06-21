import 'package:ax_dapp/service/confirmation_dialogs/custom_confirmation_dialogs.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/swap/bloc/swap_page_bloc.dart';
import 'package:ax_dapp/swap/models/swap_type.dart';
import 'package:ax_dapp/swap/widgets/widgets.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/warning_text_button.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuySellWidget extends StatefulWidget {
  const BuySellWidget({super.key});

  @override
  State<BuySellWidget> createState() => _BuySellWidgetState();
}

class _BuySellWidgetState extends State<BuySellWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _tokenToController = TextEditingController();
  bool isBuy = true;

  @override
  void dispose() {
    _amountController.dispose();
    _tokenToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SwapPageBloc, SwapPageState>(
      listener: (context, state) {
        if (state.status == BlocStatus.error) {
          // Handle error if needed
        }
      },
      builder: (context, state) {
        final bloc = context.read<SwapPageBloc>();
        final tokenFrom = state.tokenFrom;
        final tokenTo = state.tokenTo;

        if (state.status != BlocStatus.error) {
          _tokenToController.text =
              state.swapInfo.receiveAmount.toStringAsFixed(6);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tabs
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isBuy = true;
                      });
                      // Ensure correct direction: Stable -> Token
                      // This logic assumes we want to trade a specific pair.
                      // For now, let's just use the SwapTokens event to toggle if needed,
                      // or rely on the user manually selecting tokens in the full swap page.
                      // But for a "Buy/Sell" widget, we usually fix the target token.
                      // Let's assume the chart is for 'tokenTo'.
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: isBuy
                          ? Colors.green.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    child: const Text('Buy',
                        style: TextStyle(color: Colors.green),),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isBuy = false;
                      });
                      // Ensure correct direction: Token -> Stable
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: !isBuy
                          ? Colors.red.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    child:
                        const Text('Sell', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Swap Type Indicator
            if (state.swapInfo.swapType != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _getSwapTypeColor(state.swapInfo.swapType!)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getSwapTypeColor(state.swapInfo.swapType!),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.swapInfo.swapType!.badge,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          state.swapInfo.swapType!.displayName,
                          style: TextStyle(
                            color: _getSwapTypeColor(state.swapInfo.swapType!),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (state.swapInfo.routePath != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Route: ${state.swapInfo.routePath}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      ),
                    if (state.swapInfo.protocols != null &&
                        state.swapInfo.protocols!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Via: ${state.swapInfo.protocols!.join(", ")}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            // Amount Input
            Container(
              decoration: boxDecoration(
                Colors.transparent,
                20,
                0.5,
                Colors.grey[400]!,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBuy ? 'Pay' : 'Sell',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20,),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,),
                          onChanged: (value) {
                            final amount = double.tryParse(value) ?? 0;
                            bloc.add(NewTokenFromInputEvent(
                                tokenInputFromAmount: amount,),);
                          },
                        ),
                      ),
                      Text(
                        tokenFrom.ticker,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Balance
            Text(
              'Balance: ${state.tokenFromBalance.toStringAsFixed(4)} ${tokenFrom.ticker}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Spacer(),
            // Action Button
            if (state.status != BlocStatus.error)
              SwapApproveButton(
                tokenFromInputController: _amountController,
                tokenToInputController: _tokenToController,
                text: isBuy
                    ? 'Buy ${tokenTo.ticker}'
                    : 'Sell ${tokenFrom.ticker}',
                approveCallback: bloc.swapRepository.approve,
                confirmCallback: bloc.swapRepository.swap,
                confirmDialog: const TransactionStatusDialog(
                  title: 'Transaction Confirmed',
                  icons: Icons.check_circle_outline,
                ),
                fromCurrency: tokenFrom.name,
                toCurrency: tokenTo.name,
                fromUnits: _amountController.text,
                toUnits: state.swapInfo.receiveAmount.toStringAsFixed(6),
                totalFee: state.swapInfo.totalFee.toStringAsFixed(6),
                swapPageBloc: bloc,
              )
            else
              Column(
                children: [
                  WarningTextButton(
                    warningTitle: () {
                      final failure = state.failure;
                      if (failure is DisconnectedWalletFailure) {
                        return 'Wallet not connected!';
                      }
                      if (failure is NoSwapInfoFailure) {
                        return 'No swap info found';
                      }
                      if (failure is InSufficientFailure) {
                        return 'Insufficient Balance';
                      }
                      if (failure is NoLiquidityPoolFailure) {
                        return 'No liquidity pool exists for this pair';
                      }
                      if (failure is GraphQLFailure) {
                        return 'Service temporarily unavailable';
                      }
                      if (failure is NetworkFailure) {
                        return 'Network connection issue';
                      }
                      return 'Something went wrong';
                    }(),
                  ),
                  // Add retry button for GraphQL/Network errors
                  if (state.failure is GraphQLFailure ||
                      state.failure is NetworkFailure)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextButton(
                        onPressed: () {
                          bloc.add(FetchSwapInfoRequested());
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[800]!.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: Colors.grey[600]!, width: 0.5,),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12,),
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  // Help text for specific failures
                  if (state.failure is NoLiquidityPoolFailure)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'This trading pair has no liquidity. Try a different pair.',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }

  /// Returns the appropriate color for a given swap type
  Color _getSwapTypeColor(SwapType swapType) {
    switch (swapType) {
      case SwapType.direct:
        return const Color(0xFF4CAF50); // Green
      case SwapType.aggregated:
        return const Color(0xFF2196F3); // Blue
      case SwapType.crossChain:
        return const Color(0xFF9C27B0); // Purple
    }
  }
}
