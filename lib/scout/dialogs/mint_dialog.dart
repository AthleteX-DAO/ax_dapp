import 'package:ax_dapp/athlete/athlete.dart';
import 'package:ax_dapp/athlete/widgets/athlete_insufficient_button.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

class MintDialog extends StatefulWidget {
  const MintDialog({
    required this.athlete,
    required this.goToTradePage,
    required this.goToPage,
    super.key,
  });

  final AthleteScoutModel athlete;
  final void Function() goToTradePage;
  final void Function(int page) goToPage;

  @override
  State<MintDialog> createState() => _MintDialogState();
}

class _MintDialogState extends State<MintDialog> {
  double paddingHorizontal = 20;
  double hgt = 450;
  double input = 0;
  double youSpend = 0;
  RxDouble maxAmount = 0.0.obs;
  RxString balance = '0.0'.obs;
  String aptAddress = '';
  int collateralPerPair = 15000;
  final TextEditingController _aptAmountController = TextEditingController();

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
      final currentAxt = context.read<TokensRepository>().currentAxt;
      final axBalance = await context
          .read<WalletRepository>()
          .getTokenBalance(currentAxt.address);
      balance.value = axBalance?.toString() ?? '0.0';

      maxAmount.value = double.parse(balance.value) /
          collateralPerPair; // 15000 is collateral per pair for the APTs
    } catch (_) {}
    setState(() {});
  }

  Widget showBalance() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () => Text(
              'AX Balance: ${toDecimal(double.tryParse(balance.value)!, 6)}',
              style: textStyle(Colors.grey[600]!, 15, isBold: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget showYouReceive() {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'You Receive: ',
                style: textStyle(Colors.white, 15, isBold: false),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Row(
                  children: [
                    SizedBox(
                      width: hgt * 0.2,
                      child: Text(
                        lspController.createAmt.toStringAsFixed(6),
                        style: textStyle(Colors.white, 15, isBold: false),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        'Long APTs',
                        style: textStyle(Colors.white, 15, isBold: false),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        ' + ',
                        style: textStyle(Colors.white, 15, isBold: false),
                      ),
                    ),
                    SizedBox(
                      width: hgt * 0.2,
                      child: Text(
                        lspController.createAmt.toStringAsFixed(6),
                        style: textStyle(Colors.white, 15, isBold: false),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        'Short APTs',
                        style: textStyle(Colors.white, 15, isBold: false),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget showYouSpend() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'You Spend:',
            style: textStyle(Colors.white, 15, isBold: false),
          ),
          Text(
            '$youSpend AX',
            style: textStyle(Colors.white, 15, isBold: false),
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
                children: [
                  Text(
                    'Mint ${widget.athlete.name} APT Pair',
                    style: textStyle(Colors.white, 20, isBold: false),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
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
                      text: 'You can mint APTs at their Book Value with AX.',
                      style: textStyle(
                        Colors.grey[600]!,
                        isWeb ? 14 : 12,
                        isBold: false,
                      ),
                    ),
                    TextSpan(
                      text: ' Click here to',
                      style: textStyle(
                        Colors.grey[600]!,
                        isWeb ? 14 : 12,
                        isBold: false,
                      ),
                    ),
                    TextSpan(
                      text: ' Buy AX',
                      style: textStyle(
                        Colors.amber[400]!,
                        isWeb ? 14 : 12,
                        isBold: false,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                          widget.goToTradePage();
                        },
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: wid,
                  child: Text(
                    'Input APT:',
                    style: textStyle(Colors.grey[600]!, 14, isBold: false),
                  ),
                ),
                //Input box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  width: wid,
                  height: 70,
                  decoration: boxDecoration(
                    Colors.transparent,
                    14,
                    0.5,
                    Colors.grey[400]!,
                  ),
                  child: Column(
                    children: [
                      //APT icon - athlete name - max button - input field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 35,
                            height: 35,
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
                          Container(width: 5),
                          Container(
                            width: 35,
                            height: 35,
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
                          Container(width: 15),
                          Expanded(
                            child: Text(
                              '${widget.athlete.name} APT',
                              style: textStyle(Colors.white, 15, isBold: false),
                            ),
                          ),
                          Container(
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
                                lspController.updateCreateAmt(maxAmount.value);
                                input = maxAmount.value;
                                youSpend = maxAmount.value * collateralPerPair;
                                //update controller text to max balance
                                _aptAmountController.text =
                                    maxAmount.toStringAsFixed(6);
                              },
                              child: Text(
                                'MAX',
                                style: textStyle(Colors.grey[400]!, 9,
                                    isBold: false),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: hgt * 0.2,
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: _aptAmountController,
                                style: textStyle(Colors.grey[400]!, 22,
                                    isBold: false),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: textStyle(
                                    Colors.grey[400]!,
                                    22,
                                    isBold: false,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 3),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (value == '') {
                                    value = '0';
                                  }
                                  input = double.parse(value);
                                  lspController.updateCreateAmt(input);
                                  setState(() {
                                    youSpend = input * collateralPerPair;
                                  });
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,6}'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          showBalance(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
            //You spend, you receive widgets
            SizedBox(
              //margin: EdgeInsets.only(top: 15.0),
              height: 100,
              width: wid,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showYouSpend(),
                  Container(height: 10),
                  showYouReceive(),
                ],
              ),
            ),
            //Approve/Confirm
            Obx(
              () => SizedBox(
                width: wid,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (double.parse(balance.value) >= youSpend)
                      AthleteMintApproveButton(
                        width: 175,
                        height: 40,
                        text: 'Approve',
                        athlete: widget.athlete,
                        aptName: widget.athlete.name,
                        inputApt: _aptAmountController.text,
                        valueInAX: '$youSpend AX',
                        approveCallback: () {
                          final currentAxt =
                              context.read<TokensRepository>().currentAxt;
                          return lspController.approve(currentAxt.address);
                        },
                        confirmCallback: lspController.mint,
                        goToPage: widget.goToPage,
                      )
                    else
                      const AthleteInsufficientButton(
                        width: 250,
                        height: 40,
                      )
                  ],
                ),
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
    lspController.createAmt(0);
    _aptAmountController.dispose();
    super.dispose();
  }
}
