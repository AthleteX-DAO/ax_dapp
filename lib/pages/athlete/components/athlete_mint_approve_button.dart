import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/controller/wallet_controller.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

// This code changes the state of the button
class AthleteMintApproveButton extends StatefulWidget {
  const AthleteMintApproveButton({
    required this.width,
    required this.height,
    required this.text,
    required this.athlete,
    required this.aptName,
    required this.inputApt,
    required this.valueInAX,
    required this.approveCallback,
    required this.confirmCallback,
    required this.confirmDialog,
    super.key,
  });

  final String text;
  final double width;
  final double height;
  final AthleteScoutModel athlete;
  final String aptName;
  final String inputApt;
  final String valueInAX;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;
  final Dialog Function(BuildContext) confirmDialog;

  @override
  State<AthleteMintApproveButton> createState() =>
      _AthleteMintApproveButtonState();
}

class _AthleteMintApproveButtonState extends State<AthleteMintApproveButton> {
  double width = 0;
  double height = 0;
  String text = '';
  bool isApproved = false;
  Color? fillcolor;
  Color? textcolor;
  Widget? dialog;
  final walletController = Get.find<WalletController>();

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
  }

  @override
  Widget build(BuildContext context) {
    final userWalletAddress =
        walletController.controller.publicAddress.toString();
    final walletInt = BigInt.parse(userWalletAddress);
    final walletAddress = walletInt.toRadixString(16);
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
          if (isApproved) {
            //Confirm button pressed
            context.read<TrackingCubit>().trackAthleteMintConfirmButtonClicked(
                  widget.athlete.sport.toString(),
                );
            widget.confirmCallback().then((value) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) =>
                    widget.confirmDialog(context),
              );
              context.read<TrackingCubit>().trackAthleteMintSuccess(
                    widget.inputApt,
                    widget.valueInAX,
                    walletAddress,
                  );
            }).catchError((error) {
              showDialog<void>(
                context: context,
                builder: (context) => const FailedDialog(),
              );
            });
          } else {
            //Approve button was pressed
            context.read<TrackingCubit>().trackAthleteMintApproveButtonClicked(
                  widget.aptName,
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
    );
  }
}
