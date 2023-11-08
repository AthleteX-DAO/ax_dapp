import 'dart:html';
import 'dart:ui' as ui;
import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      ..height = '6200'
      ..width = '4800'
      ..src =
          'https://app.kado.money/?apiKey=137cd949-ab0f-429f-93b8-187ef3a93862';
    _iframeElement.style.border = 'none';

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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var wid = 400.0;
    const edge = 40.0;
    const edge2 = 60.0;
    if (_width < 405) wid = _width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
              alignment: Alignment.centerLeft,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => context.read<AccountBloc>().add(
                    const AccountDetailsViewRequested(),
                  ),
            ),
            const Row(
              children: [
                WalletAddress(),
              ],
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
