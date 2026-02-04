import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/models/status.dart';
import 'package:ax_dapp/account/view/view.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.sizeOf(context).width;
    var wid = 400.0;
    const edge = 40.0;
    if (_width < 405) wid = _width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight * 0.85,
          width: constraints.maxWidth * 0.9,
          decoration:
              boxDecoration(Colors.transparent, 30, 0, Colors.transparent),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: constraints.maxWidth < 665
                      ? const EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.zero,
                  width: wid - edge,
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Portfolio',
                        style: textStyle(
                          Colors.white,
                          20,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.vpn_key,
                              color: Colors.white,
                              size: 20,
                            ),
                            tooltip: 'Copy Private Key',
                            onPressed: () => _copyPrivateKey(context),
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
                    ],
                  ),
                ),
                Container(
                  margin: constraints.maxWidth < 665
                      ? const EdgeInsets.symmetric(horizontal: 10)
                      : EdgeInsets.zero,
                  width: constraints.maxWidth - edge,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: BlocBuilder<AccountBloc, AccountState>(
                    builder: (BuildContext context, state) {
                        Widget content = const SizedBox.shrink();

                        if (state.accountViewStatus ==
                                AccountViewStatus.initial ||
                            state.accountViewStatus ==
                                AccountViewStatus.details ||
                            state.accountViewStatus ==
                                AccountViewStatus.none) {
                          content = const AccountDetails();
                        } else if (state.accountViewStatus ==
                            AccountViewStatus.buySell) {
                          content = const AccountBuyAndSell();
                        } else if (state.accountViewStatus ==
                            AccountViewStatus.deposit) {
                          content = const AccountDepositView();
                        } else if (state.accountViewStatus ==
                            AccountViewStatus.withdraw) {
                          content = const AccountWithdrawView();
                        } else if (state.accountViewStatus ==
                            AccountViewStatus.token) {
                          content = const AccountTokenView();
                        }

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: content,
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _copyPrivateKey(BuildContext context) async {
    final walletState = context.read<WalletBloc>().state;
    
    if (walletState.recoveryPhrase != null && walletState.recoveryPhrase!.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: walletState.recoveryPhrase!));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recovery phrase copied to clipboard'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recovery phrase not available'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

