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
    var tabTxSz = _width * 0.0185;
    if (tabTxSz < 19) tabTxSz = 19;
    var tabBxSz = _width * 0.3;
    if (tabBxSz < 350) tabBxSz = 350;
    return SizedBox(
      width: _width * .95,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Tabs
          SizedBox(
            width: tabBxSz,
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
                        tabTxSz,
                        isBold: true,
                        isUline: false,
                      ),
                      tabSelected: textStyle(
                        Colors.amber[400]!,
                        tabTxSz,
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
                        tabTxSz,
                        isBold: true,
                        isUline: false,
                      ),
                      tabSelected: textStyle(
                        Colors.amber[400]!,
                        tabTxSz,
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
                        tabTxSz,
                        isBold: true,
                        isUline: false,
                      ),
                      tabSelected: textStyle(
                        Colors.amber[400]!,
                        tabTxSz,
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
                        tabTxSz,
                        isBold: true,
                        isUline: false,
                      ),
                      tabSelected: textStyle(
                        Colors.amber[400]!,
                        tabTxSz,
                        isBold: true,
                        isUline: true,
                      ),
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
