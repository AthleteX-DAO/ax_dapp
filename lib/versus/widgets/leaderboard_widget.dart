import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/versus/models/athlete_elo.dart';
import 'package:ax_dapp/versus/repository/versus_repository.dart';
import 'package:flutter/material.dart';

/// Widget displaying the leaderboard of top athletes by ELO
class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({
    required this.versusRepository,
    required this.marketName,
    this.sport,
    super.key,
  });

  final VersusRepository versusRepository;
  final String marketName;
  final String? sport;

  /// Get the display title based on the market
  String _getLeaderboardTitle() {
    if (marketName == 'Who is the #1 Ranked Rapper?' || sport == 'Music') {
      return 'Top Rappers';
    }
    if (marketName == 'Who is the #1 Ranked Finance Bro?' || sport == 'Finance') {
      return 'Top Finance Bros';
    }
    return 'Top Athletes';
  }

  /// Get the display icon based on the market
  IconData _getLeaderboardIcon() {
    if (marketName == 'Who is the #1 Ranked Rapper?' || sport == 'Music') {
      return Icons.mic;
    }
    if (marketName == 'Who is the #1 Ranked Finance Bro?' || sport == 'Finance') {
      return Icons.attach_money;
    }
    return Icons.sports_basketball;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryOrangeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryOrangeColor.withOpacity(0.2),
                  primaryOrangeColor.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getLeaderboardIcon(),
                  color: primaryOrangeColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  _getLeaderboardTitle(),
                  style: textStyle(
                    Colors.white,
                    20,
                    isBold: true,
                    isUline: false,
                  ),
                ),
              ],
            ),
          ),

          // Column headers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                SizedBox(
                  width: 40,
                  child: Text(
                    'RANK',
                    style: textStyle(
                      greyTextColor,
                      10,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'ATHLETE',
                    style: textStyle(
                      greyTextColor,
                      10,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'ELO',
                    style: textStyle(
                      greyTextColor,
                      10,
                      isBold: true,
                      isUline: false,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    'RECORD',
                    style: textStyle(
                      greyTextColor,
                      10,
                      isBold: true,
                      isUline: false,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    'TOTAL',
                    style: textStyle(
                      greyTextColor,
                      10,
                      isBold: true,
                      isUline: false,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'WIN%',
                    style: textStyle(
                      greyTextColor,
                      10,
                      isBold: true,
                      isUline: false,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          // Leaderboard list
          Expanded(
            child: StreamBuilder<List<AthleteElo>>(
              stream: versusRepository.getLeaderboard(
                marketName: marketName,
                sport: sport,
                limit: 50,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryOrangeColor),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading leaderboard',
                      style: textStyle(
                        Colors.red,
                        14,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  );
                }

                final athletes = snapshot.data ?? [];

                if (athletes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.leaderboard,
                          size: 48,
                          color: greyTextColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No rankings yet',
                          style: textStyle(
                            greyTextColor,
                            14,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: athletes.length,
                  itemBuilder: (context, index) {
                    return _LeaderboardRow(
                      rank: index + 1,
                      athlete: athletes[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatefulWidget {
  const _LeaderboardRow({
    required this.rank,
    required this.athlete,
  });

  final int rank;
  final AthleteElo athlete;

  @override
  State<_LeaderboardRow> createState() => _LeaderboardRowState();
}

class _LeaderboardRowState extends State<_LeaderboardRow> {
  bool _isHovered = false;

  Color _getRankColor() {
    switch (widget.rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return greyTextColor;
    }
  }

  Widget _getRankIcon() {
    if (widget.rank <= 3) {
      return Icon(
        Icons.emoji_events,
        color: _getRankColor(),
        size: 20,
      );
    }
    return Text(
      '${widget.rank}',
      style: textStyle(
        greyTextColor,
        14,
        isBold: true,
        isUline: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to Battle tab and load matchup with this athlete
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.athlete.athleteName} clicked! Feature coming soon.'),
              duration: const Duration(seconds: 2),
              backgroundColor: primaryOrangeColor,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.rank <= 3
                ? _getRankColor().withOpacity(_isHovered ? 0.12 : 0.05)
                : _isHovered
                    ? Colors.white.withOpacity(0.05)
                    : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: _getRankIcon(),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.athlete.athleteName,
                      style: textStyle(
                        _isHovered ? primaryOrangeColor : Colors.white,
                        14,
                        isBold: widget.rank <= 3 || _isHovered,
                        isUline: false,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.athlete.team,
                      style: textStyle(
                        greyTextColor,
                        11,
                        isBold: false,
                        isUline: false,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  widget.athlete.elo.toStringAsFixed(0),
                  style: textStyle(
                    primaryOrangeColor,
                    14,
                    isBold: true,
                    isUline: false,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 70,
                child: Text(
                  widget.athlete.record,
                  style: textStyle(
                    Colors.white,
                    12,
                    isBold: false,
                    isUline: false,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  '${widget.athlete.totalBattles}',
                  style: textStyle(
                    Colors.white70,
                    12,
                    isBold: false,
                    isUline: false,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  '${widget.athlete.winRate.toStringAsFixed(1)}%',
                  style: textStyle(
                    widget.athlete.winRate >= 50 ? primaryGreenColor : primaryRedColor,
                    12,
                    isBold: false,
                    isUline: false,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
