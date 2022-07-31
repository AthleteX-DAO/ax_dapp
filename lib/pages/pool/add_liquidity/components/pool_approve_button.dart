import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This code changes the state of the button
class PoolApproveButton extends StatefulWidget {
  const PoolApproveButton({
    required this.width,
    required this.height,
    required this.text,
    required this.approveCallback,
    required this.confirmCallback,
    required this.confirmDialog, 
    required this.currencyOne,
    required this.currencyTwo,
    required this.lpTokens,
    required this.valueOne,
    required this.valueTwo, 
    required this.shareOfPool,
    required this.lpTokenName, 
    super.key,
  });

  final String text;
  final double width;
  final double height;
  final String currencyOne;
  final String currencyTwo;
  final String valueOne;
  final String valueTwo;
  final String lpTokens;
  final String shareOfPool;
  final String lpTokenName;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;
  final Dialog Function(BuildContext) confirmDialog;

  @override
  State<PoolApproveButton> createState() => _PoolApproveButtonState();
}

class _PoolApproveButtonState extends State<PoolApproveButton> {
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
              context
                  .read<TrackingCubit>()
                  .onPoolConfirmClick(widget.currencyTwo);
              context.read<TrackingCubit>().onPoolCreated(
                  widget.valueOne,
                  widget.valueTwo,
                  widget.lpTokens,
                  widget.shareOfPool,
                  widget.lpTokenName,);
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
            context
                .read<TrackingCubit>()
                .onPoolApproveClick(widget.currencyOne);
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
