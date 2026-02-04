import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const edge = 40.0;

    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, walletState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accountState) {
            // Calculate portfolio balance from wallet
            final walletBalance = walletState.walletBalance;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: edge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // === HERO BALANCE SECTION ===
                    HeroBalance(
                      balanceUsd: walletBalance,
                    ),
                    const SizedBox(height: 20),

                    // === NETWORK & WALLET STATUS ===
                    Row(
                      children: [
                        Expanded(
                          child: NetworkStatusWidget(
                            chainName: walletState.chain.name,
                            ethBalance: walletBalance,
                            gasPrice: walletState.gasPrice,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: WalletConnectionStatus(
                            walletAddress: walletState.walletAddress,
                            walletType: 'MetaMask',
                            chainId: walletState.chain.chainId,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // === UNIFIED ACCOUNT OVERVIEW ===
                    UnifiedAccountCard(
                      accountId: accountState.synthetixAccountId,
                      collateralDeposited:
                          accountState.synthetixCollateralDeposited,
                      collateralAssigned:
                          accountState.synthetixCollateralAssigned,
                      collateralAvailable:
                          accountState.synthetixCollateralAvailable,
                      debt: accountState.synthetixDebt,
                      collateralRatio: accountState.synthetixCollateralRatio,
                      isSynthetixLoading: accountState.isSynthetixAccountLoading,
                      vaults: accountState.vaults,
                      isVaultsLoading: accountState.isVaultsLoading,
                      vaultsError: accountState.vaultsError,
                      onCreateAccount: () {
                        context.read<AccountBloc>().add(
                              const CreateSynthetixAccountRequested(),
                            );
                      },
                      onViewSpotPositions: () => context.go('/spot-markets'),
                      onViewPerpsPositions: () => context.go('/perpetuals'),
                      onViewPredictionPositions: () => context.go('/predict'),
                      onViewVaultYields: () => context.go('/earn'),
                    ),
                    const SizedBox(height: 20),

                    // === ACTION BUTTONS ===
                    const WalletActionButtons(),
                    const SizedBox(height: 20),

                    // === DISCONNECT BUTTON ===
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wallet Connection',
                                style: textStyle(
                                  Colors.white,
                                  13,
                                  isBold: true,
                                  isUline: false,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                walletState.walletAddress.isEmpty
                                    ? 'Not connected'
                                    : walletState.walletAddress,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.15),
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              side: BorderSide(
                                color: Colors.red.withOpacity(0.3),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              context.read<WalletBloc>().add(
                                    const DisconnectWalletRequested(),
                                  );
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.logout, size: 16),
                            label: const Text('Disconnect'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

