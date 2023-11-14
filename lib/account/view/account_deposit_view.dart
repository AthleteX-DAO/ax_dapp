import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountDepositView extends StatelessWidget {
  const AccountDepositView({super.key});

  @override
  Widget build(BuildContext context) {
    const edge = 40.0;
    const wid = 400.0;
    const edge2 = 60.0;
    final _height = MediaQuery.of(context).size.height;
    var formattedWalletAddress = '';

    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    if (walletAddress.isNotEmpty) {
      final walletAddressPrefix = walletAddress.substring(0, 7);
      final walletAddressSuffix = walletAddress.substring(
        walletAddress.length - 5,
        walletAddress.length,
      );
      formattedWalletAddress = '$walletAddressPrefix...$walletAddressSuffix';
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Don't lose track of your crypto!",
                              style: textStyle(
                                Colors.white,
                                15,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                          ],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
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
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Only deposit your assets from supported networks',
                              style: textStyle(
                                Colors.white,
                                15,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
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
              width: constraints.maxWidth - edge2,
              height: _height * 0.5,
              child: QrImageView(
                data: walletAddress,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
