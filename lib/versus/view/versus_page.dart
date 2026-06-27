import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/versus/bloc/versus_bloc.dart';
import 'package:ax_dapp/versus/repository/versus_repository.dart';
import 'package:ax_dapp/versus/widgets/leaderboard_widget.dart';
import 'package:ax_dapp/versus/widgets/versus_battle_layout.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main page for Versus voting markets
class VersusPage extends StatelessWidget {
  const VersusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VersusBloc(
        versusRepository: context.read<VersusRepository>(),
      )..add(
          const LoadMatchupRequested(
            marketName: 'Who is the #1 Ranked Athlete?',
          ),
        ),
      child: const VersusView(),
    );
  }
}

class VersusView extends StatefulWidget {
  const VersusView({super.key});

  @override
  State<VersusView> createState() => _VersusViewState();
}

class _VersusViewState extends State<VersusView> {
  int _selectedTab = 0; // 0 = Battle, 1 = Leaderboard
  String _selectedMarket = 'Who is the #1 Ranked Athlete?';
  /// True while a market cycle request is in-flight; blocks duplicate calls.
  bool _isCycling = false;

  static const List<_MarketOption> _markets = [
    _MarketOption(
      name: 'Who is the #1 Ranked Athlete?',
      label: 'Athletes',
      icon: Icons.sports_basketball,
      sport: null,
    ),
    _MarketOption(
      name: 'Who is the #1 Ranked Rapper?',
      label: 'Rappers',
      icon: Icons.mic,
      sport: 'Music',
    ),
    _MarketOption(
      name: 'Who is the #1 Ranked Finance Bro?',
      label: 'Finance Bros',
      icon: Icons.attach_money,
      sport: 'Finance',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;

    return Scaffold(
      backgroundColor: Colors.black,
      body: MultiBlocListener(
        listeners: [
          BlocListener<VersusBloc, VersusState>(
            // Only fires when a user-initiated market cycle completes or fails.
            listenWhen: (prev, next) =>
                _isCycling &&
                (next.status == VersusStatus.loaded ||
                 next.status == VersusStatus.error),
            listener: (context, state) => setState(() {
              _isCycling = false;
              // Snap back to Battle so the new matchup is immediately visible.
              if (!isDesktop) _selectedTab = 0;
            }),
          ),
          BlocListener<VersusBloc, VersusState>(
            listenWhen: (prev, next) =>
                prev.status != next.status &&
                next.status == VersusStatus.loaded &&
                next.currentMatch != null,
            listener: (context, state) {
              context.read<TrackingCubit>().trackVersusMatchView(
                    marketName: state.currentMatch!.marketName,
                    walletId: '',
                  );
            },
          ),
        ],
        child: isDesktop
            ? _buildDesktopLayout()
            : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Battle area (60%)
        Expanded(
          flex: 60,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildDesktopMarketCycler(),
                Expanded(child: _buildBattleArea()),
              ],
            ),
          ),
        ),

        // Right sidebar (40%) — leaderboard always visible
        Expanded(
          flex: 40,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LeaderboardWidget(
                versusRepository: context.read<VersusRepository>(),
                marketName: _selectedMarket,
                sport: _selectedMarket == 'Who is the #1 Ranked Rapper?'
                    ? 'Music'
                    : _selectedMarket == 'Who is the #1 Ranked Finance Bro?'
                    ? 'Finance'
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final sport = _selectedMarket == 'Who is the #1 Ranked Rapper?'
        ? 'Music'
        : _selectedMarket == 'Who is the #1 Ranked Finance Bro?'
        ? 'Finance'
        : null;

    return Column(
      children: [
        _buildTabSelector(),
        Expanded(
          // IndexedStack keeps both tabs mounted — the leaderboard Firestore
          // stream stays open and switching tabs is instant with no reload.
          child: IndexedStack(
            index: _selectedTab,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildBattleArea(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: LeaderboardWidget(
                  key: ValueKey(_selectedMarket),
                  versusRepository: context.read<VersusRepository>(),
                  marketName: _selectedMarket,
                  sport: sport,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Battle area — shows spinner/error during market switches; leaderboard stays live.
  Widget _buildBattleArea() {
    return BlocBuilder<VersusBloc, VersusState>(
      builder: (context, state) {
        if (state.status == VersusStatus.loading ||
            state.status == VersusStatus.initial) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryOrangeColor),
            ),
          );
        }
        if (state.status == VersusStatus.error) {
          return _buildErrorView(state);
        }
        if (state.currentMatch == null) {
          return const Center(
            child: Text(
              'No matchup available',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: VersusBattleLayout(
                match: state.currentMatch!,
                lastVoteWinnerId: state.lastVoteWinnerId,
                onSwipeUpMarket: _onSwipeUpMarket,
                onSwipeDownMarket: _onSwipeDownMarket,
                onVoteAthlete1: () => _submitVote(
                  winnerId: state.currentMatch!.athlete1.athleteId,
                  loserId: state.currentMatch!.athlete2.athleteId,
                ),
                onVoteAthlete2: () => _submitVote(
                  winnerId: state.currentMatch!.athlete2.athleteId,
                  loserId: state.currentMatch!.athlete1.athleteId,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorView(VersusState state) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, size: 64, color: primaryOrangeColor),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  Text(
                    'Unable to Load Battle',
                    style: textStyle(Colors.white, 18, isBold: true, isUline: false),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.errorMessage ?? 'An error occurred. Make sure athletes are initialized in Firestore.',
                    style: textStyle(greyTextColor, 14, isBold: false, isUline: false),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final market = _markets.firstWhere(
                  (m) => m.name == _selectedMarket,
                  orElse: () => _markets.first,
                );
                context.read<VersusBloc>().add(
                      LoadMatchupRequested(
                        marketName: market.name,
                        sport: market.sport,
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrangeColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                'Retry',
                style: textStyle(Colors.black, 14, isBold: true, isUline: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Desktop top-right cycling icon — shows the current market icon.
  /// Each tap rotates to the next market (basketball → mic → dollar → …).
  Widget _buildDesktopMarketCycler() {
    final currentMarket = _markets.firstWhere(
      (m) => m.name == _selectedMarket,
      orElse: () => _markets.first,
    );
    final nextIndex =
        (_markets.indexOf(currentMarket) + 1) % _markets.length;
    final nextMarket = _markets[nextIndex];
    return Tooltip(
      message: 'Switch to ${nextMarket.label}',
      preferBelow: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: _cycleToNextMarket,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
                child: child,
              ),
              child: Icon(
                currentMarket.icon,
                key: ValueKey(currentMarket.name),
                color: primaryOrangeColor,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _selectedTab = 0),
                child: _buildTabContent('Battle', Icons.sports_mma, 0),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _selectedTab = 1),
                child: _buildTabContent('Leaderboard', Icons.emoji_events, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String label, IconData icon, int index) {
    final isSelected = _selectedTab == index;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? primaryOrangeColor : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? primaryOrangeColor : greyTextColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: textStyle(
              isSelected ? primaryOrangeColor : greyTextColor,
              14,
              isBold: isSelected,
              isUline: false,
            ),
          ),
        ],
      ),
    );
  }

  /// Core market rotation — cycles forward or backward in circular order.
  /// Guarded by [_isCycling] so rapid taps/swipes only ever fire one request.
  void _cycleToNextMarket({bool forward = true}) {
    if (_isCycling) return;
    final currentIndex = _markets.indexWhere((m) => m.name == _selectedMarket);
    final nextIndex = forward
        ? (currentIndex + 1) % _markets.length
        : (currentIndex - 1 + _markets.length) % _markets.length;
    final nextMarket = _markets[nextIndex];
    setState(() {
      _isCycling = true;
      _selectedMarket = nextMarket.name;
    });
    context.read<VersusBloc>().add(
          LoadMatchupRequested(
            marketName: nextMarket.name,
            sport: nextMarket.sport,
          ),
        );
  }

  void _onSwipeUpMarket() => _cycleToNextMarket(forward: true);
  void _onSwipeDownMarket() => _cycleToNextMarket(forward: false);

  void _submitVote({
    required int winnerId,
    required int loserId,
  }) {
    final walletAddress =
        context.read<WalletBloc>().state.formattedWalletAddress;

    // Voting is open to everyone — wallet not required
    context.read<VersusBloc>().add(
          VoteSubmitted(
            walletAddress: walletAddress,
            winnerId: winnerId,
            loserId: loserId,
          ),
        );
  }

}
/// Immutable market configuration used by the market chip selector.
class _MarketOption {
  const _MarketOption({
    required this.name,
    required this.label,
    required this.icon,
    required this.sport,
  });

  final String name;
  final String label;
  final IconData icon;
  final String? sport;
}
