import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var textSize = 16.0;

    var wid = 400.0;
    const edge = 40.0;
    const edge2 = 60.0;
    if (_width < 405) wid = _width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: _height * 0.9,
          width: constraints.maxWidth * 0.9,
          decoration:
              boxDecoration(Colors.transparent, 30, 0, Colors.transparent),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // title
                Container(
                  margin: constraints.maxWidth < 665
                      ? const EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.zero,
                  width: wid - edge,
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Account Balances',
                        style: textStyle(
                          Colors.white,
                          20,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 26,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // inner box
                Container(
                  margin: constraints.maxWidth < 665
                      ? const EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.zero,
                  width: constraints.maxWidth - edge,
                  height: _height * 0.8,
                  decoration: boxDecoration(
                    Colors.transparent,
                    14,
                    .5,
                    primaryOrangeColor,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
