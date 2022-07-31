import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/blockchain_models/apt_sell_info.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

// This code changes the state of the button
class AthleteSellApproveButton extends StatefulWidget {
  const AthleteSellApproveButton(
    this.width,
    this.height,
    this.text,
    this.amountImputed,
    this.aptSellInfo,
    this.athlete,
    this.aptName,
    this.aptId,
    this.longOrShort,
    this.approveCallback,
    this.confirmCallback,
    this.confirmDialog, {
    super.key,
  });

  final String text;
  final double width;
  final double height;
  final String amountImputed;
  final AptSellInfo aptSellInfo;
  final AthleteScoutModel athlete;
  final String aptName;
  final int aptId;
  final String longOrShort;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;
  final Dialog Function(BuildContext) confirmDialog;

  @override
  State<AthleteSellApproveButton> createState() =>
      _AthleteSellApproveButtonState();
}

class _AthleteSellApproveButtonState extends State<AthleteSellApproveButton> {
  double width = 0;
  double height = 0;
  String text = '';
  bool isApproved = false;
  Color? fillcolor;
  Color? textcolor;
  int currentState = 0;
  Widget? dialog;
  final controller = Get.find<Controller>();

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
          context.read<TrackingCubit>().onPressedAthleteSell(
            widget.aptName,
          );
          if (isApproved) {
            //Confirm button pressed
            context.read<TrackingCubit>().onPressedConfirmSell(
              widget.aptId,
            );
            widget.confirmCallback().then((value) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) =>
                    widget.confirmDialog(context),
              );
              context.read<TrackingCubit>().onAthleteSellSuccess(
                widget.longOrShort,
                widget.athlete.id,
                widget.amountImputed,
                'AX',
                widget.aptSellInfo.totalFee,
                widget.athlete.sport.toString(),
                controller.publicAddress,
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
