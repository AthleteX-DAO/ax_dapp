import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/account/widgets/withdraw_chain_selector.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/widgets/token_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountWithdrawView extends StatelessWidget {
  const AccountWithdrawView({super.key});

  @override
  Widget build(BuildContext context) {
    const edge = 40.0;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(edge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back button
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
            const SizedBox(height: 20),
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryOrangeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: primaryOrangeColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Withdraw Crypto',
                              style: textStyle(
                                Colors.white,
                                20,
                                isBold: true,
                                isUline: false,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Send funds to another wallet',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const WalletAddress(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Chain selector
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.layers_rounded,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select Chain & Token',
                        style: textStyle(
                          Colors.white,
                          14,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const WithdrawChainSelector(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Token selector
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.toll_rounded,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select Amount',
                        style: textStyle(
                          Colors.white,
                          14,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const TokenContainerWidget(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Recipient address
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        color: primaryOrangeColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recipient Address',
                        style: textStyle(
                          Colors.white,
                          14,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const AccountRecipentAddressInput(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Submit button
            const AccountApproveWithdrawButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
