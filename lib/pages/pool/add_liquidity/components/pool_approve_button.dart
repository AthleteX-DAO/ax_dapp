import 'package:ax_dapp/service/failed_dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/message.dart';
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
    required this.walletId,
    required this.animateToPage,
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
  final String walletId;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;
  final void Function(int pageNumber) animateToPage;
  final Dialog Function(
    BuildContext, {
    void Function(int pageNumber) animatePage,
    bool isTradeLink,
    bool isPoolLink,
    bool isFarmLink,
  }) confirmDialog;

  @override
  State<PoolApproveButton> createState() => _PoolApproveButtonState();
}

class _PoolApproveButtonState extends State<PoolApproveButton> {
  double width = 0;
  double height = 0;
  String text = '';
  bool isApproved = false;
  bool isLoading = false;
  Color? fillcolor;
  Color? textcolor;
  Widget? dialog;

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
    text = widget.text;
    fillcolor = Colors.transparent;
    textcolor = Colors.amber;
  }

  void changeButton() {
    //Changes from approve button to confirm
    widget.approveCallback().then((_) {
      setState(() {
        isApproved = true;
        isLoading = false;
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
          if (isLoading) return;
          if (isApproved) {
            context.read<TrackingCubit>().onPoolConfirmClick(
                  currencyOne: widget.currencyOne,
                  currencyTwo: widget.currencyTwo,
                  valueOne: widget.valueOne,
                  valueTwo: widget.valueTwo,
                  lpTokens: widget.lpTokens,
                  shareOfPool: widget.shareOfPool,
                  lpTokenName: widget.lpTokenName,
                  walletId: widget.walletId,
                );
            //Confirm button pressed
            widget.confirmCallback().then((value) {
              context.read<TrackingCubit>().onPoolCreated(
                    currencyOne: widget.currencyOne,
                    currencyTwo: widget.currencyTwo,
                    valueOne: widget.valueOne,
                    valueTwo: widget.valueTwo,
                    lpTokens: widget.lpTokens,
                    shareOfPool: widget.shareOfPool,
                    lpTokenName: widget.lpTokenName,
                    walletId: widget.walletId,
                  );
              showDialog<void>(
                context: context,
                builder: (BuildContext context) => widget.confirmDialog(
                  context,
                  animatePage: widget.animateToPage,
                  isTradeLink: false,
                  isPoolLink: false,
                  isFarmLink: true,
                ),
              );
            }).catchError((error) {
              showDialog<void>(
                context: context,
                builder: (context) => const FailedDialog(),
              );
            });
          } else {
            //Approve button was pressed
            context.read<TrackingCubit>().onPoolApproveClick(
                  currencyOne: widget.currencyOne,
                  currencyTwo: widget.currencyTwo,
                  valueOne: widget.valueOne,
                  valueTwo: widget.valueTwo,
                  lpTokens: widget.lpTokens,
                  shareOfPool: widget.shareOfPool,
                  lpTokenName: widget.lpTokenName,
                  walletId: widget.walletId,
                );

            setState(() {
              text = Message.waitingApproval;
              isLoading = true;
            });
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
