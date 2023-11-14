import 'dart:ui' as ui;
import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';

class AccountBuyAndSell extends StatefulWidget {
  const AccountBuyAndSell({
    super.key,
  });

  @override
  State<AccountBuyAndSell> createState() => _AccountBuyAndSellState();
}

class _AccountBuyAndSellState extends State<AccountBuyAndSell> {
  late Widget kadoMoney;
  final _iframeElement = IFrameElement();

  @override
  void initState() {
    super.initState();
    _iframeElement
      ..height = '620'
      ..width = '480'
      ..src =
          'https://app.kado.money/?apiKey=137cd949-ab0f-429f-93b8-187ef3a93862';
    _iframeElement.style.borderRadius = '14px';
    _iframeElement.style.borderColor = 'rgba(254, 197, 0, 1)';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );

    kadoMoney = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    const edge = 40.0;
    const wid = 400.0;

    const edge2 = 60.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => context.read<AccountBloc>().add(
                        const AccountDetailsViewRequested(),
                      ),
                ),
              ],
            ),

            SizedBox(
              width: wid - edge2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: _height * 0.18,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Your Wallet Details',
                              style: textStyle(
                                Colors.grey[600]!,
                                13,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WalletBalance(),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WalletAddress(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: constraints.maxWidth - edge,
              child: const Divider(
                color: Colors.grey,
              ),
            ),

            SizedBox(
              width: constraints.maxWidth - edge,
              height: _height * 0.5,
              child: kadoMoney,
            ),
          ],
        );
      },
    );
  }
}
