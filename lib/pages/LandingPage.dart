import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/ax.jpg"), fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [Image.asset("images/img2.png")],
          ),
          Row( children: [
            const Text("Trade Athlete Tokens \n Build your Team \n Earn Rewards")
          ],),
          Row(
            children: [
              ElevatedButton(
                child: const Text("Create AX Wallet"),
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.amber.shade700)),
              ),
              ElevatedButton(
                child: const Text("Start Trading"),
                onPressed: () {},
                )
            ],
          )
        ],
      ),
    );
  }
}
