import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/dialogs/delegate_collateral_dialog.dart';
import 'package:ethereum_api/wallet_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:ax_dapp/earn/bloc/earn_page_bloc.dart';
import 'package:ax_dapp/service/controller/earn/vault_repository.dart';

class ProvideLiquidityTile extends StatelessWidget {
  const ProvideLiquidityTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccountBloc, AccountState, BigInt>(
      selector: (state) => state.synthetixAccountId,
      builder: (context, accountId) {
        return FutureBuilder<List<VaultData>>(
          key: ValueKey(accountId),
          future: context
              .read<VaultRepository>()
              .fetchVaults(overrideAccountId: accountId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFFC600)),
              );
            }

            final vaults = snapshot.data ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[400]!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[400]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_rounded,
                            color: Colors.blue[400],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'What is Liquidity Provision?',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Delegate collateral to the pool with optional leverage to earn higher yields. Your capital backs trading activity.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[300],
                          fontFamily: 'OpenSans',
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Pool info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Spartan Council Pool',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pool ID',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '#1',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Vault cards with leverage controls
                ...vaults.map((vault) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _LeverageVaultCard(vault: vault),
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

/// Vault card with leverage slider
class _LeverageVaultCard extends StatefulWidget {
  const _LeverageVaultCard({required this.vault});
  final VaultData vault;

  @override
  State<_LeverageVaultCard> createState() => _LeverageVaultCardState();
}

class _LeverageVaultCardState extends State<_LeverageVaultCard> {
  late TextEditingController _amountController;
  double _leverage = 1;

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
    _leverage = 1.0;

    showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Dialog(
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
                  'Provide Liquidity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Delegate ${widget.vault.symbol} with optional leverage',
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
                const SizedBox(height: 20),
                // Leverage slider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Leverage:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Tooltip(
                              message: 'Leverage multiplier for collateral (1x to 2x)',
                              child: Icon(
                                Icons.help_outline_rounded,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${_leverage.toStringAsFixed(1)}x',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[400],
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: _leverage,
                      min: 1,
                      max: 2,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() => _leverage = value);
                        context.read<EarnPageBloc>().add(
                          UpdateLeverage(value),
                        );
                      },
                      activeColor: Colors.amber[400],
                      inactiveColor: Colors.grey[700],
                    ),
                    const SizedBox(height: 8),
                    // Risk warning for leverage >= 1.5x
                    if (_leverage >= 1.5)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Higher leverage = higher yield but higher risk',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.orange[300],
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                // Submit button
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
                        debugPrint('🎯 [PROVIDE_LIQUIDITY] Button pressed!');
                        debugPrint('   vault.symbol: ${widget.vault.symbol}');
                        debugPrint('   vault.collateralAddress: ${widget.vault.collateralAddress}');
                        debugPrint('   vault.poolId: ${widget.vault.poolId}');
                        
                        final amount = double.tryParse(_amountController.text) ?? 0;
                        debugPrint('   input amount: $amount');
                        debugPrint('   leverage: $_leverage');
                        
                        if (amount > 0) {
                          debugPrint('   ✅ Submitting deposit with leverage...');
                          context.read<EarnPageBloc>().add(
                            SubmitDepositForm(
                              vaultSymbol: widget.vault.symbol,
                              amount: amount,
                              leverage: _leverage,
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
                        'Delegate with Leverage',
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
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up_rounded,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.vault.apy.toStringAsFixed(2)}% APY',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ],
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
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _showDepositDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Delegate Collateral',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Create a minimal Token object for the dialog
                    final token = Token.unknown(
                      widget.vault.symbol,
                      widget.vault.symbol,
                      widget.vault.collateralAddress,
                      EthereumChain.ethereumSepolia,
                    );
                    showDialog<void>(
                      context: context,
                      builder: (_) => BlocProvider.value(
                        value: context.read<AccountBloc>(),
                        child: DelegateCollateralDialog(
                          token: token,
                          initialMode: DelegationMode.undelegate,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Undelegate',
                    style: TextStyle(
                      color: Colors.black,
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
