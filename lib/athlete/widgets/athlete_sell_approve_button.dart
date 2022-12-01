import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/service/blockchain_models/apt_sell_info.dart';
import 'package:ax_dapp/service/confirmation_dialogs/custom_confirmation_dialogs.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This code changes the state of the button
class AthleteSellApproveButton extends StatefulWidget {
  const AthleteSellApproveButton({
    required this.width,
    required this.height,
    required this.text,
    required this.amountInputted,
    required this.aptSellInfo,
    required this.athlete,
    required this.aptName,
    required this.aptId,
    required this.longOrShort,
    required this.approveCallback,
    required this.confirmCallback,
    required this.confirmDialog,
    required this.walletAddress,
    super.key,
  });

  final String text;
  final double width;
  final double height;
  final String amountInputted;
  final AptSellInfo aptSellInfo;
  final AthleteScoutModel athlete;
  final String aptName;
  final int aptId;
  final String longOrShort;
  final String walletAddress;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;
  final Widget confirmDialog;

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
          if (isApproved) {
            //Confirm button pressed
            context.read<TrackingCubit>().trackAthleteSellConfirmButtonClicked(
                  athleteName: widget.aptName,
                  id: widget.aptId,
                  sellPosition: widget.longOrShort,
                  unit: widget.amountInputted,
                  currencyReceive: widget.aptSellInfo.receiveAmount,
                  currency: 'AX',
                  totalFee: widget.aptSellInfo.totalFee,
                  sport: widget.athlete.sport.toString(),
                  walletId: widget.walletAddress,
                  valueInUSD: widget.aptSellInfo.receiveAmount * price,
                  feeInUSD: widget.aptSellInfo.axPrice *
                      widget.aptSellInfo.totalFee *
                      price,
                );
            widget.confirmCallback().then((value) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) => widget.confirmDialog,
              ).then((value) {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
              context.read<TrackingCubit>().trackAthleteSellSuccess(
                    athleteName: widget.aptName,
                    id: widget.aptId,
                    sellPosition: widget.longOrShort,
                    unit: widget.amountInputted,
                    currencyReceive: widget.aptSellInfo.receiveAmount,
                    currency: 'AX',
                    totalFee: widget.aptSellInfo.totalFee,
                    sport: widget.athlete.sport.toString(),
                    walletId: widget.walletAddress,
                    valueInUSD: widget.aptSellInfo.receiveAmount * price,
                    feeInUSD: widget.aptSellInfo.axPrice *
                        widget.aptSellInfo.totalFee *
                        price,
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
            context.read<TrackingCubit>().trackAthleteSellApproveButtonClicked(
                  athleteName: widget.aptName,
                  id: widget.aptId,
                  sellPosition: widget.longOrShort,
                  unit: widget.amountInputted,
                  currencyReceive: widget.aptSellInfo.receiveAmount,
                  currency: 'AX',
                  totalFee: widget.aptSellInfo.totalFee,
                  sport: widget.athlete.sport.toString(),
                  walletId: widget.walletAddress,
                  valueInUSD: widget.aptSellInfo.receiveAmount * price,
                  feeInUSD: widget.aptSellInfo.axPrice *
                      widget.aptSellInfo.totalFee *
                      price,
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
