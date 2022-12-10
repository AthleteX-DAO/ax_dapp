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
                    width: 315,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '${longReceive.toStringAsFixed(6)} Long APTs + ${shortReceive.toStringAsFixed(6)} Short APTs',
                        style: textStyle(
                          Colors.white,
                          15,
                          isBold: false,
                          isUline: false,
                        ),
                        maxLines: 1,
                      ),
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
