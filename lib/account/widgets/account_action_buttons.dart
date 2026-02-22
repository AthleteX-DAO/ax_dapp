import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/usecases/explorer_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletActionButtons extends StatelessWidget {
  const WalletActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final chain = context.select((WalletBloc bloc) => bloc.state.chain);
    final accountId =
        context.select((AccountBloc bloc) => bloc.state.synthetixAccountId);

    return Column(
      children: [
        // Deposit/Withdraw split card
        DecoratedBox(
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
          child: Row(
            children: [
              // Deposit button
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<AccountBloc>().add(
                          const AccountDepositViewRequested(),
                        );
                  },
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.green,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Deposit',
                          style: textStyle(
                            Colors.white,
                            13,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Add funds',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Withdraw button
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<AccountBloc>().add(
                          const AccountWithdrawViewRequested(),
                        );
                  },
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.arrow_upward_rounded,
                          color: primaryOrangeColor,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Withdraw',
                          style: textStyle(
                            Colors.white,
                            13,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Remove funds',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Additional actions row
        Row(
          children: [
            // Buy/Sell USDC button
            Expanded(
              child: InkWell(
                onTap: () {
                  context.read<AccountBloc>().add(
                        const AccountBuyAndSellViewRequested(),
                      );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.06),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.swap_horiz_rounded,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Buy/Sell USDC',
                        style: textStyle(
                          Colors.white,
                          12,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Explorer button
            InkWell(
              onTap: () {
                final explorerUseCase = ExplorerUseCase(
                  walletAddress: walletAddress,
                  chain: chain,
                );
                final explorerUrl = explorerUseCase.explorerUrl(chain);
                launchUrl(Uri.parse(explorerUrl));
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.open_in_new_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        // Create Account button (only show if no account)
        if (accountId == 0) ...[
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              context.read<AccountBloc>().add(
                    const CreateSynthetixAccountRequested(),
                  );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryOrangeColor.withOpacity(0.2),
                    primaryOrangeColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryOrangeColor.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: primaryOrangeColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Create AthleteX Account',
                    style: textStyle(
                      primaryOrangeColor,
                      13,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

