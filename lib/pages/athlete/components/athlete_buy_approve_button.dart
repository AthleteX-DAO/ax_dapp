import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/blockchain_models/apt_buy_info.dart';
import 'package:ax_dapp/service/controller/wallet_controller.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

// This code changes the state of the button
class AthleteBuyApproveButton extends StatefulWidget {
  const AthleteBuyApproveButton({
    required this.width,
    required this.height,
    required this.text,
    required this.amountInputted,
    required this.aptBuyInfo,
    required this.athlete,
    required this.aptName,
    required this.aptId,
    required this.longOrShort,
    required this.approveCallback,
    required this.confirmCallback,
    required this.confirmDialog,
    super.key,
  });

  final String text;
  final double width;
  final double height;
  final String amountInputted;
  final AptBuyInfo aptBuyInfo;
  final AthleteScoutModel athlete;
  final String aptName;
  final int aptId;
  final String longOrShort;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;
  final Dialog Function(BuildContext) confirmDialog;

  @override
  State<AthleteBuyApproveButton> createState() =>
      _AthleteBuyApproveButtonState();
}

class _AthleteBuyApproveButtonState extends State<AthleteBuyApproveButton> {
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
            context.read<TrackingCubit>().trackAthleteBuyConfirmButtonClicked(
                  widget.aptId,
                );
            widget.confirmCallback().then((value) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) =>
                    widget.confirmDialog(context),
              );
              context.read<TrackingCubit>().trackAthleteBuySuccess(
                    widget.longOrShort,
                    widget.aptBuyInfo.receiveAmount,
                    widget.amountInputted,
                    'AX',
                    widget.aptBuyInfo.totalFee,
                    widget.athlete.sport.toString(),
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
            context.read<TrackingCubit>().trackAthleteBuyApproveButtonClicked(
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
