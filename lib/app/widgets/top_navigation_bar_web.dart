import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class TopNavigationBarWeb extends StatelessWidget {
  const TopNavigationBarWeb({super.key, required this.page});

  final String page;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var tabTextSize = _width * 0.0185;
    if (tabTextSize < 19) tabTextSize = 19;
    var tabBoxSize = _width * 0.35;
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
                    if (page != 'predict') {
                      context.goNamed('predict');
                    }
                  },
                  child: Text(
                    'Predict',
                    style: textSwapState(
                      condition: page == 'predict',
                      tabNotSelected: textStyle(
                        Colors.white,
                        tabTextSize,
                        isBold: true,
                        isUline: false,
                      ),
                      tabSelected: textStyle(
                        Colors.amber[400]!,
                        tabTextSize,
                        isBold: true,
                        isUline: true,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (page != 'scout') {
                      context.goNamed('scout');
                    }
                  },
                  child: Text(
                    'Scout',
                    style: textSwapState(
                      condition: page == 'scout',
                      tabNotSelected: textStyle(
                        Colors.white,
                        tabTextSize,
                        isBold: true,
                        isUline: false,
                      ),
                      tabSelected: textStyle(
                        Colors.amber[400]!,
                        tabTextSize,
                        isBold: true,
                        isUline: true,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (page != 'trade') {
                      context.goNamed('trade');
                    }
                  },
                  child: Text(
                    'Trade',
                    style: textSwapState(
                      condition: page == 'trade',
                      tabNotSelected: textStyle(
                        Colors.white,
                        tabTextSize,
                        isBold: true,
                        isUline: false,
                      ),
                      tabSelected: textStyle(
                        Colors.amber[400]!,
                        tabTextSize,
                        isBold: true,
                        isUline: true,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (page != 'pool') {
                      context.goNamed('pool');
                    }
                  },
                  child: Text(
                    'Pool',
                    style: textSwapState(
                      condition: page == 'pool',
                      tabNotSelected: textStyle(
                        Colors.white,
                        tabTextSize,
                        isBold: true,
                        isUline: false,
                      ),
                      tabSelected: textStyle(
                        Colors.amber[400]!,
                        tabTextSize,
                        isBold: true,
                        isUline: true,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (page != 'farm') {
                      context.goNamed('farm');
                    }
                  },
                  child: Text(
                    'Farm',
                    style: textSwapState(
                      condition: page == 'farm',
                      tabNotSelected: textStyle(
                        Colors.white,
                        tabTextSize,
                        isBold: true,
                        isUline: false,
                      ),
                      tabSelected: textStyle(
                        Colors.amber[400]!,
                        tabTextSize,
                        isBold: true,
                        isUline: true,
                      ),
                    ),
                  ),
                ),
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
