import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/cupertino.dart';

class TickerSymbol extends StatelessWidget {
  const TickerSymbol({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Symbol: $symbol',
        style: textStyle(greyTextColor, 10, isBold: false, isUline: false),
        textAlign: TextAlign.center,
      ),
    );
  }
}
