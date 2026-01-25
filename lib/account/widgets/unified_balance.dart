import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/usecases/unified_portfolio_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';

class UnifiedBalance extends StatefulWidget {
  const UnifiedBalance({super.key});

  @override
  State<UnifiedBalance> createState() => _UnifiedBalanceState();
}

class _UnifiedBalanceState extends State<UnifiedBalance> {
  double? _cached;
  bool _loading = false;

  Future<void> _refresh(BuildContext context) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final usecase = context.read<UnifiedPortfolioUseCase>();
      final total = await usecase.totalUsdcAcrossPrimaryChains();
      setState(() => _cached = total);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Kick off an initial fetch when wallet connects.
    final isConnected = context.read<WalletBloc>().state.isWalletConnected;
    if (isConnected && _cached == null && !_loading) {
      _refresh(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnected =
        context.select((WalletBloc b) => b.state.isWalletConnected);

    return TextButton(
      onPressed: isConnected ? () => _refresh(context) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.white,
          ),
          Text(
            isConnected
                ? _format(_cached, loading: _loading)
                : '0.00',
            style: textStyle(
              Colors.white,
              20,
              isBold: false,
              isUline: false,
            ),
          ),
        ],
      ),
    );
  }

  String _format(double? v, {required bool loading}) {
    if (loading) return '...';
    final value = v ?? 0.0;
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(2)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
    return '\$${value.toStringAsFixed(2)}';
  }
}
