import 'package:ax_dapp/pages/V1App.dart';
import 'package:flutter/material.dart';

class StartTradingButton extends StatelessWidget {
  const StartTradingButton({
    Key? key,
    required this.isWeb,
    required this.tradingTextSize,
  }) : super(key: key);

  final bool isWeb;
  final double tradingTextSize;

  @override
  Widget build(BuildContext context) {
    return isWeb
      ? TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: BorderSide(color: Colors.amber[400]!)
            )
          )
        ),
        onPressed: () {
          navigateToV1App(context);
        },
        child: Text(
          "Start Trading",
          style: TextStyle(color: Colors.amber[400]!, fontSize: tradingTextSize, fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
        ),
      )         
      : TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.amber[300]!.withOpacity(0.15)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.transparent)
            )
          )
        ),
        onPressed: () {
          navigateToV1App(context);
        },
        child: Text(
          "Start",
          style: TextStyle(color: Colors.amber[400]!, fontSize: tradingTextSize, fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
        ),
      );      
  }

  void navigateToV1App(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => V1App()));
  }
}