import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:ax_dapp/pages/farm/dialogs/UnstakeConfirmedDialog.dart';
import 'package:ax_dapp/pages/farm/modules/BoxDecoration.dart';
import 'package:ax_dapp/pages/farm/modules/DialogTextStyle.dart';
import 'package:ax_dapp/service/ApproveButton.dart';
import 'package:ax_dapp/service/Controller/Farms/FarmController.dart';

Future<void> testFunction() async {
  print("[Console] hello world");
  return;
}

Dialog unstakeDialog(
    BuildContext context, FarmController farm, double layoutWdt, bool isWeb) {
  double _height = MediaQuery.of(context).size.height;
  double wid = isWeb ? 390 : layoutWdt;
  double hgt = _height < 455 ? _height : 450;
  double dialogHorPadding = 30;

  FarmController selectedFarm = FarmController.fromFarm(farm);
  RxDouble totalStakedBalance = 0.0.obs;
  TextEditingController unStakeAxInput = TextEditingController();

  return Dialog(
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
                "Unstake Liquidity",
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
                margin: const EdgeInsets.symmetric(vertical: 30),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          scale: 2.0,
                          image: AssetImage('assets/images/x.jpg'),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        "${selectedFarm.strStakedAlias.value.length > 0 ? selectedFarm.strStakedAlias : selectedFarm.strStakedSymbol}",
                        style: textStyle(Colors.white, 15, false),
                      ),
                    ),
                    Container(
                      height: 28,
                      width: 48,
                      decoration: boxDecoration(
                          Colors.transparent, 100, 0.5, Colors.grey[400]!),
                      child: TextButton(
                        onPressed: () {
                          unStakeAxInput.text =
                              selectedFarm.stakedInfo.value.viewAmount;
                          selectedFarm.strUnStakeInput.value =
                              unStakeAxInput.text;
                          totalStakedBalance.value = double.parse(
                                  selectedFarm.stakedInfo.value.viewAmount) -
                              double.parse(selectedFarm.strUnStakeInput.value);
                        },
                        child: Text(
                          "Max",
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
                                  selectedFarm.stakedInfo.value.viewAmount) -
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
                "Current ${selectedFarm.strStakedSymbol} Staked",
                style: textStyle(Colors.grey[400]!, 14, false),
              ),
              Obx(() => Text(
                    "${selectedFarm.stakedInfo.value.viewAmount} ${selectedFarm.strStakedSymbol}",
                    style: textStyle(Colors.grey[400]!, 14, false),
                  )),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 55),
                child: Text(
                  "-",
                  style: textStyle(Colors.grey[400]!, 14, false),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Funds Removed",
                style: textStyle(Colors.grey[400]!, 14, false),
              ),
              Obx(() => Text(
                    "${selectedFarm.strUnStakeInput.value} ${selectedFarm.strStakedSymbol}",
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
              Obx(() =>
                  Text("$totalStakedBalance ${selectedFarm.strStakedSymbol}")),
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
              ApproveButton(175, 45, 'Approve', testFunction,
                  selectedFarm.unstake, unstakeConfirmedDialog),
            ],
          )
        ],
      ),
    ),
  );
}
