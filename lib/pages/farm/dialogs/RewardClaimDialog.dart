import 'package:flutter/material.dart';

import 'package:ax_dapp/pages/farm/modules/BoxDecoration.dart';
import 'package:ax_dapp/pages/farm/modules/DialogTextStyle.dart';

// dynamic
Dialog rewardClaimDialog(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  double wid = _width < 505 ? _width : 500;
  double hgt = _height < 340 ? _height : 335;
  double edge = 40;

  return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
          height: hgt,
          width: wid,
          decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
          child: Center(
              child: Container(
            height: 275,
            width: wid - edge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: wid - edge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(width: 5),
                        Container(
                          child: Text("Rewards Claimed",
                              style: textStyle(Colors.white, 20, false)),
                        ),
                        Container(
                          width: 40,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 150,
                        color: Colors.amber[400],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 275,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "View on Polygonscan",
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
          ))));
}
