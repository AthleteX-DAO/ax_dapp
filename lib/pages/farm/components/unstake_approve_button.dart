import 'package:ax_dapp/pages/farm/modules/axl_info.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/user_input_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This code changes the state of the button
class UnStakeApproveButton extends StatefulWidget {
  const UnStakeApproveButton(
    this.width,
    this.height,
    this.text,
    this.confirmDialog,
    this.selectedFarm, {
    super.key,
  });

  final String text;
  final double width;
  final double height;
  final FarmController selectedFarm;
  final Dialog Function(BuildContext) confirmDialog;

  @override
  State<UnStakeApproveButton> createState() => _UnStakeApproveButtonState();
}

class _UnStakeApproveButtonState extends State<UnStakeApproveButton> {
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

  AxlInfo getUnStakeInfo() {
    final tickerPair = widget.selectedFarm.strStakeTokenAddress;
    final tickerPairName = widget.selectedFarm.strStakedAlias.value.isNotEmpty
        ? widget.selectedFarm.strStakedAlias.value
        : widget.selectedFarm.strStakedSymbol.value;
    final axlBalance =
        widget.selectedFarm.stakingInfo.value.rawAmount.toString();

    final inputInfo = UserInputInfo.fromInput(
      inputAmount: widget.selectedFarm.strUnStakeInput.value,
      decimals: widget.selectedFarm.nStakeTokenDecimals,
    );
    final axlInput = widget.selectedFarm
        .getMaximumAmount(
          widget.selectedFarm.stakingInfo.value,
          inputInfo,
        )
        .toString();
    return AxlInfo(tickerPair, tickerPairName, axlBalance, axlInput);
  }

  void changeButton() {
    //Changes from approve button to confirm
    setState(() {
      isApproved = true;
      text = 'Confirm';
      fillcolor = Colors.amber;
      textcolor = Colors.black;
    });

    final info = getUnStakeInfo();
    context.read<TrackingCubit>().onPressedUnStake(
          tickerPair: info.tickerPair,
          tickerPairName: info.tickerPairName,
          axlInput: info.axlInput,
          axlBalance: info.axlBalance,
        );
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
            final info = getUnStakeInfo();
            context.read<TrackingCubit>().onPressedUnStakeConfirm(
                  tickerPair: info.tickerPair,
                  tickerPairName: info.tickerPairName,
                  axlInput: info.axlInput,
                  axlBalance: info.axlBalance,
                );
            //Confirm button pressed
            widget.selectedFarm.unstake().then((value) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) =>
                    widget.confirmDialog(context),
              );

              final info = getUnStakeInfo();
              context.read<TrackingCubit>().onUnStakeSuccess(
                    tickerPair: info.tickerPair,
                    tickerPairName: info.tickerPairName,
                    axlInput: info.axlInput,
                    axlBalance: info.axlBalance,
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
