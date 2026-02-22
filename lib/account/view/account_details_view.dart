import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({
    super.key,
  });

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _showRecoveryPhrase = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleRecoveryPhrase() {
    setState(() {
      _showRecoveryPhrase = !_showRecoveryPhrase;
      if (_showRecoveryPhrase) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _copyRecoveryPhrase(BuildContext context) async {
    final walletState = context.read<WalletBloc>().state;

    if (walletState.recoveryPhrase != null &&
        walletState.recoveryPhrase!.isNotEmpty) {
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

  String _smartTruncateAddress(String address, double availableWidth) {
    if (address.isEmpty) return 'Not connected';

    // Estimate characters that fit based on width
    // Rough estimate: ~1 character per 7 pixels at fontSize 11
    final maxChars = (availableWidth / 7).toInt();

    if (address.length <= 10) return address;
    if (maxChars < 15) {
      // Very tight: show 0x...last4
      return '0x...${address.substring(address.length - 4)}';
    }
    // Default truncation
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    const edge = 40.0;

    return BlocBuilder<WalletBloc, WalletState>(
      buildWhen: (previous, current) =>
        previous.walletBalance != current.walletBalance ||
        previous.chain != current.chain ||
        previous.gasPrice != current.gasPrice ||
        previous.walletAddress != current.walletAddress,
      builder: (context, walletState) {
      return BlocBuilder<AccountBloc, AccountState>(
        buildWhen: (previous, current) =>
          previous.synthetixAccountId !=
            current.synthetixAccountId ||
          previous.synthetixCollateralDeposited !=
            current.synthetixCollateralDeposited ||
          previous.synthetixCollateralAssigned !=
            current.synthetixCollateralAssigned ||
          previous.synthetixCollateralAvailable !=
            current.synthetixCollateralAvailable ||
          previous.synthetixDebt != current.synthetixDebt ||
          previous.synthetixCollateralRatio !=
            current.synthetixCollateralRatio ||
          previous.isSynthetixAccountLoading !=
            current.isSynthetixAccountLoading ||
          previous.vaults != current.vaults ||
          previous.isVaultsLoading != current.isVaultsLoading ||
          previous.vaultsError != current.vaultsError,
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
                          child: _buildWalletSection(context, walletState),
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
                      axUsdBalance: accountState.axUsdBalance,
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

                    // === WALLET CONNECTION & RECOVERY PHRASE ===
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
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: _toggleRecoveryPhrase,
                            borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recovery Phrase',
                                          style: textStyle(
                                            Colors.white,
                                            13,
                                            isBold: true,
                                            isUline: false,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Tap to reveal',
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    _showRecoveryPhrase
                                        ? Icons.expand_less_rounded
                                        : Icons.expand_more_rounded,
                                    color: Colors.white70,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_showRecoveryPhrase)
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.yellow.withOpacity(0.2),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.warning_rounded,
                                              color: Colors.yellow[700],
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Never share your recovery phrase',
                                                style: TextStyle(
                                                  color: Colors.yellow[700],
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      GestureDetector(
                                        onLongPress: () =>
                                            _copyRecoveryPhrase(context),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.02),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors
                                                  .white.withOpacity(0.15),
                                            ),
                                          ),
                                          child: SelectableText(
                                            context
                                                    .read<WalletBloc>()
                                                    .state
                                                    .recoveryPhrase ??
                                                'Not available',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11,
                                              fontFamily: 'monospace',
                                              height: 1.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Long press to copy',
                                        style: TextStyle(
                                          color: Colors.white30,
                                          fontSize: 9,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Divider(
                            height: 0,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Wallet Address',
                                        style: textStyle(
                                          Colors.white,
                                          13,
                                          isBold: true,
                                          isUline: false,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          final truncated =
                                              _smartTruncateAddress(
                                            walletState.walletAddress,
                                            constraints.maxWidth - 12,
                                          );
                                          return Text(
                                            truncated,
                                            style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 11,
                                              fontFamily: 'monospace',
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red.withOpacity(0.15),
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

  Widget _buildWalletSection(
    BuildContext context,
    WalletState walletState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
      child: InkWell(
        onTap: _toggleRecoveryPhrase,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Wallet Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    walletState.chain.name,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.green.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Connected',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),    );
  }
}