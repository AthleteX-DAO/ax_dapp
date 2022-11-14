import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class YouReceive extends StatelessWidget {
  const YouReceive({
    super.key,
    required this.shortReceive,
    required this.longReceive,
  });

  final double shortReceive;
  final double longReceive;

  @override
  Widget build(BuildContext context) {
    const hgt = 450;
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'You Receive: ',
                style: textStyle(
                  Colors.white,
                  15,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: hgt * 0.2,
                    child: Text(
                      longReceive.toStringAsFixed(6),
                      style: textStyle(
                        Colors.white,
                        15,
                        isBold: false,
                        isUline: false,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      'Long APTs',
                      style: textStyle(
                        Colors.white,
                        15,
                        isBold: false,
                        isUline: false,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      ' + ',
                      style: textStyle(
                        Colors.white,
                        15,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: hgt * 0.2,
                    child: Text(
                      shortReceive.toStringAsFixed(6),
                      style: textStyle(
                        Colors.white,
                        15,
                        isBold: false,
                        isUline: false,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      'Short APTs',
                      style: textStyle(
                        Colors.white,
                        15,
                        isBold: false,
                        isUline: false,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
