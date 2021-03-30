import 'package:ae_dapp/AthletesList.dart';
import 'package:ae_dapp/main.dart';
import 'package:flutter/material.dart';
import "package:velocity_x/velocity_x.dart";

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

var myData = 0;
bool data = true;
int myAmount = 0;

class _WalletState extends State<Wallet> {
  void _buyStuff() {
    Navigator.pushNamed(context, "/athletes");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // contractLink.getFunds()  ? data = true : data = false;
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _buyStuff)],
      ),
      backgroundColor: Vx.white,
      body: ZStack([
        VxBox()
            .hexColor("#fec901")
            .size(context.screenWidth, context.percentHeight * 30)
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          "\$Athlete.Equity".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 5).heightBox,
          VxBox(
                  child: VStack([
            "Balance".text.gray700.xl2.semiBold.makeCentered(),
            10.heightBox,
            data
                ? "$myData".text.bold.xl6.makeCentered()
                : CircularProgressIndicator().centered()
          ]))
              .p16
              .white
              .size(context.screenWidth, context.percentHeight * 30)
              .rounded
              .shadowLg
              .make()
              .p16(),
          30.heightBox,
          HStack(
            [
              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () {},
                color: Colors.green,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.call_made_rounded,
                  color: Colors.white,
                ),
                label: "Deposit".text.white.make(),
              ).h(60),

              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () => {},
                color: Colors.blue,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                label: "Refresh".text.white.make(),
              ).h(60),

              // ignore: deprecated_member_use
              FlatButton.icon(
                onPressed: () {},
                color: Colors.red,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.call_received_rounded,
                  color: Colors.white,
                ),
                label: "Withdraw".text.white.make(),
              ).h(60),
            ],
            alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max,
          ).p16()
        ])
      ]),
    );
  }
}
