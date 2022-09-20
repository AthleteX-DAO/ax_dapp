import 'package:ax_dapp/my_liquidity/bloc/my_liquidity_bloc.dart';
import 'package:ax_dapp/service/failed_dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This code changes the state of the button
class PoolRemoveApproveButton extends StatefulWidget {
  const PoolRemoveApproveButton({
    required this.tabController,
    required this.width,
    required this.height,
    required this.text,
    required this.approveCallback,
    required this.confirmCallback,
    required this.confirmDialog,
    required this.currencyOne,
    required this.currencyTwo,
    required this.valueOne,
    required this.valueTwo,
    required this.lpTokens,
    required this.shareOfPool,
    required this.percentRemoval,
    required this.lpTokenName,
    required this.myLiquidityBloc,
    super.key,
  });
  final TabController tabController;
  final String text;
  final double width;
  final double height;
  final String currencyOne;
  final String currencyTwo;
  final double valueOne;
  final double valueTwo;
  final String lpTokens;
  final String shareOfPool;
  final double percentRemoval;
  final String lpTokenName;
  final Future<void> Function() approveCallback;
  final Future<void> Function() confirmCallback;
  final Widget confirmDialog;
  final MyLiquidityBloc myLiquidityBloc;

  @override
  State<PoolRemoveApproveButton> createState() =>
      _PoolRemoveApproveButtonState();
}

class _PoolRemoveApproveButtonState extends State<PoolRemoveApproveButton> {
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
          final walletAddress =
              context.read<WalletBloc>().state.formattedWalletAddress;
          if (isApproved) {
            context.read<TrackingCubit>().onPoolRemovalConfirmClick(
                  currencyOne: widget.currencyOne,
                  currencyTwo: widget.currencyTwo,
                  valueOne: widget.valueOne,
                  valueTwo: widget.valueTwo,
                  lpTokens: widget.lpTokens,
                  shareOfPool: widget.shareOfPool,
                  percentRemoval: widget.percentRemoval,
                  walletId: walletAddress,
                  lpTokenName: widget.lpTokenName,
                );
            //Confirm button pressed
            widget.confirmCallback().then((value) {
              final walletAddress =
                  context.read<WalletBloc>().state.formattedWalletAddress;
              context.read<TrackingCubit>().onPoolRemoval(
                    currencyOne: widget.currencyOne,
                    currencyTwo: widget.currencyTwo,
                    valueOne: widget.valueOne,
                    valueTwo: widget.valueTwo,
                    lpTokens: widget.lpTokens,
                    shareOfPool: widget.shareOfPool,
                    percentRemoval: widget.percentRemoval,
                    walletId: walletAddress,
                    lpTokenName: widget.lpTokenName,
                  );
              showDialog<void>(
                context: context,
                builder: (BuildContext context) => widget.confirmDialog,
              ).then((value) {
                //show loading spinner
                widget.myLiquidityBloc
                    .add(const FetchAllLiquidityPositionsRequested());
                setState(() {
                  widget.tabController.index = 0;
                });
                context.showWarningToast(
                  title: 'Disclaimer',
                  description: 'Card info may take a few seconds to refresh',
                );
              });
            }).catchError((error) {
              showDialog<void>(
                context: context,
                builder: (context) => const FailedDialog(),
              );
            });
          } else {
            //Approve button was pressed
            context.read<TrackingCubit>().onPoolRemovalApproveClick(
                  currencyOne: widget.currencyOne,
                  currencyTwo: widget.currencyTwo,
                  valueOne: widget.valueOne,
                  valueTwo: widget.valueTwo,
                  lpTokens: widget.lpTokens,
                  shareOfPool: widget.shareOfPool,
                  percentRemoval: widget.percentRemoval,
                  walletId: walletAddress,
                  lpTokenName: widget.lpTokenName,
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
