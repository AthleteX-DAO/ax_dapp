import 'dart:html';
import 'dart:ui' as ui;
import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyAndSell extends StatefulWidget {
  BuyAndSell({
    super.key,
    required BoxConstraints boxConstraints,
    required this.width,
    required this.height,
  }) : constraints = boxConstraints;

  BoxConstraints constraints;
  double height;
  double width;

  @override
  State<BuyAndSell> createState() => _BuyAndSellState();
}

class _BuyAndSellState extends State<BuyAndSell> {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
      ],
    );
    ;
  }
}
