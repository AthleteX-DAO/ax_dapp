import 'package:ax_dapp/earn/bloc/earn_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BorrowStablecoinsTile extends StatefulWidget {
  const BorrowStablecoinsTile({super.key});

  @override
  State<BorrowStablecoinsTile> createState() => _BorrowStablecoinsTileState();
}

class _BorrowStablecoinsTileState extends State<BorrowStablecoinsTile> {
  bool _isMintMode = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab selector
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isMintMode = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _isMintMode
                          ? Colors.purple[400]!.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(10),
                      border: _isMintMode
                          ? Border.all(
                              color: Colors.purple[400]!,
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Text(
                      'Mint (Borrow)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _isMintMode
                            ? Colors.purple[400]
                            : Colors.grey[600],
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isMintMode = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_isMintMode
                          ? Colors.green.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(10),
                      border: !_isMintMode
                          ? Border.all(
                              color: Colors.green,
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Text(
                      'Repay (Burn)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: !_isMintMode
                            ? Colors.green
                            : Colors.grey[600],
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Content
        if (_isMintMode) const _MintSection() else const _BurnSection(),
      ],
    );
  }
}

/// Mint (Borrow) sUSD section
class _MintSection extends StatefulWidget {
  const _MintSection();

  @override
  State<_MintSection> createState() => _MintSectionState();
}

class _MintSectionState extends State<_MintSection> {
  late TextEditingController _amountController;
  final double _collateralRatio = 0;

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

  void _showMintDialog() {
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
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mint sUSD',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Borrow sUSD against your delegated collateral',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[400],
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                  Tooltip(
                    message:
                        'Borrow up to this amount without risking liquidation. Requires minimum 150% collateralization ratio.',
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
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
                  hintText: 'Amount to mint',
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
              // Available to borrow (placeholder)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[400]!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.purple[400]!.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available to borrow:',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '500 sUSD',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        Text(
                          '@ 200% C-ratio',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.purple[300],
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                      final amount = double.tryParse(_amountController.text) ?? 0;
                      if (amount > 0) {
                        context.read<EarnPageBloc>().add(
                          SubmitMintForm(
                            amount: amount,
                            collateralAddress:
                                '0xc43708f8987Df3f3681801e5e640667D86Ce3C30',
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[400],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text(
                      'Mint sUSD',
                      style: TextStyle(
                        color: Colors.white,
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
    return Column(
      children: [
        // Info box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple[400]!.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple[400]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: Colors.purple[400],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Mint lets you borrow sUSD stablecoins against your delegated collateral for trading or holding.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // C-ratio status card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Collateralization Ratio',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '200%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.1),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Mint button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showMintDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[400],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'Mint sUSD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Burn (Repay) sUSD section
class _BurnSection extends StatefulWidget {
  const _BurnSection();

  @override
  State<_BurnSection> createState() => _BurnSectionState();
}

class _BurnSectionState extends State<_BurnSection> {
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

  void _showBurnDialog() {
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
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Repay sUSD',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Return sUSD to reduce your debt and lower interest accrual',
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
                  hintText: 'Amount to repay',
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
              // Debt info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current debt:',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '250 sUSD',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Est. interest: ~7% APY',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange[300],
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
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
                      final amount = double.tryParse(_amountController.text) ?? 0;
                      if (amount > 0) {
                        context.read<EarnPageBloc>().add(
                          SubmitBurnForm(
                            amount: amount,
                            collateralAddress:
                                '0xc43708f8987Df3f3681801e5e640667D86Ce3C30',
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text(
                      'Repay sUSD',
                      style: TextStyle(
                        color: Colors.white,
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
    return Column(
      children: [
        // Info box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: Colors.green,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Repaying debt reduces interest accrual and improves your collateralization ratio.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Debt tracker
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
                'Your Debt Position',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Debt',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '250 sUSD',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Interest Rate',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '~7% APY',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
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
        const SizedBox(height: 20),
        // Repay button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showBurnDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'Repay sUSD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
