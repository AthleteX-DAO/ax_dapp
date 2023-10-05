import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class BuyText extends StatelessWidget {
  const BuyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: kIsWeb
          ? Text(
              'Buy',
              style: textStyle(
                const Color.fromRGBO(254, 197, 0, 1),
                12,
                isBold: false,
                isUline: false,
              ),
            )
          : Text(
              'View',
              style: textStyle(
                const Color.fromRGBO(255, 198, 0, 1),
                10,
                isBold: false,
                isUline: false,
              ),
            ),
    );
  }
}
