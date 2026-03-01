import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/models/status.dart';
import 'package:ax_dapp/config/athletex_synthetix_config.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Trader path: wrap USDC / USDT / WETH into their synth equivalents.
///
/// No LP delegation required — the user just approves and calls `wrap()` on
/// SpotMarketProxy.  The synth lands in their wallet and can immediately be
/// traded on any AthleteX Spot Market.
///
/// Market IDs are chain-specific; the map below reflects our Sepolia deploy.
/// TODO: move into AthleteXSynthetixConfig once we have mainnet IDs.
class WrapFlowView extends StatefulWidget {
  const WrapFlowView({super.key});

  @override
  State<WrapFlowView> createState() => _WrapFlowViewState();
}

class _WrapFlowViewState extends State<WrapFlowView> {
  final _amountController = TextEditingController();

  /// SpotMarket market IDs for wrappable collaterals on Sepolia.
  static const Map<String, int> _marketIdBySepolia = {
    '0xC2567853F68299DeaFcB5B5c3b00a5a6bCA88f42': 2, // USDC → axUSDC (market #2)
    '0x4E7374B31Aa01BdFd8A7d4cf929c02Ba4a2B70Be': 3, // USDT → axUSDT (market #3)
    '0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14': 4, // WETH → axWETH (market #4 placeholder)
  };

  int? _marketIdForCollateral(String address) =>
      _marketIdBySepolia[address] ??
      _marketIdBySepolia.entries
          .cast<MapEntry<String, int>?>()
          .firstWhere(
            (e) => e!.key.toLowerCase() == address.toLowerCase(),
            orElse: () => null,
          )
          ?.value;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final wrappables = AthleteXSynthetixConfig.wrappableCollateralsForChain(
          state.chain.chainId,
        );
        final selected = (state.selectedCollateral?.isWrappable ?? false)
            ? state.selectedCollateral!
            : (wrappables.isNotEmpty ? wrappables.first : null);
        final isLoading = state.isSynthetixAccountLoading;
        final txStatus = state.synthetixTxStatus;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                      onPressed: () => context
                          .read<AccountBloc>()
                          .add(const AccountDetailsViewRequested()),
                    ),
                  ],
                ),

                // Header
                _Card(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.swap_horiz_rounded,
                          color: Colors.purple,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wrap Token (Trader Path)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Convert USDC / USDT / WETH into synths — no delegation needed',
                              style:
                                  TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Info banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.withOpacity(0.3)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How it works',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '1. Approve token allowance on SpotMarketProxy\n'
                        '2. Call wrap() — synth lands in your wallet instantly\n'
                        '3. Trade the synth on any AthleteX Spot Market',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Token picker
                if (wrappables.isNotEmpty) ...[
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Token to Wrap',
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
                          children: wrappables
                              .map(
                                (c) => _CollateralChip(
                                  collateral: c,
                                  isSelected: c == selected,
                                  synthSymbol:
                                      'ax${c.symbol}',
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
                ],

                // Amount input
                if (selected != null) ...[
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount to Wrap (${selected.symbol})',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: '0.0',
                            hintStyle: const TextStyle(color: Colors.white38),
                            suffixText: selected.symbol,
                            suffixStyle: TextStyle(
                              color: primaryOrangeColor,
                              fontWeight: FontWeight.bold,
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
                              borderSide: BorderSide(color: primaryOrangeColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.purple,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'You will receive ≈ ${_amountController.text.isNotEmpty ? _amountController.text : "0"} ax${selected.symbol}',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tx status
                  if (txStatus != SynthetixTxStatus.idle) ...[
                    _WrapStatusBanner(status: txStatus, error: state.synthetixTxError),
                    const SizedBox(height: 12),
                  ],

                  // Wrap button
                  ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () {
                            final raw = double.tryParse(
                              _amountController.text.trim(),
                            );
                            if (raw == null || raw <= 0) return;
                            final marketId =
                                _marketIdForCollateral(selected.address);
                            if (marketId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Market ID not configured for this token'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }
                            final amount = selected.toRaw(raw);
                            context.read<AccountBloc>().add(
                                  WrapCollateralRequested(
                                    marketId: marketId,
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
                        : const Icon(Icons.swap_horiz_rounded),
                    label: Text(isLoading ? 'Wrapping…' : 'Wrap Token'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],

                if (wrappables.isEmpty)
                  const _Card(
                    child: Text(
                      'No wrappable tokens available on this network.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
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
    required this.synthSymbol,
    required this.onTap,
  });

  final CollateralInfo collateral;
  final bool isSelected;
  final String synthSymbol;
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
              ? Colors.purple.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.white.withOpacity(0.15),
          ),
        ),
        child: Column(
          children: [
            Text(
              collateral.symbol,
              style: TextStyle(
                color: isSelected ? Colors.purple : Colors.white70,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            Text(
              '→ $synthSymbol',
              style: TextStyle(
                color: isSelected
                    ? Colors.purple.withOpacity(0.8)
                    : Colors.white38,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WrapStatusBanner extends StatelessWidget {
  const _WrapStatusBanner({required this.status, this.error});
  final SynthetixTxStatus status;
  final String? error;

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData iconData;
    String message;

    switch (status) {
      case SynthetixTxStatus.approving:
        color = Colors.orange;
        iconData = Icons.lock_open_rounded;
        message = 'Approving token…';
      case SynthetixTxStatus.depositing:
        color = Colors.blue;
        iconData = Icons.sync_rounded;
        message = 'Wrapping token…';
      case SynthetixTxStatus.done:
        color = Colors.green;
        iconData = Icons.check_circle_rounded;
        message = 'Wrap complete! Synth is in your wallet.';
      case SynthetixTxStatus.error:
        color = Colors.redAccent;
        iconData = Icons.error_rounded;
        message = error ?? 'Transaction failed';
      default:
        color = Colors.white54;
        iconData = Icons.info_rounded;
        message = '';
    }

    if (message.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(iconData, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
