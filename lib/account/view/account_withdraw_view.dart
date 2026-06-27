import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/account/widgets/withdraw_chain_selector.dart';
import 'package:ax_dapp/config/athletex_synthetix_config.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/widgets/token_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Withdraw screen with two tabs:
///   Tab 1 – Send crypto to another wallet (existing flow)
///   Tab 2 – Withdraw collateral from Synthetix account back to wallet
class AccountWithdrawView extends StatefulWidget {
  const AccountWithdrawView({super.key});

  @override
  State<AccountWithdrawView> createState() => _AccountWithdrawViewState();
}

class _AccountWithdrawViewState extends State<AccountWithdrawView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex =
        context.read<AccountBloc>().state.withdrawInitialTabIndex;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Back button row
        Row(
          children: [
            IconButton(
              alignment: Alignment.centerLeft,
              icon:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => context
                  .read<AccountBloc>()
                  .add(const AccountDetailsViewRequested()),
            ),
          ],
        ),
        // Tab bar
        TabBar(
          controller: _tabController,
          indicatorColor: primaryOrangeColor,
          labelColor: primaryOrangeColor,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.send_rounded, size: 18), text: 'Send'),
            Tab(
              icon: Icon(Icons.account_balance_rounded, size: 18),
              text: 'Protocol Withdraw',
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: TabBarView(
            controller: _tabController,
            children: const [
              _WalletSendTab(),
              _SynthetixWithdrawTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1 — Wallet send (existing flow, unchanged)
// ---------------------------------------------------------------------------

class _WalletSendTab extends StatelessWidget {
  const _WalletSendTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _Card(
            child: Row(
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
                          18,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Send funds to another wallet',
                        style:
                            TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Wallet address + chain selector + token container + recipient + button
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WalletAddress(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.layers_rounded,
                        color: Colors.blue, size: 18,),
                    const SizedBox(width: 8),
                    Text(
                      'Select Chain & Token',
                      style: textStyle(
                        Colors.white,
                        13,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const WithdrawChainSelector(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const _Card(child: TokenContainerWidget()),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_outline_rounded,
                        color: primaryOrangeColor, size: 18,),
                    const SizedBox(width: 8),
                    Text(
                      'Recipient Address',
                      style: textStyle(
                        Colors.white,
                        13,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const AccountRecipentAddressInput(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const AccountApproveWithdrawButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 2 — Synthetix protocol withdraw (undelegated collateral → wallet)
// ---------------------------------------------------------------------------

class _SynthetixWithdrawTab extends StatefulWidget {
  const _SynthetixWithdrawTab();

  @override
  State<_SynthetixWithdrawTab> createState() => _SynthetixWithdrawTabState();
}

class _SynthetixWithdrawTabState extends State<_SynthetixWithdrawTab> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (prev, curr) =>
          prev.chain != curr.chain ||
          prev.selectedCollateral != curr.selectedCollateral ||
          prev.isSynthetixAccountLoading != curr.isSynthetixAccountLoading ||
          prev.synthetixCollateralAvailable !=
              curr.synthetixCollateralAvailable,
      builder: (context, state) {
        final collaterals = AthleteXSynthetixConfig.collateralsForChain(
          state.chain.chainId,
        );
        final selected = state.selectedCollateral ?? collaterals.first;
        final isLoading = state.isSynthetixAccountLoading;
        final available = state.synthetixCollateralAvailable;
        final availableDecimal =
            selected.toDecimal(available);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: const Text(
                  'Withdraw undelegated collateral from the AthleteX protocol back to your wallet. You must undelegate first if all collateral is assigned to a pool.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Available balance
              _Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available to Withdraw',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${availableDecimal.toStringAsFixed(4)} ${selected.symbol}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Collateral picker
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Collateral',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: collaterals
                          .map(
                            (c) => _CollateralChip(
                              collateral: c,
                              isSelected: c == selected,
                              onTap: () => context
                                  .read<AccountBloc>()
                                  .add(CollateralTypeSelected(c)),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Amount input with MAX button
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount (${selected.symbol})',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style:
                                const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: '0.0',
                              hintStyle: const TextStyle(
                                color: Colors.white38,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primaryOrangeColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            _amountController.text =
                                availableDecimal.toStringAsFixed(4);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryOrangeColor,
                            side: BorderSide(color: primaryOrangeColor),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('MAX'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Withdraw button
              ElevatedButton.icon(
                onPressed: isLoading || available == BigInt.zero
                    ? null
                    : () {
                        final raw = double.tryParse(
                          _amountController.text.trim(),
                        );
                        if (raw == null || raw <= 0) return;
                        final amount = selected.toRaw(raw);
                        context.read<AccountBloc>().add(
                              WithdrawSynthetixCollateralRequested(
                                collateralAddress: selected.address,
                                amount: amount,
                              ),
                            );
                      },
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download_rounded),
                label: Text(
                  isLoading ? 'Processing…' : 'Withdraw to Wallet',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrangeColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helpers (same pattern as deposit view)
// ---------------------------------------------------------------------------

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
      ),
      child: child,
    );
  }
}

class _CollateralChip extends StatelessWidget {
  const _CollateralChip({
    required this.collateral,
    required this.isSelected,
    required this.onTap,
  });

  final CollateralInfo collateral;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryOrangeColor.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryOrangeColor
                : Colors.white.withOpacity(0.15),
          ),
        ),
        child: Text(
          collateral.symbol,
          style: TextStyle(
            color: isSelected ? primaryOrangeColor : Colors.white70,
            fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

