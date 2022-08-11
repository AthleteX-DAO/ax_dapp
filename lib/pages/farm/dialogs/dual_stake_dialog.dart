// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/farm/dialogs/trx_confirmed_dialog.dart';
import 'package:ax_dapp/pages/farm/modules/box_decoration.dart';
import 'package:ax_dapp/pages/farm/modules/dialog_text_style.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget dualStakeDialog(
  BuildContext context,
  FarmController selectedFarm,
  String athlete,
  double layoutWdt,
  bool isWeb,
) {
  final _height = MediaQuery.of(context).size.height;
  final wid = isWeb ? 390.0 : layoutWdt;
  final hgt = _height < 455.0 ? _height : 450.0;
  const dialogHorPadding = 30.0;

  final stakeAxInput = TextEditingController();

  return BlocListener<WalletBloc, WalletState>(
    listenWhen: (previous, current) =>
        previous.axData.balance != current.axData.balance,
    listener: (context, state) {
      stakeAxInput.text = state.axData.balance?.toString() ?? '';
    },
    child: Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: hgt,
        width: wid,
        padding: const EdgeInsets.symmetric(horizontal: dialogHorPadding),
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: wid,
                margin: const EdgeInsets.only(top: 25, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Deposit Liquidity',
                      style: textStyle(Colors.white, 20, false),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: wid,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '''*Add liquidity to supply LP tokens to your wallet\nDeposit LP tokens to AX rewards''',
                  style: textStyle(Colors.grey[600]!, 11, false),
                ),
              ),
              //Amount Box
              Container(
                width: wid,
                height: 55,
                decoration: boxDecoration(
                  Colors.transparent,
                  14,
                  0.5,
                  Colors.grey[400]!,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 10),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/x.jpg'),
                        ),
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        'AX',
                        style: textStyle(Colors.white, 15, false),
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
                        onPressed: () => context
                            .read<WalletBloc>()
                            .add(const UpdateAxDataRequested()),
                        child: Text(
                          'Max',
                          style: textStyle(Colors.grey[400]!, 9, false),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        controller: stakeAxInput,
                        onChanged: (value) {
                          stakeAxInput.text = value;
                        },
                        style: textStyle(Colors.grey[400]!, 22, false),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: textStyle(Colors.grey[400]!, 22, false),
                          contentPadding: const EdgeInsets.all(9),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,6}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //Amount Box
              Container(
                width: wid,
                height: 55,
                decoration: boxDecoration(
                  Colors.transparent,
                  14,
                  0.5,
                  Colors.grey[400]!,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 10),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          scale: 0.5,
                          image: AssetImage('assets/images/apt.png'),
                        ),
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        '$athlete APT',
                        style: textStyle(Colors.white, 15, false),
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
                        onPressed: () {},
                        child: Text(
                          'Max',
                          style: textStyle(Colors.grey[400]!, 9, false),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        onChanged: (value) {},
                        style: textStyle(Colors.grey[400]!, 22, false),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: textStyle(Colors.grey[400]!, 22, false),
                          contentPadding: const EdgeInsets.all(9),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,6}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 175,
                height: 45,
                decoration: boxDecoration(
                  Colors.transparent,
                  100,
                  1,
                  Colors.amber[400]!,
                ),
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog<void>(
                      context: context,
                      builder: transactionConfirmed,
                    );
                  },
                  child: Text(
                    'Add Liquidity',
                    style: textStyle(Colors.amber[400]!, 20, true),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'LP Tokens: ' '0',
                  style: textStyle(Colors.white, 18, true),
                ),
              ),
              Container(
                width: 175,
                height: 40,
                decoration: boxDecoration(Colors.grey, 100, 1, Colors.grey),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog<void>(
                      context: context,
                      builder: transactionConfirmed,
                    );
                  },
                  child:
                      Text('Deposit', style: textStyle(Colors.black, 16, true)),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
