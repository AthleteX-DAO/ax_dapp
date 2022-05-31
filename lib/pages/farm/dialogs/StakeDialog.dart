import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:ax_dapp/pages/farm/modules/BoxDecoration.dart';
import 'package:ax_dapp/pages/farm/modules/DialogTextStyle.dart';

import 'package:ax_dapp/service/ApproveButton.dart';
import 'package:ax_dapp/service/Controller/Farms/FarmController.dart';
import 'package:ax_dapp/pages/farm/dialogs/TrxConfirmedDialog.dart';

Dialog stakeDialog(
    BuildContext context, FarmController farm, double layoutWdt, bool isWeb) {
  double _height = MediaQuery.of(context).size.height;
  double wid = isWeb ? 390 : layoutWdt;
  double hgt = _height < 455 ? _height : 450;
  double dialogHorPadding = 30;

  FarmController selectedFarm = FarmController.fromFarm(farm);
  TextEditingController stakeAxInput = TextEditingController();
  RxDouble totalStakedBalance = 0.0.obs;

  return Dialog(
    //remove inset padding to increase width of child widget
    insetPadding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: hgt,
      width: wid,
      padding: EdgeInsets.symmetric(vertical: 22, horizontal: dialogHorPadding),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Stake Liquidity",
                style: textStyle(Colors.white, 20, false),
              ),
              Container(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      )))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Amount Box
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                // padding: const EdgeInsets.all(10),
                // Amount box was overflowing by 30px after using dialogHorPadding
                width: wid - dialogHorPadding - 30,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14.0),
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/x.jpg"),
                        ),
                      ),
                    ),
                    //Empty space between icon image and ticker
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        "${selectedFarm.strStakedAlias.value.length > 0 ? selectedFarm.strStakedAlias : selectedFarm.strStakedSymbol}",
                        style: textStyle(Colors.white, 15, false),
                      ),
                    ),
                    //Max button
                    Container(
                      height: 28,
                      width: 48,
                      decoration: boxDecoration(
                          Colors.transparent, 100, 0.5, Colors.grey[400]!),
                      child: TextButton(
                        onPressed: () {
                            stakeAxInput.text = selectedFarm.strCurrentBalance.value;
                            selectedFarm.dStakeBalance.value =
                                double.parse(selectedFarm.strCurrentBalance.value);
                            totalStakedBalance.value =
                                selectedFarm.dStaked.value +
                                    selectedFarm.dStakeBalance.value;
                         },
                        child: Text(
                          "Max",
                          style: textStyle(Colors.grey[400]!, 9, false),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: stakeAxInput,
                        onChanged: (value) {
                          selectedFarm.dStakeBalance.value =
                              double.parse(value);
                          totalStakedBalance.value =
                              selectedFarm.dStaked.value +
                                  selectedFarm.dStakeBalance.value;
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
                              (RegExp(r'^(\d+)?\.?\d{0,6}'))),
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
                "Current ${selectedFarm.strStakedSymbol} Balance",
                style: textStyle(Colors.grey[400]!, 14, false),
              ),
              Obx(() => Text(
                    "${selectedFarm.strCurrentBalance} ${selectedFarm.strStakedSymbol}",
                    style: textStyle(Colors.grey[400]!, 14, false),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current ${selectedFarm.strStakedSymbol} Staked",
                style: textStyle(Colors.grey[400]!, 14, false),
              ),
              Obx(() => Text(
                    "${selectedFarm.dStaked.toString()} ${selectedFarm.strStakedSymbol}",
                    style: textStyle(Colors.grey[400]!, 14, false),
                  )),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 55),
                child: Text(
                  "+",
                  style: textStyle(Colors.grey[400]!, 14, false),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Funds Added",
                style: textStyle(Colors.grey[400]!, 14, false),
              ),
              Obx(() => Text(
                    "${selectedFarm.dStakeBalance.value.toString()} ${selectedFarm.strStakedSymbol}",
                    style: textStyle(Colors.grey[400]!, 14, false),
                  )),
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
              Text("New Staked Balance"),
              Obx(() => Text(
                  "${totalStakedBalance.value.toString()} ${selectedFarm.strStakedSymbol}")),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ApproveButton(175, 45, 'Approve', selectedFarm.approve,
                  selectedFarm.stake, transactionConfirmed)
            ],
          )
        ],
      ),
    ),
  );
}
