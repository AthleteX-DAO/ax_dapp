import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

/// Dialog for delegating or undelegating collateral to/from a Synthetix pool
class DelegateCollateralDialog extends StatefulWidget {
  const DelegateCollateralDialog({
    required this.token,
    this.initialMode = DelegationMode.delegate,
    super.key,
  });

  final Token token;
  final DelegationMode initialMode;

  @override
  State<DelegateCollateralDialog> createState() =>
      _DelegateCollateralDialogState();
}

enum DelegationMode { delegate, undelegate }

class _DelegateCollateralDialogState extends State<DelegateCollateralDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialMode == DelegationMode.delegate ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountState = context.watch<AccountBloc>().state;
    final walletAddress = context.select(
      (WalletBloc bloc) => bloc.state.formattedWalletAddress,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage ${widget.token.ticker} Delegation',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Wallet info
            if (walletAddress.isNotEmpty) ...[
              Text(
                'Wallet: $walletAddress',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Account info
            if (accountState.hasSynthetixAccount) ...[
              Text(
                'Account ID: ${accountState.synthetixAccountId}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              indicatorColor: Colors.amber,
              tabs: const [
                Tab(text: 'Delegate'),
                Tab(text: 'Undelegate'),
              ],
            ),
            const SizedBox(height: 24),

            // Tab content
            SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDelegateTab(context, accountState),
                  _buildUndelegateTab(context, accountState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDelegateTab(BuildContext context, AccountState accountState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delegate ${widget.token.ticker} to earn yield',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),

          // Amount input
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,18}')),
            ],
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              suffixText: widget.token.ticker,
              suffixStyle: const TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Pool info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pool: Preferred Pool (ID: 1)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Collateral will be automatically delegated to the preferred pool',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () => _handleDelegate(context, accountState),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : const Text(
                      'Delegate Collateral',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUndelegateTab(BuildContext context, AccountState accountState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Undelegate ${widget.token.ticker} from pool',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),

          // Amount input
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,18}')),
            ],
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              suffixText: widget.token.ticker,
              suffixStyle: const TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Warning
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Undelegating may affect your borrowing power and rewards',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () => _handleUndelegate(context, accountState),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Undelegate Collateral',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelegate(
    BuildContext context,
    AccountState accountState,
  ) async {
    if (!_formKey.currentState!.validate()) return;
    if (!accountState.hasSynthetixAccount) {
      _showError(context, 'Please create a Synthetix account first');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final amount = double.parse(_amountController.text);
      final amountBigInt = BigInt.from(
        amount * 1e18,
      ); // Assuming 18 decimals

      context.read<AccountBloc>().add(
            DelegateSynthetixCollateralRequested(
              poolId: 1, // Preferred pool
              collateralAddress: widget.token.address,
              amount: amountBigInt,
            ),
          );

      if (context.mounted) {
        Navigator.of(context).pop();
        _showSuccess(context, 'Delegation transaction submitted');
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Error delegating: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _handleUndelegate(
    BuildContext context,
    AccountState accountState,
  ) async {
    if (!_formKey.currentState!.validate()) return;
    if (!accountState.hasSynthetixAccount) {
      _showError(context, 'Please create a Synthetix account first');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final amount = double.parse(_amountController.text);
      final amountBigInt = BigInt.from(
        amount * 1e18,
      ); // Assuming 18 decimals

      context.read<AccountBloc>().add(
            UndelegateSynthetixCollateralRequested(
              poolId: 1, // Preferred pool
              collateralAddress: widget.token.address,
              amount: amountBigInt,
            ),
          );

      if (context.mounted) {
        Navigator.of(context).pop();
        _showSuccess(context, 'Undelegation transaction submitted');
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Error undelegating: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
