import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class LongShort extends StatelessWidget {
  const LongShort({super.key, required bool isLongToken})
      : _isLongToken = isLongToken;

  final bool _isLongToken;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 30,
      decoration: boxDecoration(
        Colors.grey[900]!,
        100,
        1,
        Colors.grey[400]!,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 115,
            height: 20,
            decoration: _isLongToken
                ? boxDecoration(
                    Colors.grey[600]!,
                    100,
                    0,
                    Colors.transparent,
                  )
                : boxDecoration(
                    Colors.transparent,
                    100,
                    0,
                    Colors.transparent,
                  ),
            child: TextButton(
              onPressed: () {
                // if (!_isLongToken) {
                //   _isLongToken = true;
                // }
              },
              child: Text(
                'Long Token',
                style: textStyle(
                  Colors.white,
                  14,
                  isBold: true,
                  isUline: false,
                ),
              ),
            ),
          ),
          Container(
            width: 115,
            height: 20,
            decoration: _isLongToken
                ? boxDecoration(
                    Colors.transparent,
                    100,
                    0,
                    Colors.transparent,
                  )
                : boxDecoration(
                    Colors.grey[600]!,
                    100,
                    0,
                    Colors.transparent,
                  ),
            child: TextButton(
              onPressed: () {
                // if (_isLongToken) {
                //   _isLongToken = false;
                // }
              },
              child: Text(
                'Short Token',
                style: textStyle(
                  Colors.white,
                  14,
                  isBold: true,
                  isUline: false,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
