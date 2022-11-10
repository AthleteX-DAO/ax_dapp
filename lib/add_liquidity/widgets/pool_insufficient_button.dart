import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class PoolInsufficientButton extends StatelessWidget {
  const PoolInsufficientButton({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: boxDecoration(Colors.transparent, 100, 2, Colors.red[400]!),
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Insufficient Balance',
          style: textStyle(Colors.red[400]!, 16, isBold: false, isUline: false),
        ),
      ),
    );
  }
}
