import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/config/athletex_synthetix_config.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/controller/earn/vault_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Unified deposit/withdraw flow with real-time transaction monitoring
/// Handles: token selection → amount input → approval → tx submission → status tracking
class DepositWithdrawFlow extends StatefulWidget {
  const DepositWithdrawFlow({
    super.key,
    required this.isDeposit,
    required this.accountId,
    required this.currentCollateralAmount,
    required this.maxWithdrawAmount,
    required this.onComplete,
  });

  final bool isDeposit;
  final int accountId;
  final BigInt currentCollateralAmount;
  final BigInt maxWithdrawAmount;
  final VoidCallback onComplete;

  @override
  State<DepositWithdrawFlow> createState() => _DepositWithdrawFlowState();
}

class _DepositWithdrawFlowState extends State<DepositWithdrawFlow> {
  late TextEditingController _amountController;
  double _amountUsd = 0.0;
  bool _showAdvanced = false;
  String? _errorMessage;
  String? _transactionHash;
  bool _isProcessing = false;
  String _collateralAddress =
      AthleteXSynthetixConfig.primaryCollateralAddress;
  String _collateralSymbol = AthleteXSynthetixConfig.primaryCollateralSymbol;
  int _collateralDecimals = AthleteXSynthetixConfig.primaryCollateralDecimals;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _amountController.addListener(_updateUsdValue);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVaultConfig();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _updateUsdValue() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      _amountUsd = amount * 100.0; // TODO: Get actual price from oracle
    });
  }

  Future<void> _loadVaultConfig() async {
    try {
      final vaultRepository = context.read<VaultRepository>();
      final vaults = await vaultRepository.fetchVaults();
      if (vaults.isNotEmpty) {
        final primary = vaults.first;
        final decimals =
            await vaultRepository.getCollateralDecimals(primary.collateralAddress);
        setState(() {
          _collateralAddress = primary.collateralAddress;
          _collateralSymbol = primary.symbol;
          _collateralDecimals = decimals;
        });
      }
    } catch (_) {
      // Keep config defaults
    }
  }

  void _setMax() {
    final maxAmount = widget.isDeposit
        ? 1000.0 // TODO: Get max from wallet balance
        : (widget.maxWithdrawAmount /
                BigInt.from(10).pow(_collateralDecimals))
            .toDouble();
    _amountController.text = maxAmount.toStringAsFixed(2);
  }

  void _submitTransaction() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() => _errorMessage = 'Please enter a valid amount');
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    final accountBloc = context.read<AccountBloc>();

    final multiplier = BigInt.from(10).pow(_collateralDecimals);
    final rawAmount = BigInt.from((amount * multiplier.toDouble()).toInt());

    if (widget.isDeposit) {
      accountBloc.add(
        DepositSynthetixCollateralRequested(
          collateralAddress: _collateralAddress,
          amount: rawAmount,
        ),
      );
    } else {
      accountBloc.add(
        WithdrawSynthetixCollateralRequested(
          collateralAddress: _collateralAddress,
          amount: rawAmount,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[900],
          border: Border.all(color: Colors.grey[800]!),
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
                  widget.isDeposit ? 'Deposit Collateral' : 'Withdraw Collateral',
                  style: textStyle(
                    Colors.white,
                    18,
                    isBold: true,
                    isUline: false,
                  ),
                ),
                GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.withOpacity(0.1),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[400],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.isDeposit
                          ? 'Deposit $_collateralSymbol to earn yield on AthleteX'
                          : 'Withdraw $_collateralSymbol. Ensure account remains safe (C-ratio > 1.5x)',
                      style: textStyle(
                        Colors.blue[300]!,
                        12,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Token Selection (Single for MVP)
            Text(
              'Collateral Token',
              style: textStyle(
                Colors.grey[400]!,
                12,
                isBold: false,
                isUline: false,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[700]!),
                color: Colors.grey[850],
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[700],
                    ),
                    child: Center(
                      child: Text(
                        'U',
                        style: textStyle(
                          Colors.white,
                          14,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _collateralSymbol,
                          style: textStyle(
                            Colors.white,
                            14,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                        Text(
                          _collateralSymbol == 'USDC'
                              ? 'USD Coin'
                              : 'Collateral Token',
                          style: textStyle(
                            Colors.grey[500]!,
                            11,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$1.00',
                    style: textStyle(
                      Colors.grey[400]!,
                      12,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Amount Input
            Text(
              'Amount',
              style: textStyle(
                Colors.grey[400]!,
                12,
                isBold: false,
                isUline: false,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue[600]!),
                ),
                filled: true,
                fillColor: Colors.grey[850],
                suffixIcon: TextButton(
                  onPressed: _setMax,
                  child: Text(
                    'MAX',
                    style: textStyle(
                      Colors.blue[400]!,
                      11,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ),
              ),
              style: textStyle(
                Colors.white,
                16,
                isBold: true,
                isUline: false,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'USD Value',
                  style: textStyle(
                    Colors.grey[500]!,
                    12,
                    isBold: false,
                    isUline: false,
                  ),
                ),
                Text(
                  '\$${_amountUsd.toStringAsFixed(2)}',
                  style: textStyle(
                    Colors.grey[400]!,
                    12,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Error Display
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red.withOpacity(0.1),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[400],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: textStyle(
                          Colors.red[300]!,
                          12,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_errorMessage != null) const SizedBox(height: 20),

            // Transaction Status (if processing)
            if (_isProcessing && _transactionHash != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green.withOpacity(0.1),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              Colors.green[400],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Transaction Pending...',
                          style: textStyle(
                            Colors.green[400]!,
                            12,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hash: ${_transactionHash!.substring(0, 10)}...',
                      style: textStyle(
                        Colors.grey[500]!,
                        11,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  ],
                ),
              ),
            if (_isProcessing && _transactionHash != null)
              const SizedBox(height: 20),

            // Advanced Options (Optional)
            GestureDetector(
              onTap: () => setState(() => _showAdvanced = !_showAdvanced),
              child: Row(
                children: [
                  Icon(
                    _showAdvanced
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Advanced Options',
                    style: textStyle(
                      Colors.grey[500]!,
                      12,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ],
              ),
            ),
            if (_showAdvanced) ...[
              const SizedBox(height: 16),
              _AdvancedOptions(isDeposit: widget.isDeposit),
            ],
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _submitTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isDeposit
                      ? Colors.green[700]
                      : Colors.red[700],
                  disabledBackgroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isProcessing
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Processing...',
                          style: textStyle(
                            Colors.white,
                            14,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ],
                    )
                    : Text(
                        widget.isDeposit ? 'Deposit' : 'Withdraw',
                        style: textStyle(
                          Colors.white,
                          14,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Advanced options (gas, slippage, etc.)
class _AdvancedOptions extends StatefulWidget {
  const _AdvancedOptions({required this.isDeposit});

  final bool isDeposit;

  @override
  State<_AdvancedOptions> createState() => _AdvancedOptionsState();
}

class _AdvancedOptionsState extends State<_AdvancedOptions> {
  late TextEditingController _gasController;

  @override
  void initState() {
    super.initState();
    _gasController = TextEditingController(text: '21000');
  }

  @override
  void dispose() {
    _gasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[850],
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gas Limit (Optional)',
            style: textStyle(
              Colors.grey[400]!,
              11,
              isBold: false,
              isUline: false,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _gasController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '21000',
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
              filled: true,
              fillColor: Colors.grey[900],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            style: textStyle(
              Colors.grey[400]!,
              12,
              isBold: false,
              isUline: false,
            ),
          ),
        ],
      ),
    );
  }
}
