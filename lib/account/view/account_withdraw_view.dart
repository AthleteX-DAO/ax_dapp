import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/account/widgets/withdraw_chain_selector.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/widgets/token_container.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountWithdrawView extends StatelessWidget {
  const AccountWithdrawView({super.key});

  @override
  Widget build(BuildContext context) {
    const edge = 40.0;
    const wid = 400.0;
    const edge2 = 60.0;
    const spacing = 25.0;
    final _height = MediaQuery.sizeOf(context).height;
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
            Center(
              child: SizedBox(
                width: wid - edge2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Select your Chain & Token Below',
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
                        WalletAddress(),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WithdrawChainSelector(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: constraints.maxWidth - edge,
              child: const Divider(
                color: Colors.grey,
              ),
            ),
            const TokenContainerWidget(),
            const SizedBox(height: spacing),
            const AccountRecipentAddressInput(),
            const SizedBox(height: spacing),
            const AccountApproveWithdrawButton(),
          ],
        );
      },
    );
  }
}
