import 'package:flutter/material.dart';

class LandingPageMessage extends StatelessWidget {
  const LandingPageMessage({super.key});

  @override
  Widget build(BuildContext context) {
    const textSize = 35.0;
    return SizedBox(
      height: 150,
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
                const TextSpan(
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
                const TextSpan(
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
                const TextSpan(
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
