import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var wid = 400.0;
    const edge2 = 60.0;
    final _width = MediaQuery.of(context).size.width;
    if (_width < 405) wid = _width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: wid - edge2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.3,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const WalletBalance(),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    side: BorderSide(color: Colors.red[900]!),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(
                                  const Size(
                                    75,
                                    35,
                                  ),
                                ),
                              ),
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
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WalletAddress(),
                            WalletGas(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const WalletActionButtons(),
            const Divider(
              color: Colors.grey,
            ),
            const AccountAssetsFilter(),
            const WalletAssetsList(),
          ],
        );
      },
    );
  }
}
