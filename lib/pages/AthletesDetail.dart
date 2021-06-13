import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AthleteDetail extends StatefulWidget {
  AthleteDetail({Key? key}) : super(key: key);

  @override
  _AthleteDetailState createState() => _AthleteDetailState();
}

class _AthleteDetailState extends State<AthleteDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZStack([
        VxBox().hexColor('#fec901').size(context.screenWidth, context.percentHeight * 10).make(),
        VStack([
              "View Athlete Details".text.xl4.black.bold.center.makeCentered().py16(),
              
            HStack(
            [
              ElevatedButton.icon(
                onPressed: () async {
                  // Staking token
                },
                icon: Icon(
                  Icons.call_made_rounded,
                  color: Colors.white,
                ),
                label: "LONG".text.white.make(),
                style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
              ).h(60).tooltip("Buy more tokens of this athlete"),

              ElevatedButton.icon(
                onPressed: () {

                }, //Withdraw Smart Contract Logic
                icon: Icon(
                  Icons.call_received_rounded,
                  color: Colors.white,
                ),
                label: "SHORT".text.white.make(),
                style: ElevatedButton.styleFrom(primary: Colors.redAccent),
              ).h(60).tooltip("Short your athlete positions"),
            ],
            alignment: MainAxisAlignment.spaceEvenly,
            axisSize: MainAxisSize.max,
          ).p16()
        ]),
      ]),
    );
  }
}
