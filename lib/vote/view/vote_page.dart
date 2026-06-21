import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/vote/bloc/vote_bloc.dart';
import 'package:ax_dapp/vote/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VotePage extends StatelessWidget {
  const VotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteBloc, VoteState>(
      builder: (context, state) {
        if (state.status == VotePageStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: GoldTheme.gold),
          );
        }

        if (state.status == VotePageStatus.error) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: GoldTheme.gold.withOpacity(0.7),
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage.isNotEmpty
                      ? state.errorMessage
                      : 'Something went wrong. Please try again.',
                  style: textStyle(
                    Colors.white70,
                    16,
                    isBold: false,
                    isUline: false,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => context
                      .read<VoteBloc>()
                      .add(const LoadDashboard()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: GoldTheme.goldButton(),
                    child: Text(
                      'Retry',
                      style: textStyle(
                        Colors.black,
                        14,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;
            final horizontalPadding = isDesktop ? 24.0 : 16.0;
            final titleSize = isDesktop ? 24.0 : 20.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Exchange Dashboard',
                    style: textStyle(
                      Colors.white,
                      titleSize,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle
                  Text(
                    'Real-time trading metrics & community governance',
                    style: textStyle(
                      Colors.white54,
                      14,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Header stats
                  const ExchangeHeaderStats(),
                  const SizedBox(height: 24),

                  // Subtle gold divider
                  Container(
                    height: 1,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color.fromRGBO(255, 255, 255, 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sector tab bar
                  const SectorTabBar(),
                  const SizedBox(height: 16),

                  // Volume & OI cards
                  const VolumeOiCards(),
                  const SizedBox(height: 24),

                  // Main content: table + sidebar
                  if (isDesktop)
                    _buildDesktopLayout()
                  else
                    _buildMobileLayout(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 3,
            child: TradingHistoryTable(),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              children: const [
                TopTradersLeaderboard(),
                SizedBox(height: 16),
                MarketProposalSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: const [
        TradingHistoryTable(),
        SizedBox(height: 16),
        TopTradersLeaderboard(),
        SizedBox(height: 16),
        MarketProposalSection(),
      ],
    );
  }
}
