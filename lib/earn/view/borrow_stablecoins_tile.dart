import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/config/synthetix_config.dart';
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

// ─────────────────────────────────────────────────────────────────────
// Helper to format BigInt (18 decimals) as a human-readable string.
// ─────────────────────────────────────────────────────────────────────
String _formatBigInt18(BigInt value, {int fractionDigits = 2}) {
  if (value == BigInt.zero) return '0';
  final divisor = BigInt.from(10).pow(18);
  final whole = value ~/ divisor;
  final remainder = (value.remainder(divisor)).abs();
  if (fractionDigits == 0) return whole.toString();
  final fracStr =
      remainder.toString().padLeft(18, '0').substring(0, fractionDigits);
  return '$whole.$fracStr';
}

double _bigInt18ToDouble(BigInt value) {
  if (value == BigInt.zero) return 0;
  final divisor = BigInt.from(10).pow(18);
  return value.toDouble() / divisor.toDouble();
}

/// Mint (Borrow) axUSD section
class _MintSection extends StatefulWidget {
  const _MintSection();

  @override
  State<_MintSection> createState() => _MintSectionState();
}

class _MintSectionState extends State<_MintSection> {
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

  void _showMintDialog(AccountState accountState) {
    _amountController.clear();

    // Compute available to borrow from live state
    final delegated = _bigInt18ToDouble(accountState.synthetixCollateralAssigned);
    final debt = _bigInt18ToDouble(accountState.synthetixDebt);
    // At 200% target c-ratio, max borrow = delegated / 2 - existing debt
    final maxBorrow = (delegated / 2.0 - debt).clamp(0.0, double.infinity);
    final cRatioRaw = _bigInt18ToDouble(accountState.synthetixCollateralRatio);
    // cRatio from contract is already a percentage value (e.g. 2e18 = 200%)
    final cRatioDisplay = cRatioRaw > 0 ? (cRatioRaw * 100).toStringAsFixed(0) : '—';

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<EarnPageBloc>(),
        child: Dialog(
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
                  'mint axUSD',
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
                        'Borrow axUSD against your delegated collateral',
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
                // Available to borrow — LIVE DATA
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
                          Text(
                            '${maxBorrow.toStringAsFixed(2)} axUSD',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                          Text(
                            '@ $cRatioDisplay% C-ratio',
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
                Builder(
                  builder: (innerContext) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('🎯 [BORROW_STABLECOINS] Mint button pressed!');
                        final amount = double.tryParse(_amountController.text) ?? 0;
                        if (amount > 0) {
                          innerContext.read<EarnPageBloc>().add(
                            SubmitMintForm(
                              amount: amount,
                              collateralAddress: SynthetixConfig.axToken,
                            ),
                          );
                          Navigator.pop(innerContext);
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
                        'mint axUSD',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (prev, curr) =>
          prev.synthetixCollateralAssigned != curr.synthetixCollateralAssigned ||
          prev.synthetixDebt != curr.synthetixDebt ||
          prev.synthetixCollateralRatio != curr.synthetixCollateralRatio,
      builder: (context, accountState) {
        final delegated = _bigInt18ToDouble(accountState.synthetixCollateralAssigned);
        final debt = _bigInt18ToDouble(accountState.synthetixDebt);
        final maxBorrow = (delegated / 2.0 - debt).clamp(0.0, double.infinity);
        final cRatioRaw = _bigInt18ToDouble(accountState.synthetixCollateralRatio);
        final cRatioPercent = cRatioRaw > 0 ? (cRatioRaw * 100) : 0.0;
        final cRatioDisplay = cRatioPercent > 0 ? '${cRatioPercent.toStringAsFixed(0)}%' : '—';

        // Determine health color
        Color healthColor;
        IconData healthIcon;
        if (cRatioPercent == 0 || delegated == 0) {
          healthColor = Colors.grey;
          healthIcon = Icons.remove_circle_outline_rounded;
        } else if (cRatioPercent >= 200) {
          healthColor = Colors.green;
          healthIcon = Icons.check_circle_rounded;
        } else if (cRatioPercent >= 150) {
          healthColor = Colors.orange;
          healthIcon = Icons.warning_rounded;
        } else {
          healthColor = Colors.red;
          healthIcon = Icons.error_rounded;
        }

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
                          'Mint lets you borrow axUSD stablecoins against your delegated collateral for trading or holding.',
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
            // C-ratio status card — LIVE DATA
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
                      Text(
                        cRatioDisplay,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: healthColor,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Max borrowable: ${maxBorrow.toStringAsFixed(2)} axUSD',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
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
                      color: healthColor.withOpacity(0.1),
                      border: Border.all(color: healthColor, width: 2),
                    ),
                    child: Center(
                      child: Icon(
                        healthIcon,
                        color: healthColor,
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
                onPressed: delegated > 0
                    ? () => _showMintDialog(accountState)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[400],
                  disabledBackgroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  delegated > 0 ? 'mint axUSD' : 'Delegate collateral first',
                  style: TextStyle(
                    color: delegated > 0 ? Colors.white : Colors.grey[500],
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Burn (Repay) axUSD section
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

  void _showBurnDialog(AccountState accountState) {
    _amountController.clear();
    final currentDebt = _bigInt18ToDouble(accountState.synthetixDebt);

    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<EarnPageBloc>(),
        child: Dialog(
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
                  'Repay axUSD',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Return axUSD to reduce your debt and lower interest accrual',
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
                // Debt info — LIVE DATA
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
                      Text(
                        '${currentDebt.toStringAsFixed(2)} axUSD',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Submit button
                Builder(
                  builder: (innerContext) => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: currentDebt > 0
                          ? () {
                              final amount =
                                  double.tryParse(_amountController.text) ?? 0;
                              if (amount > 0) {
                                innerContext.read<EarnPageBloc>().add(
                                  SubmitBurnForm(
                                    amount: amount,
                                    collateralAddress: SynthetixConfig.axToken,
                                  ),
                                );
                                Navigator.pop(innerContext);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text(
                        'Repay axUSD',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (prev, curr) =>
          prev.synthetixDebt != curr.synthetixDebt ||
          prev.synthetixCollateralRatio != curr.synthetixCollateralRatio,
      builder: (context, accountState) {
        final currentDebt = _bigInt18ToDouble(accountState.synthetixDebt);

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
            // Debt tracker — LIVE DATA
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
                          Text(
                            '${currentDebt.toStringAsFixed(2)} axUSD',
                            style: const TextStyle(
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
                            'Status',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontFamily: 'OpenSans',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentDebt > 0 ? 'Debt Outstanding' : 'No Debt',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: currentDebt > 0
                                  ? Colors.orange
                                  : Colors.green,
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
                onPressed: currentDebt > 0
                    ? () => _showBurnDialog(accountState)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  currentDebt > 0 ? 'Repay axUSD' : 'No debt to repay',
                  style: TextStyle(
                    color: currentDebt > 0 ? Colors.white : Colors.grey[500],
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
