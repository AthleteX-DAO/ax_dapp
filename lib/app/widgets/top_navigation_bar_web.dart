import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TopNavigationBarWeb extends StatelessWidget {
  const TopNavigationBarWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var tabTextSize = _width * 0.0185;
    if (tabTextSize < 19) tabTextSize = 19;
    var tabBoxSize = _width * 0.45;
    if (tabBoxSize < 350) tabBoxSize = 350;
    return SizedBox(
      width: _width * .95,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Tabs
          SizedBox(
            width: tabBoxSize,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 72,
                  height: 50,
                  child: IconButton(
                    icon: Image.asset('assets/images/x.png'),
                    iconSize: 40,
                    onPressed: () {
                      final urlString = Uri.parse('https://www.athletex.io/');
                      launchUrl(urlString);
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('scout');
                  },
                  child: Text(
                    'Scout',
                    style: textStyle(
                      Colors.white,
                      tabTextSize,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('trade');
                  },
                  child: Text(
                    'Trade',
                    style: textStyle(
                      Colors.white,
                      tabTextSize,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('pool');
                  },
                  child: Text(
                    'Pool',
                    style: textStyle(
                      Colors.white,
                      tabTextSize,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('farm');
                  },
                  child: Text(
                    'Farm',
                    style: textStyle(
                      Colors.white,
                      tabTextSize,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ),
                // TODO(Ryan): enable the UI once the feature is ready
                // TextButton(
                //   onPressed: () {
                //     if (page != 'league') {
                //       context.goNamed('league');
                //     }
                //   },
                //   child: Text(
                //     'League',
                //     style: textSwapState(
                //       condition: page == 'league',
                //       tabNotSelected: textStyle(
                //         Colors.white,
                //         tabTextSize,
                //         isBold: true,
                //         isUline: false,
                //       ),
                //       tabSelected: textStyle(
                //         Colors.amber[400]!,
                //         tabTextSize,
                //         isBold: true,
                //         isUline: true,
                //       ),
                //     ),
                //   ),
                // ),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse('https://snapshot.org/#/athletex.eth'));
                  },
                  child: Text(
                    'Vote',
                    style: textStyle(
                      Colors.white,
                      tabTextSize,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const WalletView(),
        ],
      ),
    );
  }
}
