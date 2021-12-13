import 'package:flutter/material.dart';

class DesktopTrade extends StatefulWidget {
  const DesktopTrade({Key? key}) : super(key: key);

  @override
  _DesktopTradeState createState() => _DesktopTradeState();
}

class _DesktopTradeState extends State<DesktopTrade> {
  bool allFarms = true;
  
  @override
  Widget build(BuildContext context) {
    double wid = 550;

    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height*0.15
        ),
        Container(
          height: 350,
          width: wid,
          decoration: boxDecoration(Colors.grey[800]!.withOpacity(0.6), 30, 0.5, Colors.grey[400]!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: wid-50,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Swap",
                  style: textStyle(Colors.white, 16, false, false)
                )
              ),
              // To-dropdown
              Container(
                width: wid-50,
                height: 75,
                alignment: Alignment.center,
                decoration: boxDecoration(Colors.transparent, 20, 0.5, Colors.grey[400]!),
                child: Container(
                  width: wid-100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // to-dropdown
                      Container(
                        width: 125,
                        height: 40,
                        decoration: boxDecoration(Colors.grey[800]!, 100, 0, Colors.grey[800]!),
                        //decoration: boxDecoration(Colors.transparent, 100, 0, Colors.transparent),
                        child: TextButton(
                          onPressed: () => dialog(
                            context,
                            MediaQuery.of(context).size.height*.80,
                            350,
                            boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                // column of elements
                                Container(
                                  height: MediaQuery.of(context).size.height*.75,
                                  width: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      // title row and close
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Select a token",
                                              style: textStyle(Colors.white, 14, true, false),
                                            ),
                                            Container(
                                              child: TextButton(
                                                onPressed: () {Navigator.pop(context);},
                                                child: Icon(
                                                  Icons.close,
                                                  size: 30,
                                                  color: Colors.white,
                                                )
                                              )
                                            )
                                          ],
                                        )
                                      ),
                                      Container(
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Token Name",
                                          style: textStyle(Colors.grey[400]!, 12, false, false)
                                        )
                                      ),
                                      Container(
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.grey[400]
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height*.6,
                                        child: ListView(
                                          children: <Widget>[
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                          ]
                                        )
                                      )
                                    ],
                                  )
                                )
                              ],
                            )
                          ),
                          child: Container(
                            width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "AX",
                                  style: textStyle(Colors.white, 16, true, false)
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 25
                                )
                              ],
                            )
                          )
                        )
                      ),
                      Container(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 24,
                              width: 40,
                              decoration: boxDecoration(Colors.transparent, 100, 0.5, Colors.grey[400]!),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "MAX",
                                  style: textStyle(Colors.grey[400]!, 8, false, false)
                                )
                              )
                            ),
                            Text(
                              "0.00",
                              style: textStyle(Colors.grey[400]!, 22, false, false)
                            )
                          ]
                        )
                      )
                    ],
                  )
                )
              ),
              // from-dropdown
              Container(
                width: wid-50,
                height: 75,
                alignment: Alignment.center,
                decoration: boxDecoration(Colors.transparent, 20, 0.5, Colors.grey[400]!),
                child: Container(
                  width: wid-100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // dropdown
                      Container(
                        width: 175,
                        height: 40,
                        decoration: boxDecoration(Colors.blue, 100, 0, Colors.blue),
                        child: TextButton(
                          onPressed: () => dialog(
                            context,
                            MediaQuery.of(context).size.height*.80,
                            350,
                            boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                // column of elements
                                Container(
                                  height: MediaQuery.of(context).size.height*.75,
                                  width: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      // title row and close
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Select a token",
                                              style: textStyle(Colors.white, 14, true, false),
                                            ),
                                            Container(
                                              child: TextButton(
                                                onPressed: () {Navigator.pop(context);},
                                                child: Icon(
                                                  Icons.close,
                                                  size: 30,
                                                  color: Colors.white,
                                                )
                                              )
                                            )
                                          ],
                                        )
                                      ),
                                      Container(
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Token Name",
                                          style: textStyle(Colors.grey[400]!, 12, false, false)
                                        )
                                      ),
                                      Container(
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.grey[400]
                                        ),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height*.6,
                                        child: ListView(
                                          children: <Widget>[
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                            createTokenDropdown("AX", "AthleteX"),
                                          ]
                                        )
                                      )
                                    ],
                                  )
                                )
                              ],
                            )
                          ),
                          child: Container(
                            //width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Select a token",
                                  style: textStyle(Colors.white, 16, true, false)
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 25
                                )
                              ],
                            )
                          )
                        )
                      ),
                      Container(
                        child: Text(
                          "0.00",
                          style: textStyle(Colors.grey[400]!, 22, false, false)
                        )
                      )
                    ],
                  )
                )
              ),
              // Buttons
              Container(
                width: wid-50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Connect Wallet button
                    Container(
                      height: 50,
                      width: 200,
                      decoration: boxDecoration(Colors.transparent, 100, 4, Colors.amber[400]!),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Connect Wallet",
                          style: textStyle(Colors.amber[400]!, 16, true, false),
                        )
                      )
                    ),
                    // Swap button
                    Container(
                      height: 50,
                      width: 200,
                      decoration: boxDecoration(Colors.amber[400]!, 100, 4, Colors.amber[400]!),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Swap",
                          style: textStyle(Colors.black, 16, true, false),
                        )
                      )
                    ),
                  ],
                )
              )
            ],
          )
        ),
      ]
    );
  }
  
  Widget createTokenDropdown(String ticker, String fullName) {
    return Container(
      height: 50,
      child: TextButton(
        onPressed: () {},
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 30,
                width: 60,
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 30,
                  height: 30,
                  color: Colors.black
                ),
              ),
              Container(
                height: 45,
                // ticker/name column "AX/AthleteX"
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 125,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ticker,
                        style: textStyle(Colors.white, 14, true, false),
                      )
                    ),
                    Container(
                      width: 125,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        fullName,
                        style: textStyle(Colors.grey[100]!, 9, false, false),
                      )
                    ),
                  ],
                )
              )
            ],
          )
        )
      )
    );
  }

  void dialog(BuildContext context, double _height, double _width, BoxDecoration _decoration, Widget _child) {
    Dialog fancyDialog = Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: _height,
        width: _width,
        decoration: _decoration,
        child: _child
      )
    );

    showDialog(context: context, builder: (BuildContext context) => fancyDialog);
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
}