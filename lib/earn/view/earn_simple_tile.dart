import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/earn/bloc/earn_page_bloc.dart';
import 'package:ax_dapp/service/controller/earn/vault_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EarnSimpleTile extends StatelessWidget {
  const EarnSimpleTile({super.key});

  @override
  Widget build(BuildContext context) {
    // Re-fetch vaults whenever the Synthetix accountId changes so balances
    // update as soon as an account is created without needing a page reload.
    return BlocSelector<AccountBloc, AccountState, BigInt>(
      selector: (state) => state.synthetixAccountId,
      builder: (context, accountId) {
        final resolvedId =
            accountId == BigInt.zero ? null : accountId;
        return FutureBuilder<List<VaultData>>(
          key: ValueKey(accountId),
          future: context
              .read<VaultRepository>()
              .fetchVaults(overrideAccountId: resolvedId),
          builder: (context, snapshot) {
            // Error state — show message instead of crashing
            if (snapshot.hasError) {
              debugPrint('❌ [EARN_SIMPLE] fetchVaults error: ${snapshot.error}');
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 32),
                    const SizedBox(height: 8),
                    const Text(
                      'Failed to load vaults',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${snapshot.error}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 11,
                        fontFamily: 'OpenSans',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFFC600)),
              );
            }

            final vaults = snapshot.data ?? [];

            if (vaults.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'No vaults available',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vault cards
                ...vaults.map((vault) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _VaultCard(vault: vault),
                ),),
                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }
}

/// Individual vault card with deposit/withdraw options
class _VaultCard extends StatefulWidget {
  const _VaultCard({required this.vault});
  final VaultData vault;

  @override
  State<_VaultCard> createState() => _VaultCardState();
}

class _VaultCardState extends State<_VaultCard> {
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showDepositDialog() {
    _amountController.clear();
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.grey[900],
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[900],
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Deposit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Deposit ${widget.vault.symbol} to start earning yield',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[400],
                  fontFamily: 'OpenSans',
                ),
              ),
              const SizedBox(height: 24),
              // Amount input
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    final amount = double.tryParse(value) ?? 0;
                    context.read<EarnPageBloc>().add(UpdateAmount(amount));
                  }
                },
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Balance info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  Text(
                    '${widget.vault.balance.toStringAsFixed(4)} ${widget.vault.symbol}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber[400],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Submit button with hover effect for C-ratio refresh
              MouseRegion(
                onEnter: (_) {
                  context
                      .read<EarnPageBloc>()
                      .add(const RefreshCollateralRatioNow());
                },
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint('🎯 [EARN_SIMPLE] Deposit button pressed!');
                      debugPrint('   vault.symbol: ${widget.vault.symbol}');
                      debugPrint('   vault.collateralAddress: ${widget.vault.collateralAddress}');
                      debugPrint('   vault.poolId: ${widget.vault.poolId}');
                      
                      final amount = double.tryParse(_amountController.text) ?? 0;
                      debugPrint('   input amount: $amount');
                      
                      if (amount > 0) {
                        debugPrint('   ✅ Submitting deposit form...');
                        context.read<EarnPageBloc>().add(
                          SubmitDepositForm(
                            vaultSymbol: widget.vault.symbol,
                            amount: amount,
                          ),
                        );
                        Navigator.pop(context);
                        debugPrint('   ✅ Dialog closed, waiting for tx...');
                      } else {
                        debugPrint('   ❌ Invalid amount (must be > 0)');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[400],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text(
                      'Deposit',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWithdrawDialog() {
    _amountController.clear();
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.grey[900],
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[900],
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Withdraw',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Withdraw ${widget.vault.symbol} from the vault',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[400],
                  fontFamily: 'OpenSans',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    final amount = double.tryParse(value) ?? 0;
                    context.read<EarnPageBloc>().add(UpdateAmount(amount));
                  }
                },
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Deposited:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  Text(
                    '${widget.vault.balance.toStringAsFixed(4)} ${widget.vault.symbol}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber[400],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amount =
                        double.tryParse(_amountController.text) ?? 0;
                    if (amount > 0) {
                      context.read<EarnPageBloc>().add(
                        SubmitWithdrawForm(
                          vaultSymbol: widget.vault.symbol,
                          amount: amount,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[400],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text(
                    'Withdraw',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vault header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vault.symbol,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your balance: ${widget.vault.balance.toStringAsFixed(4)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Tooltip(
                    message: 'Rewards distributor coming soon',
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[500],
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.vault.apy.toStringAsFixed(2)}% Est. APY',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TVL: \$${(widget.vault.tvl / 1000000).toStringAsFixed(1)}M',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _showDepositDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[400],
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Deposit',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _showWithdrawDialog,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.amber[400]!, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Withdraw',
                    style: TextStyle(
                      color: Colors.amber[400],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
