import 'package:flutter/material.dart';

class DesktopLandingPage extends StatelessWidget {
  const DesktopLandingPage({
    super.key,
    required this.textSize,
  });

  final double textSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'TRADE',
                  style: TextStyle(
                    color: Colors.amber[400],
                    fontFamily: 'BebasNeuePro',
                    fontSize: textSize,
                  ),
                ),
                TextSpan(
                  text: ' ATHLETES',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'BebasNeuePro',
                    fontSize: textSize,
                  ),
                )
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'BUILD',
                  style: TextStyle(
                    color: Colors.amber[400],
                    fontFamily: 'BebasNeuePro',
                    fontSize: textSize,
                  ),
                ),
                TextSpan(
                  text: ' YOUR ROSTER',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'BebasNeuePro',
                    fontSize: textSize,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'EARN',
                  style: TextStyle(
                    color: Colors.amber[400],
                    fontFamily: 'BebasNeuePro',
                    fontSize: textSize,
                  ),
                ),
                TextSpan(
                  text: ' REWARDS',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'BebasNeuePro',
                    fontSize: textSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
