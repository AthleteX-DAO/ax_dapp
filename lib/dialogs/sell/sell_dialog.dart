import 'package:ax_dapp/athlete/athlete.dart' hide AptTypeSelectionChanged;
import 'package:ax_dapp/dialogs/sell/bloc/sell_dialog_bloc.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:tokens_repository/tokens_repository.dart';

class SellDialog extends StatefulWidget {
  const SellDialog({
    required this.athlete,
    required this.athleteName,
    required this.aptPrice,
    required this.athleteId,
    required this.isLongApt,
    super.key,
  });
  final AthleteScoutModel athlete;
  final String athleteName;
  final double aptPrice;
  final bool isLongApt;
  final int athleteId;

  @override
  State<StatefulWidget> createState() => _SellDialogState();
}

class _SellDialogState extends State<SellDialog> {
  double paddingHorizontal = 20;
  double hgt = 500;
  final TextEditingController _aptAmountController = TextEditingController();

  // in percents, slippage tolerance determines the upper bound of the receive
  // amount, below which transaction gets reverted
  double slippageTolerance = 1;
  Controller controller = Get.find();

  @override
  void dispose() {
    _aptAmountController.dispose();
    super.dispose();
  }

  Widget toggleLongShortToken(double wid, double hgt) {
    return Container(
      padding: const EdgeInsets.all(1.5),
      width: wid * 0.25,
      height: hgt * 0.05,
      decoration: boxDecoration(Colors.transparent, 20, 1, Colors.grey[800]!),
      child: Row(
        children: const [
          Expanded(child: LongAptButton()),
          Expanded(child: ShortAptButton()),
        ],
      ),
    );
  }

  Widget showTotalFee(String totalFee) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Fees:', style: textStyle(Colors.grey[600]!, 15, false)),
          Text(
            '$totalFee APT(0.3%)',
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showBalance(double balance) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Balance: $balance',
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showMarketPriceImpact(String marketPriceImpact) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Market Price Impact:',
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
          Text(
            '$marketPriceImpact %',
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showMinimumReceived(String minimumReceived) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Minimum Received:',
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
          Text(
            '$minimumReceived AX',
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showSlippage(double slipageTolerance) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Slippage Tolerance:',
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
          Text(
            '$slipageTolerance %',
            style: textStyle(Colors.grey[600]!, 15, false),
          ),
        ],
      ),
    );
  }

  Widget showYouReceived(String amountToReceive) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'You Receive:',
            style: textStyle(Colors.white, 15, false),
          ),
          Text(
            '$amountToReceive AX',
            style: textStyle(Colors.white, 15, false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isWeb = true;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _height = MediaQuery.of(context).size.height;
    final wid = isWeb ? 400.0 : 355.0;
    var hgt = 500.0;
    if (_height < 505) hgt = _height;

    return BlocConsumer<SellDialogBloc, SellDialogState>(
      listenWhen: (_, current) =>
          current.status == BlocStatus.error ||
          current.status == BlocStatus.noData,
      listener: (context, state) {
        if (state.status == BlocStatus.noData) {
          context.showWarningToast(
            title: 'No Data for APT',
            description: state.errorMessage,
          );
        } else {
          context.showWarningToast(
            title: 'Action Error',
            description: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<SellDialogBloc>();
        final balance = state.balance;
        final minReceived =
            state.aptSellInfo.minimumReceived.toStringAsFixed(6);
        final priceImpact = state.aptSellInfo.priceImpact.toStringAsFixed(6);
        final receiveAmount =
            state.aptSellInfo.receiveAmount.toStringAsFixed(6);
        final totalFee = state.aptSellInfo.totalFee;

        return Dialog(
          backgroundColor: Colors.transparent,
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
                        'Sell ${widget.athleteName} APT',
                        style: textStyle(Colors.white, 20, false),
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
                          text: "You can sell APT's at Market Price for AX.",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isWeb ? 14 : 12,
                          ),
                        ),
                        TextSpan(
                          text:
                              ''' You can access other funds with AX on the Matic network through''',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isWeb ? 14 : 12,
                          ),
                        ),
                        TextSpan(
                          text: ' SushiSwap',
                          style: TextStyle(
                            color: Colors.amber[400],
                            fontSize: isWeb ? 14 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Input apt text with toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isWeb
                          ? 'Input APT:'
                          : 'Input APT amount you want to sell:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    toggleLongShortToken(wid, hgt),
                  ],
                ),
                //APT input box
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
                          Container(width: 5),
                          const AptIcon(),
                          Container(width: 15),
                          const Expanded(child: Ticker()),
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
                                bloc.add(MaxSellTap());
                                _aptAmountController.text =
                                    state.balance.toStringAsFixed(6);
                              },
                              child: Text(
                                'MAX',
                                style: textStyle(Colors.grey[400]!, 9, false),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: wid * 0.4),
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: _aptAmountController,
                                style: textStyle(Colors.grey[400]!, 22, false),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle:
                                      textStyle(Colors.grey[400]!, 22, false),
                                  contentPadding:
                                      const EdgeInsets.only(left: 3),
                                  border: InputBorder.none,
                                ),
                                onChanged: (newAptInput) {
                                  if (newAptInput.isEmpty) newAptInput = '0';
                                  bloc.add(
                                    NewAptInput(
                                      aptInputAmount: double.parse(newAptInput),
                                    ),
                                  );
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
                          showBalance(balance),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.35,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: wid,
                  height: 125,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Flexible(child: Price())],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          showTotalFee(totalFee.toStringAsFixed(6)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [showMarketPriceImpact(priceImpact)],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          showMinimumReceived(minReceived),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          showSlippage(slippageTolerance),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: wid,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showYouReceived(receiveAmount),
                    ],
                  ),
                ),
                SizedBox(
                  width: wid,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocSelector<WalletBloc, WalletState, String>(
                        selector: (state) => state.formattedWalletAddress,
                        builder: (_, formattedWalletAddress) {
                          return AthleteSellApproveButton(
                            width: 175,
                            height: 40,
                            text: 'Approve',
                            amountInputted: _aptAmountController.text,
                            aptSellInfo: state.aptSellInfo,
                            athlete: widget.athlete,
                            aptName: widget.athleteName,
                            aptId: widget.athleteId,
                            longOrShort: state.aptTypeSelection.isLong
                                ? 'Long Apt'
                                : 'Short Apt',
                            approveCallback: bloc.swapController.approve,
                            confirmCallback: bloc.swapController.swap,
                            confirmDialog: transactionConfirmed,
                            walletAddress: formattedWalletAddress,
                          );
                        },
                      ),
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
}

class LongAptButton extends StatelessWidget {
  const LongAptButton({super.key});

  @override
  Widget build(BuildContext context) {
    final aptTypeSelection =
        context.select((SellDialogBloc bloc) => bloc.state.aptTypeSelection);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.zero,
        minimumSize: const Size(50, 30),
        primary: aptTypeSelection.isLong ? Colors.amber : Colors.transparent,
      ),
      onPressed: () => context
          .read<SellDialogBloc>()
          .add(const AptTypeSelectionChanged(AptType.long)),
      child: Text(
        'Long',
        style: TextStyle(
          color: aptTypeSelection.isLong
              ? Colors.black
              : const Color.fromRGBO(154, 154, 154, 1),
          fontSize: 11,
        ),
      ),
    );
  }
}

class ShortAptButton extends StatelessWidget {
  const ShortAptButton({super.key});

  @override
  Widget build(BuildContext context) {
    final aptTypeSelection =
        context.select((SellDialogBloc bloc) => bloc.state.aptTypeSelection);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.zero,
        minimumSize: const Size(50, 30),
        primary: aptTypeSelection.isLong ? Colors.transparent : Colors.black,
      ),
      onPressed: () => context
          .read<SellDialogBloc>()
          .add(const AptTypeSelectionChanged(AptType.short)),
      child: Text(
        'Short',
        style: TextStyle(
          color: aptTypeSelection.isLong
              ? const Color.fromRGBO(154, 154, 154, 1)
              : Colors.amber,
          fontSize: 11,
        ),
      ),
    );
  }
}

class AptIcon extends StatelessWidget {
  const AptIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final aptTypeSelection =
        context.select((SellDialogBloc bloc) => bloc.state.aptTypeSelection);
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          scale: 0.5,
          image: aptTypeSelection.isLong
              ? const AssetImage(
                  'assets/images/apt_noninverted.png',
                )
              : const AssetImage(
                  'assets/images/apt_inverted.png',
                ),
        ),
      ),
    );
  }
}

class Price extends StatelessWidget {
  const Price({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Price:', style: textStyle(Colors.white, 15, false)),
        BlocBuilder<SellDialogBloc, SellDialogState>(
          buildWhen: (previous, current) =>
              previous.aptTypeSelection != current.aptTypeSelection ||
              previous.aptSellInfo != current.aptSellInfo ||
              previous.longApt != current.longApt ||
              previous.shortApt != current.shortApt,
          builder: (context, state) {
            final price = state.aptSellInfo.axPrice.toStringAsFixed(6);
            final _textStyle = textStyle(Colors.white, 15, false);
            return state.aptTypeSelection.isLong
                ? Text(
                    '$price AX per ${state.longApt.ticker} APT',
                    style: _textStyle,
                  )
                : Text(
                    '$price AX per ${state.shortApt.ticker} APT',
                    style: _textStyle,
                  );
          },
        )
      ],
    );
  }
}

class Ticker extends StatelessWidget {
  const Ticker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellDialogBloc, SellDialogState>(
      buildWhen: (previous, current) =>
          previous.aptTypeSelection != current.aptTypeSelection ||
          previous.longApt != current.longApt ||
          previous.shortApt != current.shortApt,
      builder: (context, state) {
        final _textStyle = textStyle(Colors.white, 15, false);
        return Text(
          state.aptTypeSelection.isLong
              ? '''${state.longApt.ticker} APT'''
              : '''${state.shortApt.ticker} APT''',
          style: _textStyle,
        );
      },
    );
  }
}
