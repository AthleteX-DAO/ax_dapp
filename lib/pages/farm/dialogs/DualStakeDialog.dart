import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:ax_dapp/pages/farm/modules/BoxDecoration.dart';
import 'package:ax_dapp/pages/farm/modules/DialogTextStyle.dart';

import 'package:ax_dapp/service/Controller/Farms/FarmController.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:ax_dapp/pages/farm/dialogs/TrxConfirmedDialog.dart';

Dialog dualStakeDialog(BuildContext context, FarmController selectedFarm,
    String athlete, double layoutWdt, bool isWeb) {
  double _height = MediaQuery.of(context).size.height;
  double wid = isWeb ? 390 : layoutWdt;
  double hgt = _height < 455 ? _height : 450;
  double dialogHorPadding = 30;

  TextEditingController stakeAxInput = TextEditingController();
  WalletController walletController = Get.find();

  return Dialog(
    insetPadding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
        height: hgt,
        width: wid,
        padding: EdgeInsets.symmetric(horizontal: dialogHorPadding),
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  width: wid,
                  margin: EdgeInsets.only(top: 25, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          child: Text(
                        "Deposit Liquidity",
                        style: textStyle(Colors.white, 20, false),
                      )),
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
                  )),
              Container(
                  width: wid,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "*Add liquidity to supply LP tokens to your wallet\nDeposit LP tokens to AX rewards",
                    style: textStyle(Colors.grey[600]!, 11, false),
                  )),
              //Amount Box
              Container(
                width: wid,
                height: 55,
                decoration: boxDecoration(
                    Colors.transparent, 14, 0.5, Colors.grey[400]!),
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(width: 10),
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
                    Container(width: 15),
                    Expanded(
                      child: Text(
                        "AX",
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
                          walletController.getYourAxBalance().then((value) {
                            stakeAxInput.text =
                                walletController.yourBalance.value;
                            print(stakeAxInput);
                          });
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
                              (RegExp(r'^(\d+)?\.?\d{0,6}'))),
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
                      Colors.transparent, 14, 0.5, Colors.grey[400]!),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(width: 10),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            scale: 0.5,
                            image: AssetImage("assets/images/apt.png"),
                          ),
                        ),
                      ),
                      Container(width: 15),
                      Expanded(
                        child: Text(
                          athlete + " APT",
                          style: textStyle(Colors.white, 15, false),
                        ),
                      ),
                      Container(
                        height: 28,
                        width: 48,
                        decoration: boxDecoration(
                            Colors.transparent, 100, 0.5, Colors.grey[400]!),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Max",
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
                                (RegExp(r'^(\d+)?\.?\d{0,6}'))),
                          ],
                        ),
                      ),
                    ],
                  )),
              Container(
                  width: 175,
                  height: 45,
                  decoration: boxDecoration(
                      Colors.transparent, 100, 1, Colors.amber[400]!),
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                transactionConfirmed(context));
                      },
                      child: Text("Add Liquidity",
                          style: textStyle(Colors.amber[400]!, 20, true)))),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text("LP Tokens: " + "0",
                    style: textStyle(Colors.white, 18, true)),
              ),
              Container(
                width: 175,
                height: 40,
                decoration: boxDecoration(Colors.grey, 100, 1, Colors.grey),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            transactionConfirmed(context));
                  },
                  child:
                      Text("Deposit", style: textStyle(Colors.black, 16, true)),
                ),
              )
            ],
          ),
        )),
  );
}
