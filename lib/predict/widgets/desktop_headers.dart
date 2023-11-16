import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class DesktopHeaders extends StatelessWidget {
  const DesktopHeaders({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: OutlinedButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (_) => BorderSide.none,
          ),
          mouseCursor: MaterialStateProperty.resolveWith<MouseCursor>(
            (_) => MouseCursor.defer,
          ),
        ),
        onPressed: () {},
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              child: Text(
                'Prediction',
                style: textStyle(
                  Colors.grey[400]!,
                  12,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            SizedBox(
              child: Text(
                'Probability',
                style: textStyle(
                  Colors.grey[400]!,
                  12,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ),
            const SizedBox(
              width: 80,
            ),
            SizedBox(
              child: Text(
                '24H Volume',
                style: textStyle(
                  Colors.grey[400]!,
                  12,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              child: Text(
                'Price',
                style: textStyle(
                  Colors.grey[400]!,
                  12,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
