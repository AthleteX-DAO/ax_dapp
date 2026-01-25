import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/earn_page_bloc.dart';
import '../../service/controller/earn/vault_repository.dart';

class EarnSimpleTile extends StatelessWidget {
  const EarnSimpleTile({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VaultData>>(
      future: context.read<VaultRepository>().fetchVaults(),
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
            // Vault cards
            ...vaults.map((vault) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _VaultCard(vault: vault),
            )),
            const SizedBox(height: 8),
          ],
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
  bool _isDepositMode = true;

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
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.grey[900],
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[900],
            border: Border.all(color: Colors.grey[700]!, width: 1),
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
                'Deposit ${widget.vault.symbol} to start earning ${widget.vault.apy.toStringAsFixed(2)}% APY',
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
                      final amount = double.tryParse(_amountController.text) ?? 0;
                      if (amount > 0) {
                        context.read<EarnPageBloc>().add(
                          SubmitDepositForm(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!, width: 1),
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
                  Row(
                    children: [
                      Icon(
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
                  onPressed: () {
                    // TODO: Show withdraw dialog
                  },
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
