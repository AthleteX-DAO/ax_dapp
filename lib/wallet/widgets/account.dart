import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/usecases/explorer_usecase.dart';

import 'package:ax_dapp/wallet/widgets/wallet_gas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final chain = context.select((WalletBloc bloc) => bloc.state.chain);
    final walletBalance =
        context.select((WalletBloc bloc) => bloc.state.walletBalance);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var wid = 400.0;
    const edge = 40.0;
    const edge2 = 60.0;
    if (_width < 405) wid = _width;
    var formattedWalletAddress = '';
    if (walletAddress.isNotEmpty) {
      final walletAddressPrefix = walletAddress.substring(0, 7);
      final walletAddressSuffix = walletAddress.substring(
        walletAddress.length - 5,
        walletAddress.length,
      );
      formattedWalletAddress = '$walletAddressPrefix...$walletAddressSuffix';
    }

    final explorerUseCase =
        ExplorerUseCase(walletAddress: walletAddress, chain: chain);

    final buttonMessage = explorerUseCase.buttonMessage(chain);
    final explorerUrl = explorerUseCase.explorerUrl(chain);

    return Container(
      height: _height * 0.9,
      width: _width * 0.9,
      decoration: boxDecoration(Colors.transparent, 30, 0, Colors.transparent),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // title
            Container(
              margin: _width < 665
                  ? const EdgeInsets.symmetric(horizontal: 10)
                  : EdgeInsets.zero,
              width: wid - edge,
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Account Balances',
                    style: textStyle(
                      Colors.white,
                      20,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
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
              margin: _width < 665
                  ? const EdgeInsets.symmetric(horizontal: 10)
                  : EdgeInsets.zero,
              width: wid - edge,
              height: _height * 0.8,
              decoration: boxDecoration(
                Colors.transparent,
                14,
                .5,
                primaryOrangeColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: wid - edge2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: _height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '$walletBalance',
                                    style: textStyle(
                                      Colors.white,
                                      20,
                                      isBold: false,
                                      isUline: false,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.account_balance_wallet,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    formattedWalletAddress,
                                    style: textStyle(
                                      Colors.white,
                                      20,
                                      isBold: false,
                                      isUline: false,
                                    ),
                                  ),
                                  const WalletGas(),
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
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 5,
                                  top: 5,
                                ),
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
                                  child: FittedBox(
                                    child: SizedBox(
                                      child: Text(
                                        'Disconnect',
                                        style: textStyle(
                                          Colors.red[900]!,
                                          10,
                                          isBold: true,
                                          isUline: false,
                                        ),
                                      ),
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

                  //const WalletChain(), This functionality is currently broken

                  //Wallet Addess Functionality (copy & go to explorer)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              style: textStyle(
                                Colors.grey[400]!,
                                15,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          launchUrl(Uri.parse(explorerUrl));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              Icons.open_in_new,
                              color: Colors.grey,
                            ),
                            Text(
                              buttonMessage,
                              style: textStyle(
                                Colors.grey[400]!,
                                15,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Send, Recieve, Top up & view txn history
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.arrow_upward_outlined),
                        tooltip: 'Send your crypto ',
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_downward_outlined,
                        ),
                        tooltip: 'Recieve your crypto',
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.payments_sharp),
                        tooltip: 'Add to your USDC balance',
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.receipt_rounded),
                        tooltip: 'View your transaction history',
                        onPressed: () {
                          launchUrl(Uri.parse(explorerUrl));
                        },
                      ),
                    ],
                  ),

                  /// List of Sports Crypto owned by this wallet
                  const Row(
                    children: [
                      // Text('Your Wallet Assets'),
                      Stack(
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
