import 'package:ax_dapp/pages/farm/modules/axl_info.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/service/failed_dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This code changes the state of the button
class StakeApproveButton extends StatefulWidget {
  const StakeApproveButton({
    required this.width,
    required this.height,
    required this.text,
    required this.confirmDialog,
    required this.selectedFarm,
    required this.walletAddress,
    super.key,
  });

  final String text;
  final double width;
  final double height;
  final FarmController selectedFarm;
  final String walletAddress;
  final Dialog Function(BuildContext) confirmDialog;

  @override
  State<StakeApproveButton> createState() => _StakeApproveButtonState();
}

class _StakeApproveButtonState extends State<StakeApproveButton> {
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

  AxlInfo getStakeInfo() {
    final tickerPair = widget.selectedFarm.athlete == null
        ? widget.selectedFarm.strName
        : widget.selectedFarm.athlete!;
    final tickerPairName = widget.selectedFarm.strStakedAlias.value.isNotEmpty
        ? widget.selectedFarm.strStakedAlias.value
        : widget.selectedFarm.strStakedSymbol.value;
    final axlInput = widget.selectedFarm.strStakeInput.value;
    final axlBalance = widget.selectedFarm.stakingInfo.value.viewAmount;
    return AxlInfo(tickerPair, tickerPairName, axlBalance, axlInput);
  }

  void changeButton() {
    //Changes from approve button to confirm
    widget.selectedFarm.approve().then((_) {
      setState(() {
        isApproved = true;
        text = 'Confirm';
        fillcolor = Colors.amber;
        textcolor = Colors.black;
      });

      final info = getStakeInfo();
      context.read<TrackingCubit>().onPressedStake(
            tickerPair: info.tickerPair,
            tickerPairName: info.tickerPairName,
            axlInput: info.axlInput,
            axlBalance: info.axlBalance,
            walletId: widget.walletAddress,
          );
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
            final info = getStakeInfo();
            context.read<TrackingCubit>().onPressedStakeConfirm(
                  tickerPair: info.tickerPair,
                  tickerPairName: info.tickerPairName,
                  axlInput: info.axlInput,
                  axlBalance: info.axlBalance,
                  walletId: widget.walletAddress,
                );
            //Confirm button pressed
            widget.selectedFarm.stake().then((value) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) =>
                    widget.confirmDialog(context),
              ).then((value) {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
              final info = getStakeInfo();
              context.read<TrackingCubit>().onStakeSuccess(
                    tickerPair: info.tickerPair,
                    tickerPairName: info.tickerPairName,
                    axlInput: info.axlInput,
                    axlBalance: info.axlBalance,
                    walletId: widget.walletAddress,
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
