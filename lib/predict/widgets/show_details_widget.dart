import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class ShowDetailsWidget extends StatelessWidget {
  ShowDetailsWidget({
    super.key,
    required this.promptDetails,
  });

  final String promptDetails;

  List<bool> isSelected = [false];
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var wid = _width * 0.4;
    if (_width < 1160) wid = _width * 0.95;

    return SizedBox(
      width: wid,
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  promptDetails,
                  overflow: TextOverflow.fade,
                  style: textStyle(
                    Colors.white,
                    20,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
