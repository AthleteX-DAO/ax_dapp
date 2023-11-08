import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDetails extends StatelessWidget {
  AccountDetails({
    super.key,
    required BoxConstraints boxConstraints,
    required this.width,
    required this.height,
  }) : constraints = boxConstraints;

  final BoxConstraints constraints;
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    var wid = 400.0;
    const edge = 40.0;
    const edge2 = 60.0;
    final _height = height;
    final _width = width;
    if (_width < 405) wid = _width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: wid - edge2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const WalletBalance(),
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

        // Send, Recieve, Top up & view txn history
        const WalletActionButtons(),
        // Divider
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: constraints.maxWidth - edge,
          child: const Divider(
            color: Colors.grey,
          ),
        ),

        // Assets filter -- remember to refresh the state
        WalletAssetsFilter(
          boxConstraints: BoxConstraints(
            maxHeight: _height * 0.8,
            maxWidth: constraints.maxWidth - edge,
          ),
        ),

        // Your Wallet Assets
        WalletAssetsList(
          boxConstraints: BoxConstraints(
            maxHeight: _height * 0.8,
            maxWidth: constraints.maxWidth - edge,
          ),
        ),
      ],
    );
  }
}
