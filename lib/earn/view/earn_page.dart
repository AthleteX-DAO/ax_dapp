import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/earn_page_bloc.dart';
import '../widgets/transaction_stepper_modal.dart';
import 'earn_simple_tile.dart';
import 'provide_liquidity_tile.dart';
import 'borrow_stablecoins_tile.dart';

class EarnPage extends StatelessWidget {
  const EarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with title and TVL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Earn with AthleteX',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Pick a strategy and move through it in order — earn, provide liquidity, or borrow against your assets.',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: Colors.grey[300],
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Platform TVL Card
                      BlocBuilder<EarnPageBloc, EarnPageState>(
                        buildWhen: (previous, current) =>
                            previous.platformTVL != current.platformTVL ||
                            previous.isPlatformTVLLoading !=
                                current.isPlatformTVLLoading,
                        builder: (context, state) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[900]!.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blue[500]!.withOpacity(0.35),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Platform TVL',
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 0.2,
                                    color: Colors.grey[400],
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (state.isPlatformTVLLoading)
                                  SizedBox(
                                    width: 140,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                              Colors.blue[400],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Loading...',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue[400],
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Text(
                                    '\$${(state.platformTVL / 1e6).toStringAsFixed(2)}M',
                                    style: TextStyle(
                                      fontSize: 22,
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
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Tiles container (responsive, vertical stack)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final screenWidth = constraints.maxWidth;
                        return BlocBuilder<EarnPageBloc, EarnPageState>(
                          buildWhen: (previous, current) =>
                              previous.expandedTile != current.expandedTile,
                          builder: (context, state) {
                            final tiles = [
                              _TileContainer(
                                isExpanded:
                                    state.expandedTile == TileType.earnSimple,
                                onTap: () {
                                  context.read<EarnPageBloc>().add(
                                        const ExpandTile(TileType.earnSimple),
                                      );
                                },
                                title: 'Earn Stablecoins',
                                subtitle: 'Deposit and earn yield with a few taps.',
                                icon: Icons.trending_up_rounded,
                                accentColor: Colors.amber[400]!,
                                content:
                                    state.expandedTile == TileType.earnSimple
                                        ? const EarnSimpleTile()
                                        : null,
                              ),
                              _TileContainer(
                                isExpanded: state.expandedTile ==
                                    TileType.provideLiquidity,
                                onTap: () {
                                  context.read<EarnPageBloc>().add(
                                        const ExpandTile(
                                            TileType.provideLiquidity),
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
                              _TileContainer(
                                isExpanded: state.expandedTile ==
                                    TileType.borrowStablecoins,
                                onTap: () {
                                  context.read<EarnPageBloc>().add(
                                        const ExpandTile(
                                            TileType.borrowStablecoins),
                                      );
                                },
                                title: 'Borrow Stablecoins',
                                subtitle: 'Use vault deposits as collateral to mint sUSD.',
                                icon: Icons.account_balance_wallet_rounded,
                                accentColor: Colors.purple[400]!,
                                content: state.expandedTile ==
                                        TileType.borrowStablecoins
                                    ? const BorrowStablecoinsTile()
                                    : null,
                              ),
                            ];

                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: screenWidth,
                                    minWidth: screenWidth,
                                  ),
                                  child: tiles[index],
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 18),
                              itemCount: tiles.length,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Transaction Modal (overlaid)
        const TransactionStepperModal(),
      ],
    );
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
            // Expanded content with scrolling (only show if expanded)
            if (isExpanded && content != null)
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24)
                      .copyWith(bottom: 24),
                  child: content!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
