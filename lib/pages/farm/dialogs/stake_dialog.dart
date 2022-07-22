// ignore_for_file: avoid_positional_boolean_parameters

import 'package:ax_dapp/pages/farm/dialogs/trx_confirmed_dialog.dart';
import 'package:ax_dapp/pages/farm/modules/box_decoration.dart';
import 'package:ax_dapp/pages/farm/modules/dialog_text_style.dart';
import 'package:ax_dapp/service/approve_button.dart';
import 'package:ax_dapp/service/controller/farms/farm_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Dialog stakeDialog(
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
  final stakeAxInput = TextEditingController();
  final totalStakedBalance = 0.0.obs;

  return Dialog(
    //remove inset padding to increase width of child widget
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
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Stake Liquidity',
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
            children: <Widget>[
              //Amount Box
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                // padding: const EdgeInsets.all(10),
                // Amount box was overflowing by 30px after using
                // dialogHorPadding
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
                //Amount box content
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //Icon image
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
                    //Empty space between icon image and ticker
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        '''${selectedFarm.strStakedAlias.value.isNotEmpty ? selectedFarm.strStakedAlias : selectedFarm.strStakedSymbol}''',
                        style: textStyle(Colors.white, 15, false),
                      ),
                    ),
                    //Max button
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
                          stakeAxInput.text =
                              selectedFarm.stakingInfo.value.viewAmount;
                          selectedFarm.strStakeInput.value = stakeAxInput.text;
                          totalStakedBalance.value = double.parse(
                                selectedFarm.stakedInfo.value.viewAmount,
                              ) +
                              double.parse(selectedFarm.strStakeInput.value);
                        },
                        child: Text(
                          'Max',
                          style: textStyle(Colors.grey[400]!, 9, false),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: stakeAxInput,
                        onChanged: (value) {
                          selectedFarm.strStakeInput.value = value;
                          totalStakedBalance.value = double.parse(
                                selectedFarm.stakedInfo.value.viewAmount,
                              ) +
                              double.parse(selectedFarm.strStakeInput.value);
                          selectedFarm.strStakeInput.value =
                              double.parse(value).toString();
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
                'Current ${selectedFarm.strStakedSymbol} Balance',
                style: textStyle(Colors.grey[400]!, 14, false),
              ),
              Obx(
                () => Text(
                  '''${selectedFarm.stakingInfo.value.viewAmount} ${selectedFarm.strStakedSymbol}''',
                  style: textStyle(Colors.grey[400]!, 14, false),
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
                  '+',
                  style: textStyle(Colors.grey[400]!, 14, false),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Funds Added',
                style: textStyle(Colors.grey[400]!, 14, false),
              ),
              Obx(
                () => Text(
                  '''${selectedFarm.strStakeInput.value} ${selectedFarm.strStakedSymbol}''',
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
                () => Text(
                  '''${totalStakedBalance.value.toString()} ${selectedFarm.strStakedSymbol}''',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ApproveButton(
                175,
                45,
                'Approve',
                selectedFarm.approve,
                selectedFarm.stake,
                transactionConfirmed,
              )
            ],
          )
        ],
      ),
    ),
  );
}
