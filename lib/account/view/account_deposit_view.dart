import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/account/models/status.dart';
import 'package:ax_dapp/config/athletex_synthetix_config.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Deposit screen with two tabs:
///   Tab 1 – Receive crypto (QR code + address copy)
///   Tab 2 – Synthetix LP path: deposit collateral → auto-delegate → mint axUSD
class AccountDepositView extends StatefulWidget {
  const AccountDepositView({super.key});

  @override
  State<AccountDepositView> createState() => _AccountDepositViewState();
}

class _AccountDepositViewState extends State<AccountDepositView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
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
            Tab(icon: Icon(Icons.qr_code_rounded, size: 18), text: 'Receive'),
            Tab(
              icon: Icon(Icons.account_balance_rounded, size: 18),
              text: 'Earn (LP)',
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: TabBarView(
            controller: _tabController,
            children: const [
              _WalletReceiveTab(),
              _SynthetixDepositTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1 — Wallet receive (QR code + copy address)
// ---------------------------------------------------------------------------

class _WalletReceiveTab extends StatelessWidget {
  const _WalletReceiveTab();

  @override
  Widget build(BuildContext context) {
    const edge = 16.0;
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final chain = context.select((WalletBloc bloc) => bloc.state.chain);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(edge),
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
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deposit Crypto',
                        style: textStyle(
                          Colors.white,
                          18,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Send funds to your wallet',
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Network warning
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Only deposit from ${chain.name}. Sending from other networks may cause permanent loss.',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // QR + address
          _Card(
            child: Column(
              children: [
                Text(
                  'Scan QR Code',
                  style: textStyle(
                    Colors.white,
                    15,
                    isBold: true,
                    isUline: false,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: QrImageView(
                    data: walletAddress,
                    size: 220,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Or copy your address',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: walletAddress));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address copied to clipboard'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          color: primaryOrangeColor,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            walletAddress,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.content_copy_rounded,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Network info
          _Card(
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.blue,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Network: ${chain.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Deposits typically arrive in 1-2 minutes',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 2 — Synthetix LP path: deposit collateral → auto-delegate → mint axUSD
// ---------------------------------------------------------------------------

class _SynthetixDepositTab extends StatefulWidget {
  const _SynthetixDepositTab();

  @override
  State<_SynthetixDepositTab> createState() => _SynthetixDepositTabState();
}

class _SynthetixDepositTabState extends State<_SynthetixDepositTab> {
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (prev, curr) =>
          prev.chain != curr.chain ||
          prev.selectedCollateral != curr.selectedCollateral ||
          prev.synthetixTxStatus != curr.synthetixTxStatus ||
          prev.isSynthetixAccountLoading != curr.isSynthetixAccountLoading ||
          prev.mintSliderValue != curr.mintSliderValue ||
          prev.synthetixCollateralAssigned !=
              curr.synthetixCollateralAssigned ||
          prev.axUsdBalance != curr.axUsdBalance ||
          prev.axUsdInAccount != curr.axUsdInAccount ||
          prev.synthetixTxError != curr.synthetixTxError ||
          prev.hasSynthetixAccount != curr.hasSynthetixAccount,
      builder: (context, state) {
        final collaterals = AthleteXSynthetixConfig.collateralsForChain(
          state.chain.chainId,
        );
        final selected = state.selectedCollateral ?? collaterals.first;
        final txStatus = state.synthetixTxStatus;
        final isLoading = state.isSynthetixAccountLoading;
        final sliderValue = state.mintSliderValue;

        final inputText = _amountController.text.trim();
        final rawAmount = double.tryParse(inputText);
        String? amountError;
        if (inputText.isNotEmpty) {
          if (rawAmount == null || rawAmount <= 0) {
            amountError = 'Enter a valid positive number';
          } else {
            final currentDepositedDecimal =
                selected.toDecimal(state.synthetixCollateralDeposited);
            final expectedTotal = currentDepositedDecimal + rawAmount;
            if (expectedTotal < selected.minDelegation) {
              amountError =
                  'Minimum total delegation is ${selected.minDelegation.toStringAsFixed(0)} ${selected.symbol}. (Current: ${currentDepositedDecimal.toStringAsFixed(2)}, Expected: ${expectedTotal.toStringAsFixed(2)})';
            }
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LP Path: Earn yield on your collateral',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '1. Deposit  →  2. Auto-delegate to pool  →  3. Mint axUSD  →  4. Trade synths',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Collateral picker
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Collateral',
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
                          .where((c) => !c.isWrappable) // LP path = non-wrap
                          .map(
                            (c) => _CollateralChip(
                              collateral: c,
                              isSelected: c == selected,
                              onTap: () {
                                context.read<AccountBloc>().add(
                                      CollateralTypeSelected(c),
                                    );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Amount input
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount to Deposit (${selected.symbol})',
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
                        errorText: amountError,
                        errorMaxLines: 3,
                        hintStyle:
                            const TextStyle(color: Colors.white38),
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
                          borderSide:
                              BorderSide(color: primaryOrangeColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Mint slider
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mint axUSD (% of safe maximum)',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${(sliderValue * 100).round()}%',
                          style: TextStyle(
                            color: primaryOrangeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: sliderValue,
                      divisions: 20,
                      activeColor: primaryOrangeColor,
                      inactiveColor: Colors.white24,
                      onChanged: (v) => context
                          .read<AccountBloc>()
                          .add(MintSliderChanged(v)),
                    ),
                    const Text(
                      '50% keeps c-ratio ~5× (safe). 80% is aggressive.',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Tx stepper
              if (txStatus != SynthetixTxStatus.idle)
                _TxStepper(status: txStatus),
              if (txStatus != SynthetixTxStatus.idle)
                const SizedBox(height: 12),

              // Error message
              if (txStatus == SynthetixTxStatus.error &&
                  state.synthetixTxError != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    state.synthetixTxError!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
              if (txStatus == SynthetixTxStatus.error &&
                  state.synthetixTxError != null)
                const SizedBox(height: 12),

              // Guard: need Synthetix account before depositing
              if (!state.hasSynthetixAccount) ...[
                ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => context.read<AccountBloc>().add(
                            const CreateSynthetixAccountRequested(),
                          ),
                  icon: const Icon(Icons.account_box_rounded),
                  label: const Text('Create Synthetix Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ] else ...[
              // Deposit + Delegate button
              ElevatedButton.icon(
                onPressed: isLoading || amountError != null || inputText.isEmpty
                    ? null
                    : () {
                        final raw = double.tryParse(
                          _amountController.text.trim(),
                        );
                        if (raw == null || raw <= 0) return;
                        final amount = selected.toRaw(raw);
                        context.read<AccountBloc>().add(
                              DepositSynthetixCollateralRequested(
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
                    : const Icon(Icons.savings_rounded),
                label: Text(
                  isLoading ? 'Processing…' : 'Deposit & Delegate',
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
              const SizedBox(height: 10),

              // Mint axUSD button (only if delegated collateral exists)
              if (state.synthetixCollateralAssigned > BigInt.zero)
                OutlinedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<AccountBloc>().add(
                                MintAxUsdRequested(
                                  collateralAddress: selected.address,
                                  sliderValue: sliderValue,
                                ),
                              );
                        },
                  icon: const Icon(Icons.currency_exchange_rounded),
                  label: const Text('Mint axUSD'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryOrangeColor,
                    side: BorderSide(color: primaryOrangeColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              // axUSD balances
              if (state.axUsdBalance > BigInt.zero ||
                  state.axUsdInAccount > BigInt.zero) ...[
                const SizedBox(height: 12),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'axUSD Balances',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _BalanceRow(
                        label: 'In wallet',
                        amount: state.axUsdBalance,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 4),
                      _BalanceRow(
                        label: 'In account (pending withdrawal)',
                        amount: state.axUsdInAccount,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ],
              ], // end else (has account)

              // DEBUG PANEL
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getDebugStatusColor(txStatus),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.bug_report,
                          color: _getDebugStatusColor(txStatus),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'DEBUG PANEL',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _getDebugStatusColor(txStatus),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'TX Status: ${txStatus.name}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _getDebugStatusColor(txStatus),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Has Account: ${state.hasSynthetixAccount}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                    if (state.hasSynthetixAccount)
                      Text(
                        'Account ID: ${state.synthetixAccountId}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    Text(
                      'Collateral: ${selected.symbol} (${selected.address})',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (state.synthetixTxError != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'ERROR: ${state.synthetixTxError}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Color _getDebugStatusColor(SynthetixTxStatus status) {
    switch (status) {
      case SynthetixTxStatus.idle:
        return Colors.grey;
      case SynthetixTxStatus.approving:
        return Colors.blue;
      case SynthetixTxStatus.depositing:
        return Colors.amber;
      case SynthetixTxStatus.delegating:
        return Colors.orange;
      case SynthetixTxStatus.minting:
        return Colors.purple;
      case SynthetixTxStatus.done:
        return Colors.green;
      case SynthetixTxStatus.error:
        return Colors.red;
    }
  }
}

// ---------------------------------------------------------------------------
// Shared helper widgets
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

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final BigInt amount;
  final Color color;

  static final _decimals18 = BigInt.from(10).pow(18);

  @override
  Widget build(BuildContext context) {
    final value = amount.toDouble() / _decimals18.toDouble();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        Text(
          '${value.toStringAsFixed(4)} axUSD',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

/// Step indicator for the deposit → delegate → mint flow.
class _TxStepper extends StatelessWidget {
  const _TxStepper({required this.status});
  final SynthetixTxStatus status;

  static const _steps = [
    _Step(SynthetixTxStatus.approving, 'Approve'),
    _Step(SynthetixTxStatus.depositing, 'Deposit'),
    _Step(SynthetixTxStatus.delegating, 'Delegate'),
    _Step(SynthetixTxStatus.minting, 'Mint'),
    _Step(SynthetixTxStatus.done, 'Done'),
  ];

  @override
  Widget build(BuildContext context) {
    final isError = status == SynthetixTxStatus.error;
    // error is not in _steps — when errored, show all steps as red
    final curIdx = isError ? -1 : _steps.indexWhere((s) => s.status == status);

    return Row(
      children: List.generate(_steps.length, (idx) {
        final step = _steps[idx];
        final isDone = !isError &&
            (idx < curIdx ||
                (status == SynthetixTxStatus.done &&
                    idx == _steps.length - 1));
        final isActive = !isError && step.status == status;

        Color color;
        if (isError) {
          color = Colors.redAccent;
        } else if (isDone) {
          color = Colors.green;
        } else if (isActive) {
          color = primaryOrangeColor;
        } else {
          color = Colors.white24;
        }

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.2),
                      border: Border.all(color: color),
                    ),
                    child: isActive
                        ? Padding(
                            padding: const EdgeInsets.all(6),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: color,
                            ),
                          )
                        : Icon(
                            isDone
                                ? Icons.check_rounded
                                : isError
                                    ? Icons.close_rounded
                                    : Icons.circle_outlined,
                            size: 14,
                            color: color,
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.label,
                    style: TextStyle(color: color, fontSize: 9),
                  ),
                ],
              ),
              if (idx < _steps.length - 1)
                Expanded(
                  child: Divider(
                    color: isDone ? Colors.green : Colors.white24,
                    thickness: 1.5,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _Step {
  const _Step(this.status, this.label);
  final SynthetixTxStatus status;
  final String label;
}

