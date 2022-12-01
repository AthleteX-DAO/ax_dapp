import 'package:ax_dapp/dialogs/redeem/bloc/redeem_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/redeem/widgets/widgets.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/service/confirmation_dialogs/custom_confirmation_dialogs.dart';
import 'package:ax_dapp/service/confirmation_dialogs/failed_dialog.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/helper.dart';
import 'package:ax_dapp/util/warning_text_button.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RedeemDialog extends StatefulWidget {
  const RedeemDialog(
    this.athlete,
    this.aptName,
    this.inputLongApt,
    this.inputShortApt,
    this.valueInAX, {
    super.key,
  });

  final AthleteScoutModel athlete;
  final String aptName;
  final String inputLongApt;
  final String inputShortApt;
  final String valueInAX;

  @override
  State<RedeemDialog> createState() => _RedeemDialogState();
}

class _RedeemDialogState extends State<RedeemDialog> {
  double paddingHorizontal = 40;
  double hgt = 450;
  double newAmount = 0;
  final TextEditingController _longInputController = TextEditingController();
  final TextEditingController _shortInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _height = MediaQuery.of(context).size.height;
    final wid = isWeb ? 400.0 : 355.0;
    if (_height < 505) hgt = _height;
    final usdValue = context.read<WalletBloc>().state.axData.price;
    final price = usdValue ?? 0;

    return BlocConsumer<RedeemDialogBloc, RedeemDialogState>(
      listenWhen: (_, current) =>
          current.status == BlocStatus.error ||
          current.status == BlocStatus.noData,
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = context.read<RedeemDialogBloc>();
        final shortBalance = state.shortBalance;
        final longBalance = state.longBalance;
        final receiveAmount = state.receiveAmount;
        final collateralPerPair = state.collateralPerPair;
        final smallestBalance = state.smallestBalance;
        final longInput = state.longRedeemInput;
        final shortInput = state.shortRedeemInput;
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            height: hgt,
            width: wid,
            decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: wid,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.zero,
                          child: Text(
                            'Redeem ${widget.athlete.name} APT Pair',
                            style: textStyle(
                              Colors.white,
                              20,
                              isBold: false,
                              isUline: false,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: wid,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "You can redeem APT's at their Book Value for AX.",
                          style: textStyle(
                            Colors.grey[600]!,
                            isWeb ? 14 : 12,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                        TextSpan(
                          text:
                              ''' Visit the Trade page to swap APT's and AX.''',
                          style: textStyle(
                            Colors.grey[600]!,
                            isWeb ? 14 : 12,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                        TextSpan(
                          text: ' Trade Page',
                          style: textStyle(
                            Colors.amber[400]!,
                            isWeb ? 14 : 12,
                            isBold: false,
                            isUline: false,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.goNamed('trade');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Input APT pair - Max Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isWeb
                              ? 'Input APT pair:'
                              : 'Input APT pair and amount:',
                          style: textStyle(
                            Colors.grey[600]!,
                            14,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 28,
                          width: 48,
                          decoration: boxDecoration(
                            Colors.transparent,
                            100,
                            0.5,
                            Colors.grey[400]!,
                          ),
                          child: TextButton(
                            onPressed: () {
                              bloc.add(
                                OnMaxRedeemTap(
                                  athleteId: widget.athlete.id,
                                ),
                              );
                              _longInputController.text =
                                  toDecimal(smallestBalance, 6);
                              _shortInputController.text =
                                  toDecimal(smallestBalance, 6);
                            },
                            child: Text(
                              'MAX',
                              style: textStyle(
                                Colors.grey[400]!,
                                9,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Long APT input box
                    Container(
                      width: wid,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.grey[400]!,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    scale: 0.5,
                                    image: AssetImage(
                                      'assets/images/apt_noninverted.png',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Long APTs',
                                  style: textStyle(
                                    Colors.white,
                                    15,
                                    isBold: false,
                                    isUline: false,
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxWidth: wid * 0.4),
                                child: IntrinsicWidth(
                                  child: TextField(
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    controller: _longInputController,
                                    style: textStyle(
                                      Colors.grey[400]!,
                                      22,
                                      isBold: false,
                                      isUline: false,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                      hintStyle: textStyle(
                                        Colors.grey[400]!,
                                        22,
                                        isBold: false,
                                        isUline: false,
                                      ),
                                      contentPadding: isWeb
                                          ? const EdgeInsets.all(9)
                                          : const EdgeInsets.all(6),
                                      border: InputBorder.none,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^(\d+)?\.?\d{0,6}'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value == '') {
                                        value = '0.00';
                                      }
                                      _shortInputController.text = value;
                                      bloc.add(
                                        OnLongRedeemInput(
                                          redeemLongInputAmount:
                                              double.parse(value),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          LongBalance(longBalance: longBalance),
                        ],
                      ),
                    ),
                    Container(height: 10),
                    Container(
                      width: wid,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.grey[400]!,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    scale: 0.5,
                                    image: AssetImage(
                                      'assets/images/apt_inverted.png',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Short APTs',
                                  style: textStyle(
                                    Colors.white,
                                    15,
                                    isBold: false,
                                    isUline: false,
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxWidth: wid * 0.4),
                                child: IntrinsicWidth(
                                  child: TextField(
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    controller: _shortInputController,
                                    style: textStyle(
                                      Colors.grey[400]!,
                                      22,
                                      isBold: false,
                                      isUline: false,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                      hintStyle: textStyle(
                                        Colors.grey[400]!,
                                        22,
                                        isBold: false,
                                        isUline: false,
                                      ),
                                      contentPadding: isWeb
                                          ? const EdgeInsets.all(9)
                                          : const EdgeInsets.all(6),
                                      border: InputBorder.none,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^(\d+)?\.?\d{0,6}'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value == '') {
                                        value = '0.00';
                                      }
                                      _longInputController.text = value;
                                      bloc.add(
                                        OnShortRedeemInput(
                                          redeemShortInputAmount:
                                              double.parse(value),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ShortBalance(shortBalance: shortBalance),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 0.35,
                  color: Colors.grey[400],
                ),
                ReceiveAmount(receiveAmount: receiveAmount),
                SizedBox(
                  width: wid,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if ((longBalance >= longInput &&
                              longBalance >= shortInput) &&
                          (shortBalance >= shortInput) &&
                          shortBalance >= longInput) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          width: 175,
                          height: 45,
                          decoration: boxDecoration(
                            Colors.amber[500]!.withOpacity(0.20),
                            500,
                            1,
                            Colors.transparent,
                          ),
                          child: TextButton(
                            onPressed: () async {
                              final result = await bloc.lspController.redeem();
                              if (result) {
                                await showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const TransactionStatusDialog(
                                    title: 'Transaction Confirmed',
                                    icons: Icons.check_circle_outline,
                                  ),
                                ).then((value) {
                                  final walletAddress = context
                                      .read<WalletBloc>()
                                      .state
                                      .formattedWalletAddress;
                                  context
                                      .read<TrackingCubit>()
                                      .trackAthleteRedeemSuccess(
                                        name: '${widget.athlete.name} pair',
                                        sport: widget.athlete.sport.toString(),
                                        inputLongApt: _longInputController.text,
                                        inputShortApt:
                                            _shortInputController.text,
                                        valueInAx:
                                            (bloc.lspController.redeemAmt *
                                                    collateralPerPair)
                                                .toStringAsFixed(6),
                                        walletId: walletAddress,
                                        valueInUSD:
                                            (bloc.lspController.redeemAmt *
                                                    collateralPerPair) *
                                                price,
                                      );
                                });
                              } else {
                                await showDialog<void>(
                                  context: context,
                                  builder: (context) => const FailedDialog(),
                                );
                              }
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Confirm',
                              style: textStyle(
                                Colors.amber[500]!,
                                16,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        const WarningTextButton(
                          warningTitle: 'Insufficient Balance',
                        )
                      ]
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _longInputController.dispose();
    _shortInputController.dispose();
    super.dispose();
  }
}
