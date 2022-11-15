import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.pageName,
    required this.page,
  });

  final String pageName;
  final String page;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 30,
      decoration: boxDecoration(Colors.transparent, 100, 2, Colors.amber),
      child: TextButton(
        onPressed: () {
          context.goNamed(page);
        },
        child: Text(
          pageName,
          style: textStyle(
            Colors.amber,
            12,
            isBold: false,
            isUline: false,
          ),
        ),
      ),
    );
  }
}

class LinkButtons extends StatelessWidget {
  const LinkButtons({
    super.key,
    required this.isTrade,
    required this.isPool,
    required this.isFarm,
  });

  final bool isTrade;
  final bool isPool;
  final bool isFarm;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (isTrade)
          const LinkButton(
            pageName: 'Trade',
            page: 'trade',
          ),
        if (isPool)
          const LinkButton(
            pageName: 'Pool',
            page: 'pool',
          ),
        if (isFarm)
          const LinkButton(
            pageName: 'Farm',
            page: 'farm',
          )
      ],
    );
  }
}

class TransactionConfirmed extends StatelessWidget {
  const TransactionConfirmed({
    super.key,
    required this.context,
    this.isTrade = false,
    this.isPool = false,
    this.isFarm = false,
  });

  final BuildContext context;
  final bool isTrade, isPool, isFarm;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var wid = 500.0;
    const edge = 40.0;
    if (_width < 505) wid = _width;
    var hgt = 395.0;
    if (_height < 400) hgt = _height;

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: hgt,
        width: wid,
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        child: Center(
          child: SizedBox(
            height: 335,
            width: wid - edge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: wid - edge,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 5),
                      Text(
                        'Deposit Confirmed',
                        style: textStyle(
                          Colors.white,
                          20,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 150,
                      color: Colors.amber[400],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 275,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Controller.viewTx();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'View on Polygonscan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                LinkButtons(
                  isTrade: isTrade,
                  isPool: isPool,
                  isFarm: isFarm,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
