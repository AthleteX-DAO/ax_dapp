import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/controller/usecases/get_total_token_balance_use_case.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/responsive_constants.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/trade_slip/trade_slip.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Inline prediction interface shown on market cards
/// Shows amount input, quick-add buttons, and win calculation
class InlineBettingInterface extends StatefulWidget {
  const InlineBettingInterface({
    super.key,
    required this.predictionModel,
    required this.isYes,
    required this.onPredict,
    required this.expanded,
  });

  final PredictionModel predictionModel;
  final bool isYes;
  final void Function(double amount)? onPredict;
  final bool expanded;

  @override
  State<InlineBettingInterface> createState() => _InlineBettingInterfaceState();
}

class _InlineBettingInterfaceState extends State<InlineBettingInterface> {
  late TextEditingController _amountController;
  double _sliderValue = 10;
  late double _maxBet;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '10');
    _maxBet = 0;
    _loadWalletBalance();
  }

  Future<void> _loadWalletBalance() async {
    try {
      final balance = await context
          .read<GetTotalTokenBalanceUseCase>()
          .getTotalAxBalance();
      if (mounted) {
        setState(() => _maxBet = balance);
      }
    } catch (_) {
      // Wallet not connected — leave at 0
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _updateAmount(double amount) {
    _sliderValue = amount.clamp(0, _maxBet);
    _amountController.text = _sliderValue.toStringAsFixed(0);
    setState(() {});
  }

  double _calculateWinnings(double amount) {
    final price = widget.isYes
        ? (widget.predictionModel.longTokenPrice ?? 0)
        : (widget.predictionModel.shortTokenPrice ?? 0);
    if (price == 0) return 0;
    return (amount / price) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final winnings = _calculateWinnings(_sliderValue);
    final padding =
        ResponsiveConstants.getPadding(width, size: PaddingSize.medium);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      height: widget.expanded ? null : 0,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: widget.expanded
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Amount input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true,),
                            style: textStyle(
                              Colors.white,
                              16,
                              isBold: true,
                              isUline: false,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Amount',
                              hintStyle: textStyle(
                                Colors.white38,
                                14,
                                isBold: false,
                                isUline: false,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: padding,
                                vertical: padding / 2,
                              ),
                            ),
                            onChanged: (value) {
                              _updateAmount(double.tryParse(value) ?? 0);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Quick add buttons
                        _QuickAddButton(
                          label: '+1',
                          onTap: () => _updateAmount(_sliderValue + 1),
                        ),
                        const SizedBox(width: 6),
                        _QuickAddButton(
                          label: '+10',
                          onTap: () => _updateAmount(_sliderValue + 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: textStyle(
                            Colors.white70,
                            12,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                        Slider(
                          value: _sliderValue,
                          max: _maxBet,
                          onChanged: _updateAmount,
                          activeColor: widget.isYes
                              ? primaryGreenColor
                              : primaryRedColor,
                          inactiveColor: Colors.white.withOpacity(0.1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Win calculation display
                    Container(
                      padding: EdgeInsets.all(padding / 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Earn',
                                style: textStyle(
                                  Colors.white70,
                                  12,
                                  isBold: false,
                                  isUline: false,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '3.25% Interest',
                                style: textStyle(
                                  primaryGreenColor,
                                  12,
                                  isBold: true,
                                  isUline: false,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${_sliderValue.toStringAsFixed(0)}',
                                style: textStyle(
                                  Colors.white,
                                  16,
                                  isBold: true,
                                  isUline: false,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'To win \$${winnings.toStringAsFixed(2)}',
                                style: textStyle(
                                  Colors.white70,
                                  12,
                                  isBold: false,
                                  isUline: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Predict button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isYes
                              ? primaryGreenColor
                              : primaryRedColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          context.read<TrackingCubit>().trackPredictionBuyPressed(
                            marketName: widget.predictionModel.prompt,
                            side: widget.isYes ? 'Yes' : 'No',
                            amount: _sliderValue,
                            walletId: '',
                          );
                          widget.onPredict?.call(_sliderValue);

                          // Show trade slip confirmation
                          final price = widget.isYes
                              ? widget.predictionModel.longTokenPrice
                              : widget.predictionModel.shortTokenPrice;
                          if (context.mounted) {
                            TradeSlipDialog.show(
                              context,
                              slip: TradeSlipData(
                                type: SlipType.prediction,
                                side: widget.isYes
                                    ? SlipSide.yes
                                    : SlipSide.no,
                                status: SlipStatus.pending,
                                marketName:
                                    widget.predictionModel.prompt,
                                amount: _sliderValue,
                                price: price,
                                potentialPayout: price > 0
                                    ? _sliderValue / price
                                    : 0,
                                yesPrice: widget
                                    .predictionModel.longTokenPrice,
                                noPrice: widget
                                    .predictionModel.shortTokenPrice,
                                marketAddress: widget
                                    .predictionModel.marketAddress,
                                timestamp: DateTime.now(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Predict ${widget.isYes ? 'Yes' : 'No'}',
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
            )
          : const SizedBox.shrink(),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: textStyle(
            Colors.white70,
            12,
            isBold: true,
            isUline: false,
          ),
        ),
      ),
    );
  }
}
