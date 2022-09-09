// ignore_for_file: non_constant_identifier_names
// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:html';

import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

// dynamic
Dialog confirmTransaction(
  BuildContext context,
  bool IsConfirmed,
  String txString,
) {
  var isWeb = true;
  isWeb =
      kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 500.0;
  const edge = 40.0;
  if (_width < 505) wid = _width;
  var hgt = 335.0;
  if (_height < 340) hgt = _height;

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
          height: 275,
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
                      'Transaction Confirmed',
                      style: textStyle(Colors.white, 20, false),
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
                    decoration: isWeb
                        ? boxDecoration(
                            Colors.amber[400]!,
                            500,
                            1,
                            Colors.amber[400]!,
                          )
                        : boxDecoration(
                            Colors.amber[500]!.withOpacity(0.20),
                            500,
                            1,
                            Colors.transparent,
                          ),
                    child: TextButton(
                      onPressed: () {
                        Controller.viewTx();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'View on Polygonscan',
                        style: isWeb
                            ? textStyle(Colors.black, 16, false)
                            : textStyle(Colors.amber[500]!, 16, false),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// dynamic
Dialog removalConfirmed(BuildContext context) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 500.0;
  const edge = 40.0;
  if (_width < 505) wid = _width;
  var hgt = 335.0;
  if (_height < 340) hgt = _height;

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
          height: 275,
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
                      'Removal Confirmed',
                      style: textStyle(Colors.white, 20, false),
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
            ],
          ),
        ),
      ),
    ),
  );
}

class LinkButton extends StatelessWidget {
  const LinkButton({
    super.key,
    required this.pageName,
    required this.pageNumber,
    required this.goToPage,
  });

  final String pageName;
  final int pageNumber;
  final void Function(int page) goToPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 30,
      decoration: boxDecoration(Colors.transparent, 100, 2, Colors.amber),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
          goToPage(pageNumber);
        },
        child: Text(
          pageName,
          style: textStyle(Colors.amber, 12, false),
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
    required this.goToPage,
  });

  final bool isTrade;
  final bool isPool;
  final bool isFarm;
  final void Function(int page) goToPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (isTrade)
          LinkButton(
            pageName: 'Trade',
            pageNumber: 1,
            goToPage: goToPage,
          ),
        if (isPool)
          LinkButton(
            pageName: 'Pool',
            pageNumber: 2,
            goToPage: goToPage,
          ),
        if (isFarm)
          LinkButton(
            pageName: 'Farm',
            pageNumber: 3,
            goToPage: goToPage,
          )
      ],
    );
  }
}

class TransactionConfirmed extends StatelessWidget {
  const TransactionConfirmed({
    super.key,
    required this.context,
    required this.goToPage,
    this.isTrade = false,
    this.isPool = false,
    this.isFarm = false,
  });

  final BuildContext context;
  final bool isTrade, isPool, isFarm;
  final void Function(int page) goToPage;

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
                        style: textStyle(Colors.white, 20, false),
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
                  goToPage: goToPage,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// dynamic
Dialog transactionConfirmed(BuildContext context) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 500.0;
  const edge = 40.0;
  if (_width < 505) wid = _width;
  var hgt = 335.0;
  if (_height < 340) hgt = _height;

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
          height: 275,
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
                      style: textStyle(Colors.white, 20, false),
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
            ],
          ),
        ),
      ),
    ),
  );
}

// dynamic
Dialog yourAXDialog(BuildContext context) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  var wid = 400.0;
  const edge = 40.0;
  if (_width < 405) wid = _width;
  var hgt = 500.0;
  if (_height < 505) hgt = _height;

  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      height: hgt,
      width: wid,
      decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 80,
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your AX',
                    style: textStyle(Colors.white, 20, false),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      context
                          .read<WalletBloc>()
                          .add(const UpdateAxDataRequested());
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            // 'X' logo
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width * (wid - 0.04),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  scale: 2,
                  image: AssetImage('assets/images/x.jpg'),
                ),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              height: 65,
              alignment: Alignment.center,
              child: const AxBalance(
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              width: wid - edge,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Balance:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      AxBalance(
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.35,
              color: Colors.grey[400],
            ),
            SizedBox(
              width: wid - edge,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AX price:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      const AxPrice(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AX in circulation:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      const AxCirculation(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AX total supply:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      ),
                      const AxTotalSupply(),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              width: wid - edge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 150,
                    height: 30,
                    decoration: boxDecoration(
                      Colors.amber[600]!,
                      100,
                      0,
                      Colors.amber[600]!,
                    ),
                    child: TextButton(
                      onPressed: () {
                        // TODO(KevinKamto): Update this when we need sushiswap
                        // connection
                        // String axEth =
                        //     "https://app.sushi.com/swap?inputCurrency=0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df&outputCurrency=0x7ceb23fd6bc0add59e62ac25578270cff1b9f619";
                        const axEthUniswap =
                            'https://app.uniswap.org/#/swap?chain=polygon';

                        launchUrl(Uri.parse(axEthUniswap));
                      },
                      child: Text(
                        'Buy AX',
                        style: textStyle(Colors.black, 14, true),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class AxPrice extends StatelessWidget {
  const AxPrice({super.key});

  @override
  Widget build(BuildContext context) {
    final price = context.select((WalletBloc bloc) => bloc.state.axData.price);
    final axPrice = price ?? '-';
    return Text(
      '$axPrice USD',
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey[600],
      ),
    );
  }
}

class AxCirculation extends StatelessWidget {
  const AxCirculation({super.key});

  @override
  Widget build(BuildContext context) {
    final circulatingSupply = context
        .select((WalletBloc bloc) => bloc.state.axData.circulatingSupply);
    final axCirculation = circulatingSupply ?? '-';
    return Text(
      '$axCirculation',
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey[600],
      ),
    );
  }
}

class AxTotalSupply extends StatelessWidget {
  const AxTotalSupply({super.key});

  @override
  Widget build(BuildContext context) {
    final totalSupply =
        context.select((WalletBloc bloc) => bloc.state.axData.totalSupply);
    final axTotalSupply = totalSupply ?? '-';
    return Text(
      '$axTotalSupply',
      style: TextStyle(
        fontSize: 15,
        color: Colors.grey[600],
      ),
    );
  }
}

class AxBalance extends StatelessWidget {
  const AxBalance({super.key, required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final balance =
        context.select((WalletBloc bloc) => bloc.state.axData.balance);
    final axBalance = balance ?? '-';
    return Text('$axBalance AX', style: style);
  }
}

class AccountDialog extends StatelessWidget {
  const AccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var wid = 400.0;
    const edge = 40.0;
    const edge2 = 60.0;
    if (_width < 405) wid = _width;
    var hgt = 240.0;
    if (_height < 235) hgt = _height;

    var formattedWalletAddress = '';
    if (walletAddress.isNotEmpty) {
      final walletAddressPrefix = walletAddress.substring(0, 7);
      final walletAddressSuffix = walletAddress.substring(
        walletAddress.length - 5,
        walletAddress.length,
      );
      formattedWalletAddress = '$walletAddressPrefix...$walletAddressSuffix';
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: hgt,
        width: wid,
        decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // title
              SizedBox(
                width: wid - edge,
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Account', style: textStyle(Colors.white, 20, false)),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // inner box
              Container(
                width: wid - edge,
                height: 145,
                decoration: boxDecoration(
                  Colors.transparent,
                  14,
                  .5,
                  Colors.grey[400]!,
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: wid - edge2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Connected With Metamask',
                                  style: textStyle(
                                    Colors.grey[600]!,
                                    13,
                                    false,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      formattedWalletAddress,
                                      style: textStyle(Colors.white, 20, false),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TODO(anyone): https://athletex.atlassian.net/browse/AX-734
                                // There's only MetaMask currently supported,
                                // so there's no point in having a change
                                // wallet button yet.

                                // Container(
                                //   width: 75,
                                //   height: 25,
                                //   decoration: boxDecoration(
                                //      Colors.transparent,
                                //       100, 0, Colors.blue[800]!),
                                //   child: TextButton(
                                //     onPressed: () {
                                //       controller.changeAddress();
                                //     },
                                //     child: Text(
                                //       "Change",
                                //       style: textStyle(
                                //           Colors.blue[300]!, 10, true),
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  width: 75,
                                  height: 25,
                                  decoration: boxDecoration(
                                    Colors.transparent,
                                    100,
                                    0,
                                    Colors.red[900]!,
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      context.read<WalletBloc>().add(
                                            const DisconnectWalletRequested(),
                                          );
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Disconnect',
                                      style: textStyle(
                                        Colors.red[900]!,
                                        10,
                                        true,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: walletAddress,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(
                                Icons.filter_none,
                                color: Colors.grey,
                              ),
                              Text(
                                'Copy Address',
                                style: textStyle(Colors.grey[400]!, 15, false),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            final urlString =
                                'https://polygonscan.com/address/$walletAddress';
                            launchUrl(Uri.parse(urlString));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(
                                Icons.open_in_new,
                                color: Colors.grey,
                              ),
                              Text(
                                'Show on Polygonscan',
                                style: textStyle(Colors.grey[400]!, 15, false),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle textStyle(Color color, double size, bool isBold) {
  if (isBold) {
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
  } else {
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
    );
  }
}

BoxDecoration boxDecoration(
  Color col,
  double rad,
  double borWid,
  Color borCol,
) {
  return BoxDecoration(
    color: col,
    borderRadius: BorderRadius.circular(rad),
    border: Border.all(color: borCol, width: borWid),
  );
}
