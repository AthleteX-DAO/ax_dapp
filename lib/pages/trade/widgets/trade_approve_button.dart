import 'package:ax_dapp/pages/trade/bloc/trade_page_bloc.dart';
import 'package:ax_dapp/service/confirmation_dialogs/custom_confirmation_dialogs.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This code changes the state of the button
class TradeApproveButton extends StatefulWidget {
  const TradeApproveButton({
    required this.tokenFromInputController,
    required this.tokenToInputController,
    required this.text,
    required this.approveCallback,
    required this.confirmCallback,
    required this.confirmDialog,
    required this.fromCurrency,
    required this.toCurrency,
    required this.fromUnits,
    required this.toUnits,
    required this.totalFee,
    required this.tradePageBloc,
    super.key,
  });

  final String text;
  final String fromCurrency;
  final String toCurrency;
  final String fromUnits;
  final String toUnits;
  final String totalFee;
  final TextEditingController tokenFromInputController;
  final TextEditingController tokenToInputController;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;
  final Widget confirmDialog;
  final TradePageBloc tradePageBloc;

  @override
  State<TradeApproveButton> createState() => _TradeApproveButtonState();
}

class _TradeApproveButtonState extends State<TradeApproveButton> {
  String text = '';
  bool isApproved = false;
  Color? fillcolor;
  Color? textcolor;
  Widget? dialog;

  @override
  void initState() {
    super.initState();
    text = widget.text;
    fillcolor = Colors.transparent;
    textcolor = Colors.amber;
  }

  void changeButton() {
    //Changes from approve to waiting
    setState(() {
      isApproved = true;
      text = 'Waiting for Approval';
      fillcolor = Colors.grey;
      textcolor = Colors.black;
    });
    //Changes from waiting button to confirm
    widget.approveCallback().then((_) {
      setState(() {
        isApproved = true;
        text = 'Confirm';
        fillcolor = Colors.amber;
        textcolor = Colors.black;
      });
    }).catchError((_) {
      showDialog<void>(
        context: context,
        builder: (context) => const FailedDialog(),
      );
      setState(() {
        isApproved = false;
        text = 'Approve';
        fillcolor = Colors.transparent;
        textcolor = Colors.amber;
      });
    });
  }

  void resetButton() {
    setState(() {
      isApproved = false;
      text = 'Approve';
      fillcolor = Colors.transparent;
      textcolor = Colors.amber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: 175,
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.amber),
            color: fillcolor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: TextButton(
            onPressed: () {
              final walletAddress =
                  context.read<WalletBloc>().state.formattedWalletAddress;
              if (isApproved) {
                context.read<TrackingCubit>().onSwapConfirmClick(
                      fromCurrency: widget.fromCurrency,
                      toCurrency: widget.toCurrency,
                      fromUnits: widget.fromUnits,
                      toUnits: widget.toUnits,
                      totalFee: widget.totalFee,
                      walletId: walletAddress,
                    );
                //Confirm button pressed
                widget.confirmCallback().then((value) {
                  final walletAddress =
                      context.read<WalletBloc>().state.formattedWalletAddress;
                  context.read<TrackingCubit>().onSwapConfirmedTransaction(
                        fromCurrency: widget.fromCurrency,
                        toCurrency: widget.toCurrency,
                        fromUnits: widget.fromUnits,
                        toUnits: widget.toUnits,
                        totalFee: widget.totalFee,
                        walletId: walletAddress,
                      );
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => widget.confirmDialog,
                  ).then((value) {
                    setState(() {
                      resetButton();
                      widget.tradePageBloc.add(FetchTradeInfoRequested());
                      widget.tokenFromInputController.clear();
                      widget.tokenToInputController.clear();
                    });
                  });
                }).catchError((error) {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const FailedDialog(),
                  );
                });
              } else {
                //Approve button was pressed
                context.read<TrackingCubit>().onSwapApproveClick(
                      fromCurrency: widget.fromCurrency,
                      toCurrency: widget.toCurrency,
                      fromUnits: widget.fromUnits,
                      toUnits: widget.toUnits,
                      totalFee: widget.totalFee,
                      walletId: walletAddress,
                    );
                changeButton();
              }
            },
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: textcolor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
