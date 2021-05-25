import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AthleteDetail extends StatefulWidget {
  AthleteDetail({Key key}) : super(key: key);

  @override
  _AthleteDetailState createState() => _AthleteDetailState();
}

class _AthleteDetailState extends State<AthleteDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZStack([
        VxBox().hexColor('#fec901').size(context.screenWidth, context.percentHeight * 60).make(),
        VStack([
            HStack(
            [

              TextButton.icon(
                onPressed: () async {
                  // Staking token

                },
                icon: Icon(
                  Icons.call_made_rounded,
                  color: Colors.white,
                ),
                label: "Stake".text.white.make(),
              ).h(60).tooltip("Lock your tokens in to earn interest rewards"),

              // ignore: deprecated_member_use
              RaisedButton.icon(
                onPressed: () {

                }, //Withdraw Smart Contract Logic
                color: Colors.red,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.call_received_rounded,
                  color: Colors.white,
                ),
                label: "Withdraw".text.white.make(),
              ).h(60).tooltip("Sell your tokens to realize your gains"),
            ],
            alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max,
          ).p16()
        ]),
      ]),
    );
  }
}
