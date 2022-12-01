import 'package:ax_dapp/add_liquidity/add_liquidity.dart';
import 'package:ax_dapp/service/confirmation_dialogs/custom_confirmation_dialogs.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This code changes the state of the button
class PoolApproveButton extends StatefulWidget {
  const PoolApproveButton({
    required this.tokenAmountOneController,
    required this.tokenAmountTwoController,
    required this.width,
    required this.text,
    required this.approveCallback,
    required this.confirmCallback,
    required this.currencyOne,
    required this.currencyTwo,
    required this.lpTokens,
    required this.valueOne,
    required this.valueTwo,
    required this.shareOfPool,
    required this.lpTokenName,
    super.key,
  });

  final TextEditingController tokenAmountOneController;
  final TextEditingController tokenAmountTwoController;
  final String text;
  final double width;
  final String currencyOne;
  final String currencyTwo;
  final String valueOne;
  final String valueTwo;
  final String lpTokens;
  final String shareOfPool;
  final String lpTokenName;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;

  @override
  State<PoolApproveButton> createState() => _PoolApproveButtonState();
}

class _PoolApproveButtonState extends State<PoolApproveButton> {
  double width = 0;
  double height = 40;
  String text = '';
  bool isApproved = false;
  Color? fillcolor;
  Color? textcolor;

  @override
  void initState() {
    super.initState();
    width = widget.width;
    text = widget.text;
    fillcolor = Colors.transparent;
    textcolor = Colors.amber;
  }

  void changeButton() {
    //Changes from approve to waiting
    setState(() {
      text = 'Waiting for Approval';
      fillcolor = Colors.grey;
      textcolor = Colors.black;
    });
    //Changes from waiting button to confirm
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
      );
      setState(() {
        isApproved = false;
        text = 'Approve';
        fillcolor = Colors.transparent;
        textcolor = Colors.amber;
      });
    });
  }

  void resetButton() {
    setState(() {
      isApproved = false;
      text = 'Approve';
      fillcolor = Colors.transparent;
      textcolor = Colors.amber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddLiquidityBloc>();
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
            context.read<TrackingCubit>().onPoolConfirmClick(
                  currencyOne: widget.currencyOne,
                  currencyTwo: widget.currencyTwo,
                  valueOne: widget.valueOne,
                  valueTwo: widget.valueTwo,
                  lpTokens: widget.lpTokens,
                  shareOfPool: widget.shareOfPool,
                  lpTokenName: widget.lpTokenName,
                  walletId: walletAddress,
                );
            //Confirm button pressed
            widget.confirmCallback().then((value) {
              final walletAddress =
                  context.read<WalletBloc>().state.formattedWalletAddress;
              context.read<TrackingCubit>().onPoolCreated(
                    currencyOne: widget.currencyOne,
                    currencyTwo: widget.currencyTwo,
                    valueOne: widget.valueOne,
                    valueTwo: widget.valueTwo,
                    lpTokens: widget.lpTokens,
                    shareOfPool: widget.shareOfPool,
                    lpTokenName: widget.lpTokenName,
                    walletId: walletAddress,
                  );
              showDialog<void>(
                context: context,
                builder: (BuildContext context) => TransactionConfirmed(
                  context: context,
                  isFarm: true,
                ),
              ).then((value) {
                resetButton();
                bloc.add(const FetchPairInfoRequested());
                widget.tokenAmountOneController.clear();
                widget.tokenAmountTwoController.clear();
              });
            }).catchError((error) {
              showDialog<void>(
                context: context,
                builder: (context) => const FailedDialog(),
              ).then((value) => resetButton());
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
                  walletId: walletAddress,
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
