// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:developer';

import 'package:ax_dapp/pages/farm/dialogs/unstake_confirmed_dialog.dart';
import 'package:ax_dapp/pages/farm/modules/box_decoration.dart';
import 'package:ax_dapp/pages/farm/modules/dialog_text_style.dart';
import 'package:ax_dapp/service/approve_button.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> testFunction() async {
  log('Test function executed!');
  return;
}

Dialog unstakeDialog(
  BuildContext context,
  FarmController farm,
  double layoutWdt,
  bool isWeb,
) {
  final _height = MediaQuery.of(context).size.height;
  final wid = isWeb ? 390.0 : layoutWdt;
  final hgt = _height < 455.0 ? _height : 450.0;
  const dialogHorPadding = 30.0;

  final selectedFarm = FarmController.fromFarm(farm);
  final totalStakedBalance = 0.0.obs;
  final unStakeAxInput = TextEditingController();

  return Dialog(
    insetPadding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      padding: const EdgeInsets.symmetric(
        vertical: 22,
        horizontal: dialogHorPadding,
      ),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Unstake Liquidity',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Amount Box
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                width: wid - dialogHorPadding - 30,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          scale: 2,
                          image: AssetImage('assets/images/x.jpg'),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        '''${selectedFarm.strStakedAlias.value.isNotEmpty ? selectedFarm.strStakedAlias : selectedFarm.strStakedSymbol}''',
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
                        onPressed: () {
                          unStakeAxInput.text =
                              selectedFarm.stakedInfo.value.viewAmount;
                          selectedFarm.strUnStakeInput.value =
                              unStakeAxInput.text;
                          totalStakedBalance.value = double.parse(
                                selectedFarm.stakedInfo.value.viewAmount,
                              ) -
                              double.parse(selectedFarm.strUnStakeInput.value);
                        },
                        child: Text(
                          'Max',
                          style: textStyle(Colors.grey[400]!, 9, false),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        controller: unStakeAxInput,
                        onChanged: (value) {
                          selectedFarm.strUnStakeInput.value = value;
                          totalStakedBalance.value = double.parse(
                                selectedFarm.stakedInfo.value.viewAmount,
                              ) -
                              double.parse(selectedFarm.strUnStakeInput.value);
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current ${selectedFarm.strStakedSymbol} Staked',
                style: textStyle(Colors.grey[400]!, 14, false),
              ),
              Obx(
                () => Text(
                  '''${selectedFarm.stakedInfo.value.viewAmount} ${selectedFarm.strStakedSymbol}''',
                  style: textStyle(Colors.grey[400]!, 14, false),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 55),
                child: Text(
                  '-',
                  style: textStyle(Colors.grey[400]!, 14, false),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Funds Removed',
                style: textStyle(Colors.grey[400]!, 14, false),
              ),
              Obx(
                () => Text(
                  '''${selectedFarm.strUnStakeInput.value} ${selectedFarm.strStakedSymbol}''',
                  style: textStyle(Colors.grey[400]!, 14, false),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('New Staked Balance'),
              Obx(
                () =>
                    Text('$totalStakedBalance ${selectedFarm.strStakedSymbol}'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Container(
                margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                width: 175,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.amber[400],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            removalConfimed(context));
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ), */
              //ApproveButton(175, 45, 'confirm', false, () => {}, () => {}),
              ApproveButton(
                175,
                45,
                'Approve',
                testFunction,
                selectedFarm.unstake,
                unstakeConfirmedDialog,
              ),
            ],
          )
        ],
      ),
    ),
  );
}
