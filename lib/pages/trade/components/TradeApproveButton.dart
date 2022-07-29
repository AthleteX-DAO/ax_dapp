// ignore_for_file: file_names

import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This code changes the state of the button
class TradeApproveButton extends StatefulWidget {
  const TradeApproveButton(
    this.width,
    this.height,
    this.text,
    this.approveCallback,
    this.confirmCallback,
    this.confirmDialog,
    this.fromCurrency,
    this.toCurrency,
    this.fromUnits,
    this.toUnits,
    this.totalFee, 
    this.walletAddress, {
    super.key,
  });

  final String text;
  final double width;
  final double height;
  final String fromCurrency;
  final String toCurrency;
  final String fromUnits;
  final String toUnits;
  final double totalFee;
  final String walletAddress;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;
  final Dialog Function(BuildContext) confirmDialog;

  @override
  State<TradeApproveButton> createState() => _TradeApproveButtonState();
}

class _TradeApproveButtonState extends State<TradeApproveButton> {
  double width = 0;
  double height = 0;
  String text = '';
  bool isApproved = false;
  Color? fillcolor;
  Color? textcolor;
  int currentState = 0;
  Widget? dialog;

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
    text = widget.text;
    fillcolor = Colors.transparent;
    textcolor = Colors.amber;
    currentState = 0;
  }

  void changeButton() {
    //Changes from approve button to confirm
    widget.approveCallback().then((_) {
      setState(() {
        isApproved = true;
        text = 'Confirm';
        fillcolor = Colors.amber;
        textcolor = Colors.black;
      });
    }).catchError((_) {
      setState(() {
        isApproved = false;
        text = 'Approve';
        fillcolor = Colors.transparent;
        textcolor = Colors.amber;
      });
    });
    // Keep track of how many times the state has changed
    currentState += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        color: fillcolor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextButton(
        onPressed: () {
          // Testing to see how the popup will work when the state is changed
          if (isApproved) {
            //Confirm button pressed
            widget.confirmCallback().then((value) {
              context.read<TrackingCubit>().onSwapConfirmedTransaction(
                  widget.fromCurrency,
                  widget.toCurrency,
                  widget.fromUnits,
                  widget.toUnits,
                  widget.totalFee,
                  widget.walletAddress,
                );
              showDialog<void>(
                context: context,
                builder: (BuildContext context) =>
                    widget.confirmDialog(context),
              );
            }).catchError((error) {
              showDialog<void>(
                context: context,
                builder: (context) => const FailedDialog(),
              );
            });
          } else {
            //Approve button was pressed
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
    );
  }
}
