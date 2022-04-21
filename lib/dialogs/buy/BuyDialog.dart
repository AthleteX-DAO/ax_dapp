import 'package:ax_dapp/dialogs/buy/bloc/BuyDialogBloc.dart';
import 'package:ax_dapp/dialogs/buy/models/BuyDialogState.dart';
import 'package:ax_dapp/service/Dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyDialog extends StatefulWidget {
  final String athleteName;
  final double aptPrice;

  BuyDialog(this.athleteName, this.aptPrice);

  @override
  State<StatefulWidget> createState() => _BuyDialogState();
}

class _BuyDialogState extends State<BuyDialog> {
  @override
  Widget build(BuildContext context) {
    bool isWeb = true;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    double _height = MediaQuery.of(context).size.height;
    double wid = isWeb ? 400 : 355;
    double edge = 40;
    double hgt = 500;
    if (_height < 505) hgt = _height;

    return BlocBuilder<BuyDialogBloc, BuyDialogState>(
        buildWhen: (previous, current) => current.status.name.isNotEmpty,
        builder: (context, state) {
          return Dialog(
            insetPadding: isWeb
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(horizontal: 15.0),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              height: hgt,
              width: wid,
              decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
              child: Container(
                  child: SingleChildScrollView(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      height: 80,
                      width: wid - edge,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Buy " + widget.athleteName + " APT",
                              style: textStyle(Colors.white, 20, false)),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      )),
                  Container(
                    height: isWeb ? 45 : 55,
                    width: wid - edge,
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  "You can purchase APTs at Market Price with AX.",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: isWeb ? 14 : 12)),
                          TextSpan(
                              text:
                                  " You can buy AX on the Matic network through",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: isWeb ? 14 : 12)),
                          TextSpan(
                              text: " SushiSwap",
                              style: TextStyle(
                                  color: Colors.amber[400],
                                  fontSize: isWeb ? 14 : 12)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: wid - edge,
                    child: GestureDetector(
                      onTap: () {
                        String urlString =
                            "https://athletex-markets.gitbook.io/athletex-huddle/how-to.../buy-ax-coin";
                        launch(urlString);
                      },
                      child: Text(
                        'Learn How to buy AX',
                        style:
                            TextStyle(color: Colors.amber[400], fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: wid - edge,
                            child: Text(
                              "Input APT amount you want to buy:",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                              width: wid - edge,
                              height: 55,
                              decoration: boxDecoration(Colors.transparent, 14,
                                  0.5, Colors.grey[400]!),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(width: 15),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        scale: 0.5,
                                        image: AssetImage(
                                            "assets/images/apt_noninverted.png"),
                                      ),
                                    ),
                                  ),
                                  Container(width: 15),
                                  Expanded(
                                    child: Text(
                                      widget.athleteName + " APT",
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
                                        Colors.grey[400]!),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "MAX",
                                        style: textStyle(
                                            Colors.grey[400]!, 9, false),
                                      ),
                                    ),
                                  ),
                                  Container(width: 25),
                                  SizedBox(
                                    width: 70,
                                    child: TextFormField(
                                      style: textStyle(
                                          Colors.grey[400]!, 22, false),
                                      decoration: InputDecoration(
                                        hintText: '0.00',
                                        hintStyle: textStyle(
                                            Colors.grey[400]!, 22, false),
                                        border: InputBorder.none,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            (RegExp(r'^(\d+)?\.?\d{0,2}'))),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      )),
                  Divider(
                    thickness: 0.35,
                    color: Colors.grey[400],
                  ),
                  Container(
                      width: wid - edge,
                      height: 125,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Price",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${widget.aptPrice} AX per " +
                                    widget.athleteName +
                                    " APT",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "LP Fee",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "0.5 AX",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Market Price Impact",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "-0.04%",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Minimum Received",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "L.J.APT",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Estimated Slippage",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "~5%",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Container(
                    width: wid - edge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "You receive:",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "100 " + widget.athleteName + " APT",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 75,
                    width: wid - edge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 175,
                          height: 45,
                          decoration: boxDecoration(
                              Colors.amber[500]!.withOpacity(0.20),
                              500,
                              1,
                              Colors.transparent),
                          child: TextButton(
                            //onPressed: () => showDialog(context: context, builder: (BuildContext context) => confirmTransaction(context)),
                            onPressed: () async {
                              Navigator.pop(context);
                              bool confirmed;
                              String txString =
                                  "0x192AB27a6d1d3885e1022D2b18Dd7597272ebD22";
                              try {
                                confirmed = true;
                              } catch (e) {
                                confirmed = false;
                              }
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      confirmTransaction(
                                          context, confirmed, txString));
                            },
                            child: Text(
                              "Confirm",
                              style: textStyle(Colors.amber[500]!, 16, false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ))),
            ),
          );
        });
  }
}
