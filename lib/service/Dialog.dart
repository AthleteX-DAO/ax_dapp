import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ae_dapp/service/Athlete.dart';

Dialog buyDialog(BuildContext context) {
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(  
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height*0.6,
      width: MediaQuery.of(context).size.width*(2/7),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column (),
    )
  );
}

Dialog redeemDialog(BuildContext context, Athlete athlete) {
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(  
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height*0.6,
      width: MediaQuery.of(context).size.width*(2/7),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            height: MediaQuery.of(context).size.height*.35,
            width: 350,
            //color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Redeem "+athlete.name+" APT",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white
                          ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: "You can redeem APT's at their Book Value for AX.", style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                              TextSpan(text: " You can access other funds with AX on the Matic network through", style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                              TextSpan(text: " SushiSwap", style: TextStyle(color: Colors.amber[400], fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40.0),
                      child: Text(
                        "Input AX:",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 400,
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
                      Expanded(
                        child: Text(
                          athlete.name+" APT",
                          style: textStyle(Colors.white, 15, false, false),
                        ),
                      ),
                      Container(
                        height: 18,
                        width: 35,
                        decoration: boxDecoration(Colors.transparent, 100, 0.5, Colors.grey[400]!),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Max",
                            style: textStyle(Colors.grey[400]!, 9, false, false),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          style: textStyle(Colors.grey[400]!, 22, false, false),                                                                      
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: textStyle(Colors.grey[400]!, 22, false, false),
                            contentPadding: const EdgeInsets.all(9),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            height: MediaQuery.of(context).size.height*.15,
            width: 350,
            //color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "You recieve:",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "120 AX",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      width: 175,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    )
  );
}

Dialog mintDialog(BuildContext context, Athlete athlete) {
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(  
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height*0.6,
      width: MediaQuery.of(context).size.width*(2/7),
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            height: MediaQuery.of(context).size.height*.35,
            width: 350,
            //color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Mint "+athlete.name+" APT",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white
                          ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: "You can redeem APT's at their Book Value for AX.", style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                              TextSpan(text: " You can buy AX on the Matic network through", style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                              TextSpan(text: " SushiSwap", style: TextStyle(color: Colors.amber[400], fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40.0),
                      child: Text(
                        "Input AX:",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 400,
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
                      Expanded(
                        child: Text(
                          "AX",
                          style: textStyle(Colors.white, 15, false, false),
                        ),
                      ),
                      Container(
                        height: 18,
                        width: 35,
                        decoration: boxDecoration(Colors.transparent, 100, 0.5, Colors.grey[400]!),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Max",
                            style: textStyle(Colors.grey[400]!, 9, false, false),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          style: textStyle(Colors.grey[400]!, 22, false,false),                                                                      
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: textStyle(Colors.grey[400]!, 22, false,false),
                            contentPadding: const EdgeInsets.all(10),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 0.0),
            height: MediaQuery.of(context).size.height*.15,
            width: 350,
            //color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 0.0),
                      child: Text(
                        "You recieve:",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 0.0),
                      child: Text(
                        "100 "+athlete.name+" APT",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      width: 175,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    )
  );
}

TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
    if (isBold)
      if (isUline)
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline
        );
      else
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          fontWeight: FontWeight.w400,
        );
    else
      if (isUline)
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
          decoration: TextDecoration.underline
        );
      else
        return TextStyle(
          color: color,
          fontFamily: 'OpenSans',
          fontSize: size,
        );
  }

BoxDecoration boxDecoration(Color col, double rad, double borWid, Color borCol) {
    return BoxDecoration(
      color: col,
      borderRadius: BorderRadius.circular(rad),
      border: Border.all(
        color: borCol,
        width: borWid
      )
    );
  }