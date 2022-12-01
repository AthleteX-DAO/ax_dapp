import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/service/confirmation_dialogs/custom_confirmation_dialogs.dart';
import 'package:ax_dapp/service/confirmation_dialogs/failed_dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    super.key,
  });

  final String text;
  final double width;
  final double height;
  final AthleteScoutModel athlete;
  final String aptName;
  final String inputApt;
  final double valueInAX;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;

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
    // Changes from approbe to waiting
    setState(() {
      text = 'Waiting for Approval';
      fillcolor = Colors.grey;
      textcolor = Colors.black;
    });
    //Changes from approve button to confirm
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
      ).then((value) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
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
    final usdValue = context.read<WalletBloc>().state.axData.price;
    final price = usdValue ?? 0;
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
          final walletAddress =
              context.read<WalletBloc>().state.formattedWalletAddress;
          if (isApproved) {
            //Confirm button pressed
            context.read<TrackingCubit>().trackAthleteMintConfirmButtonClicked(
                  aptName: '${widget.aptName} pair',
                  sport: widget.athlete.sport.toString(),
                  inputApt: widget.inputApt,
                  valueInAx: widget.valueInAX,
                  walletId: walletAddress,
                  valueInUSD: widget.valueInAX * price,
                );
            widget.confirmCallback().then((value) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) => TransactionConfirmed(
                  context: context,
                  isTrade: true,
                  isPool: true,
                ),
              ).then((value) {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
              context.read<TrackingCubit>().trackAthleteMintSuccess(
                    aptName: '${widget.aptName} pair',
                    sport: widget.athlete.sport.toString(),
                    inputApt: widget.inputApt,
                    valueInAx: widget.valueInAX,
                    walletId: walletAddress,
                    valueInUSD: widget.valueInAX * price,
                  );
            }).catchError((error) {
              showDialog<void>(
                context: context,
                builder: (context) => const FailedDialog(),
              ).then((value) {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
            });
          } else {
            //Approve button was pressed
            context.read<TrackingCubit>().trackAthleteMintApproveButtonClicked(
                  aptName: '${widget.aptName} pair',
                  sport: widget.athlete.sport.toString(),
                  inputApt: widget.inputApt,
                  valueInAx: widget.valueInAX,
                  walletId: walletAddress,
                  valueInUSD: widget.valueInAX * price,
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
