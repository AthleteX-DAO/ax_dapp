import 'dart:ui';

import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/service/controller/earn/vault_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/earn/bloc/earn_page_bloc.dart';
import 'package:ax_dapp/earn/widgets/transaction_stepper_modal.dart';
import 'package:ax_dapp/earn/view/earn_simple_tile.dart';
import 'package:ax_dapp/earn/view/provide_liquidity_tile.dart';
import 'package:ax_dapp/earn/view/borrow_stablecoins_tile.dart';

class EarnPage extends StatefulWidget {
  const EarnPage({super.key});

  @override
  State<EarnPage> createState() => _EarnPageState();
}

class _EarnPageState extends State<EarnPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  static const double _headerMaxHeight = 200;
  static const double _headerMinHeight = 90;
  static const double _scrollRange = _headerMaxHeight - _headerMinHeight;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // t: 0.0 = fully expanded, 1.0 = fully collapsed
    final t = (_scrollOffset / _scrollRange).clamp(0.0, 1.0);
    final titleSize = lerpDouble(34, 20, t)!;
    final subtitleOpacity = (1.0 - t * 2.5).clamp(0.0, 1.0);
    final tvlScale = lerpDouble(1.0, 0.8, t)!;
    final topPadding = lerpDouble(24, 16, t)!;
    final headerHeight = lerpDouble(_headerMaxHeight, _headerMinHeight, t)!;

    return BlocListener<AccountBloc, AccountState>(
      listenWhen: (prev, curr) =>
          prev.synthetixAccountId != curr.synthetixAccountId &&
          curr.synthetixAccountId != BigInt.zero,
      listener: (context, accountState) {
        // Push the confirmed account ID into VaultRepository so that
        // deposit / mint / withdraw use the real on-chain account.
        context
            .read<VaultRepository>()
            .updateAccountId(accountState.synthetixAccountId);
      },
      child: Stack(
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            // ── Collapsible Header ──
            AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              height: headerHeight,
              color: Colors.black,
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: topPadding,
                bottom: 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Earn with AthleteX',
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        if (subtitleOpacity > 0) ...[
                          const SizedBox(height: 10),
                          Opacity(
                            opacity: subtitleOpacity,
                            child: Text(
                              'Pick a strategy and move through it in order — '
                              'earn, provide liquidity, or borrow against your assets.',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: Colors.grey[300],
                                fontFamily: 'OpenSans',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Platform TVL
                  Transform.scale(
                    scale: tvlScale,
                    alignment: Alignment.topRight,
                    child: BlocBuilder<EarnPageBloc, EarnPageState>(
                      buildWhen: (previous, current) =>
                          previous.platformTVL != current.platformTVL ||
                          previous.isPlatformTVLLoading !=
                              current.isPlatformTVLLoading,
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900]!.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue[500]!.withOpacity(0.35),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Platform TVL',
                                style: TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 0.2,
                                  color: Colors.grey[400],
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (state.isPlatformTVLLoading)
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.blue[400],
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  '\$${(state.platformTVL / 1e6).toStringAsFixed(2)}M',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue[400],
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // ── Scrollable Tile List ──
            Expanded(
              child: BlocBuilder<EarnPageBloc, EarnPageState>(
                buildWhen: (previous, current) =>
                    previous.expandedTile != current.expandedTile,
                builder: (context, state) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _TileContainer(
                          isExpanded:
                              state.expandedTile == TileType.earnSimple,
                          onTap: () {
                            context.read<EarnPageBloc>().add(
                                  const ExpandTile(TileType.earnSimple),
                                );
                          },
                          title: 'Earn Stablecoins',
                          subtitle:
                              'Deposit and earn yield with a few taps.',
                          icon: Icons.trending_up_rounded,
                          accentColor: Colors.amber[400]!,
                          content:
                              state.expandedTile == TileType.earnSimple
                                  ? const EarnSimpleTile()
                                  : null,
                        ),
                        const SizedBox(height: 18),
                        _TileContainer(
                          isExpanded: state.expandedTile ==
                              TileType.provideLiquidity,
                          onTap: () {
                            context.read<EarnPageBloc>().add(
                                  const ExpandTile(
                                      TileType.provideLiquidity,),
                                );
                          },
                          title: 'Provide Liquidity',
                          subtitle:
                              'Deploy liquidity with leverage and delegate risk.',
                          icon: Icons.water_drop_rounded,
                          accentColor: Colors.blue[400]!,
                          content: state.expandedTile ==
                                  TileType.provideLiquidity
                              ? const ProvideLiquidityTile()
                              : null,
                        ),
                        const SizedBox(height: 18),
                        _TileContainer(
                          isExpanded: state.expandedTile ==
                              TileType.borrowStablecoins,
                          onTap: () {
                            context.read<EarnPageBloc>().add(
                                  const ExpandTile(
                                      TileType.borrowStablecoins,),
                                );
                          },
                          title: 'Borrow Stablecoins',
                          subtitle:
                              'Use vault deposits as collateral to mint axUSD.',
                          icon: Icons.account_balance_wallet_rounded,
                          accentColor: Colors.purple[400]!,
                          content: state.expandedTile ==
                                  TileType.borrowStablecoins
                              ? const BorrowStablecoinsTile()
                              : null,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        // Transaction Modal (overlaid)
        const TransactionStepperModal(),
        // Debug Panel
        _DebugPanel(),
      ],
      ),
    );
  }
}

/// Debug panel showing transaction status and debug info
class _DebugPanel extends StatelessWidget {
  const _DebugPanel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarnPageBloc, EarnPageState>(
      builder: (context, state) {
        // Only show when there's activity
        if (!state.showTransactionModal && 
            state.transactionStatus == TransactionStatus.idle) {
          return const SizedBox.shrink();
        }
        
        return Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getStatusColor(state.transactionStatus),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bug_report,
                      color: _getStatusColor(state.transactionStatus),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'DEBUG PANEL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(state.transactionStatus),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Step: ${state.transactionStep.name}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: ${state.transactionStatus.name}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(state.transactionStatus),
                  ),
                ),
                if (state.transactionError.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Error: ${state.transactionError}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.red,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (state.transactionHash.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Tx Hash: ${state.transactionHash}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.idle:
        return Colors.grey;
      case TransactionStatus.pending:
        return Colors.amber;
      case TransactionStatus.success:
        return Colors.green;
      case TransactionStatus.error:
        return Colors.red;
    }
  }
}

/// Reusable tile container with expansion animation
class _TileContainer extends StatelessWidget {
  const _TileContainer({
    required this.isExpanded,
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.content,
  });

  final bool isExpanded;
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: Colors.grey[900]!.withOpacity(0.6),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isExpanded ? accentColor : Colors.grey[700]!,
            width: isExpanded ? 2 : 1,
          ),
          boxShadow: isExpanded
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: accentColor.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: accentColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expand/Collapse icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: isExpanded ? accentColor : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Expanded content (only show if expanded)
            if (isExpanded && content != null)
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24)
                      .copyWith(bottom: 24),
                  child: content,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
