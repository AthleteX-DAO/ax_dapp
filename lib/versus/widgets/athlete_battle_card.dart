import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/versus/models/athlete_elo.dart';
import 'package:ax_dapp/versus/services/athlete_image_service.dart';
import 'package:flutter/material.dart';

/// Premium card for displaying an athlete in a versus battle
class AthleteBattleCard extends StatefulWidget {
  const AthleteBattleCard({
    required this.athlete,
    required this.onTap,
    this.isSwipingLeft = false,
    this.isSwipingRight = false,
    super.key,
  });

  final AthleteElo athlete;
  final VoidCallback onTap;
  final bool isSwipingLeft;
  final bool isSwipingRight;

  @override
  State<AthleteBattleCard> createState() => _AthleteBattleCardState();
}

class _AthleteBattleCardState extends State<AthleteBattleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.isSwipingLeft || widget.isSwipingRight;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) {
            _controller.reverse();
            widget.onTap();
          },
          onTapCancel: () => _controller.reverse(),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isHighlighted
                      ? [
                          primaryOrangeColor.withOpacity(0.3),
                          primaryOrangeColor.withOpacity(0.15),
                        ]
                      : [
                          Colors.white.withOpacity(_isHovered ? 0.12 : 0.08),
                          Colors.white.withOpacity(_isHovered ? 0.06 : 0.04),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isHighlighted
                      ? primaryOrangeColor.withOpacity(0.8)
                      : primaryOrangeColor.withOpacity(_isHovered ? 0.7 : 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isHighlighted
                        ? primaryOrangeColor.withOpacity(0.4)
                        : primaryOrangeColor.withOpacity(_isHovered ? 0.45 : 0.2),
                    blurRadius: isHighlighted ? 30 : (_isHovered ? 40 : 20),
                    spreadRadius: _isHovered ? 2 : 0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
              children: [
                // Background gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Athlete image
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryOrangeColor.withOpacity(0.6),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryOrangeColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: AthleteImageService.athleteImage(
                            athleteId: widget.athlete.athleteId,
                            athleteName: widget.athlete.athleteName,
                            sport: widget.athlete.sport,
                            team: widget.athlete.team,
                            size: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Athlete name
                      Text(
                        widget.athlete.athleteName,
                        style: textStyle(
                          Colors.white,
                          20,
                          isBold: true,
                          isUline: false,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Team
                      Text(
                        widget.athlete.team,
                        style: textStyle(
                          greyTextColor,
                          14,
                          isBold: false,
                          isUline: false,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(
                            label: 'ELO',
                            value: widget.athlete.elo.toStringAsFixed(0),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          _StatItem(
                            label: 'RECORD',
                            value: widget.athlete.record,
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          _StatItem(
                            label: 'WIN%',
                            value: '${widget.athlete.winRate.toStringAsFixed(1)}%',
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Vote button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 32,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryOrangeColor,
                              primaryOrangeColor.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: primaryOrangeColor.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          'CLICK TO VOTE',
                          style: textStyle(
                            Colors.black,
                            14,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),         // Stack
              ),       // ClipRRect
            ),         // AnimatedContainer (decoration)
          ),           // ScaleTransition
        ),             // GestureDetector
      ),               // AnimatedContainer (translate)
    );                 // MouseRegion
  }
}

/// Stat item widget for displaying athlete statistics
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: textStyle(
            primaryOrangeColor,
            18,
            isBold: true,
            isUline: false,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textStyle(
            greyTextColor,
            10,
            isBold: false,
            isUline: false,
          ),
        ),
      ],
    );
  }
}
