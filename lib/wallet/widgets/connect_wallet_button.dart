import 'package:flutter/material.dart';

class ConnectWalletButton extends StatelessWidget {
  const ConnectWalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    var width = 180.0;
    return Container(
      height: 37.5,
      width: width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.amber[400]!, width: 2),
      ),
      child: TextButton(
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        child: FittedBox(
          child: Text(
            'Connect',
            style: TextStyle(
              color: Colors.amber[400],
              fontFamily: 'OpenSans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
