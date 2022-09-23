import 'dart:math';

import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/service/confirmation_dialogs/custom_confirmation_dialogs.dart';
import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/failed_dialog.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/helper.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

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
  RxDouble maxAmount = 0.0.obs;
  RxString longBalance = '---'.obs;
  RxString shortBalance = '---'.obs;
  int collateralPerPair = 15000;
  final TextEditingController _longInputController = TextEditingController();
  final TextEditingController _shortInputController = TextEditingController();

  LSPController lspController = Get.find();

  @override
  void initState() {
    super.initState();
    final aptPair =
        context.read<TokensRepository>().currentAptPair(widget.athlete.id);
    lspController.updateAptAddress(aptPair.address);
    updateStats();
  }

  Future<void> updateStats() async {
    try {
      final tokensRepository = context.read<TokensRepository>();
      final aptPair = tokensRepository.currentAptPair(widget.athlete.id);
      final walletRepository = context.read<WalletRepository>();
      final _longBalance =
          await walletRepository.getTokenBalance(aptPair.longApt.address);
      longBalance.value = _longBalance?.toString() ?? '0.0';

      final _shortBalance =
          await walletRepository.getTokenBalance(aptPair.shortApt.address);
      shortBalance.value = _shortBalance?.toString() ?? '0.0';
      maxAmount.value = min(
        double.parse(longBalance.value),
        double.parse(shortBalance.value),
      );
    } catch (_) {}
    setState(() {});
  }

  Widget showLongBalance() {
    final dBalance = double.tryParse(longBalance.value);
    final balance =
        dBalance != null ? toDecimal(dBalance, 6) : longBalance.value;
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Balance: $balance',
            style: textStyle(Colors.grey[600]!, 15, isBold: false),
          ),
        ],
      ),
    );
  }

  Widget showShortBalance() {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () => Text(
              'Balance: ${shortBalance.value}',
              style: textStyle(Colors.grey[600]!, 15, isBold: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget showYouReceive() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'You Receive: ',
            style: textStyle(Colors.white, 15, isBold: false),
          ),
          Obx(
            () => Row(
              children: [
                Text(
                  '''${(lspController.redeemAmt * collateralPerPair).toStringAsFixed(6)} AX''', // 15000 is the collateral per pair
                  style: textStyle(Colors.white, 15, isBold: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _height = MediaQuery.of(context).size.height;
    final wid = isWeb ? 400.0 : 355.0;
    if (_height < 505) hgt = _height;
    switch (widget.athlete.sport) {
      case SupportedSport.MLB:
        collateralPerPair = 15000;
        break;
      case SupportedSport.NBA:
      case SupportedSport.NFL:
        collateralPerPair = 1000;
        break;
      case SupportedSport.all:
    }

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
                        style: textStyle(Colors.white, 20, isBold: false),
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
                      text: "You can redeem APT's at their Book Value for AX.",
                      style: textStyle(
                        Colors.grey[600]!,
                        isWeb ? 14 : 12,
                        isBold: false,
                      ),
                    ),
                    TextSpan(
                      text:
                          ''' You can access other funds with AX on the Matic network through''',
                      style: textStyle(
                        Colors.grey[600]!,
                        isWeb ? 14 : 12,
                        isBold: false,
                      ),
                    ),
                    TextSpan(
                      text: ' SushiSwap',
                      style: textStyle(
                        Colors.amber[400]!,
                        isWeb ? 14 : 12,
                        isBold: false,
                      ),
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
                      isWeb ? 'Input APT pair:' : 'Input APT pair and amount:',
                      style: textStyle(Colors.grey[600]!, 14, isBold: false),
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
                          updateStats();
                          lspController.updateRedeemAmt(maxAmount.value);
                          _longInputController.text = '${maxAmount.value}';
                          _shortInputController.text = '${maxAmount.value}';
                        },
                        child: Text(
                          'MAX',
                          style: textStyle(Colors.grey[400]!, 9, isBold: false),
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
                            margin: const EdgeInsets.symmetric(horizontal: 15),
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
                              style: textStyle(Colors.white, 15, isBold: false),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: wid * 0.4),
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: _longInputController,
                                style: textStyle(Colors.grey[400]!, 22,
                                    isBold: false),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: textStyle(
                                    Colors.grey[400]!,
                                    22,
                                    isBold: false,
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
                                  final newAmount = double.parse(value);
                                  lspController.updateRedeemAmt(newAmount);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      showLongBalance()
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
                            margin: const EdgeInsets.symmetric(horizontal: 15),
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
                              style: textStyle(Colors.white, 15, isBold: false),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: wid * 0.4),
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: _shortInputController,
                                style: textStyle(Colors.grey[400]!, 22,
                                    isBold: false),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: textStyle(
                                    Colors.grey[400]!,
                                    22,
                                    isBold: false,
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
                                  final newAmount = double.parse(value);
                                  lspController.updateRedeemAmt(newAmount);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      showShortBalance()
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
            showYouReceive(),
            SizedBox(
              width: wid,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        final result = await lspController.redeem();
                        if (result) {
                          await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                const ConfirmTransactionDialog(),
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
                                  inputShortApt: _shortInputController.text,
                                  valueInAx: (lspController.redeemAmt *
                                          collateralPerPair)
                                      .toStringAsFixed(6),
                                  walletId: walletAddress,
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
                        style: textStyle(Colors.amber[500]!, 16, isBold: false),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    lspController.updateRedeemAmt(0);
    _longInputController.dispose();
    _shortInputController.dispose();
    super.dispose();
  }
}
