import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/versus/models/versus_match_model.dart';
import 'package:ax_dapp/versus/widgets/athlete_battle_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Layout for displaying the versus battle with two athletes and VS logo
class VersusBattleLayout extends StatefulWidget {
  const VersusBattleLayout({
    required this.match,
    required this.onVoteAthlete1,
    required this.onVoteAthlete2,
    this.lastVoteWinnerId,
    this.onSwipeUpMarket,
    this.onSwipeDownMarket,
    super.key,
  });

  final VersusMatchModel match;
  final VoidCallback onVoteAthlete1;
  final VoidCallback onVoteAthlete2;
  final int? lastVoteWinnerId;
  /// Called when the user swipes up on the VS center page (mobile only) — cycles forward.
  final VoidCallback? onSwipeUpMarket;
  /// Called when the user swipes down on the VS center page (mobile only) — cycles backward.
  final VoidCallback? onSwipeDownMarket;

  @override
  State<VersusBattleLayout> createState() => _VersusBattleLayoutState();
}

class _VersusBattleLayoutState extends State<VersusBattleLayout>
    with TickerProviderStateMixin {
  double _dragOffset = 0;
  bool _isDragging = false;
  DateTime _lastMarketCycleTime = DateTime.fromMillisecondsSinceEpoch(0);
  static const Duration _marketCycleCooldown = Duration(milliseconds: 1200);

  late final AnimationController _hintController;
  late final Animation<double> _hintOffset;

  @override
  void initState() {
    super.initState();
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _hintOffset = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
  }

  /// Check if enough time has passed to allow another market cycle.
  bool _canCycleMarket() {
    final now = DateTime.now();
    if (now.difference(_lastMarketCycleTime) >= _marketCycleCooldown) {
      _lastMarketCycleTime = now;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dx;
          _isDragging = true;
        });
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond.dx;
        
        // Swipe right (vote for athlete 1)
        if (velocity > 500 || _dragOffset > 100) {
          widget.onVoteAthlete1();
        }
        // Swipe left (vote for athlete 2)
        else if (velocity < -500 || _dragOffset < -100) {
          widget.onVoteAthlete2();
        }

        setState(() {
          _dragOffset = 0;
          _isDragging = false;
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Main content
              Column(
                children: [
                  // Market name header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.match.marketName,
                      style: textStyle(
                        primaryOrangeColor,
                        24,
                        isBold: true,
                        isUline: false,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    child: isSmallScreen
                        ? _buildMobileLayout()
                        : _buildDesktopLayout(constraints),
                  ),
                ],
              ),

              // VS logo overlay (centered)
              if (!isSmallScreen)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.black,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                      border: Border.all(
                        color: primaryOrangeColor,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryOrangeColor.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      'VS',
                      style: textStyle(
                        primaryOrangeColor,
                        32,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BoxConstraints constraints) {
    final isSwipingLeft = _isDragging && _dragOffset < 0;
    final isSwipingRight = _isDragging && _dragOffset > 0;

    return Row(
      children: [
        // Athlete 1
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AthleteBattleCard(
              athlete: widget.match.athlete1,
              onTap: () {
                context.read<TrackingCubit>().trackVersusVoteCast(
                      athleteName: widget.match.athlete1.athleteName,
                      marketName: widget.match.marketName,
                      walletId: '',
                    );
                widget.onVoteAthlete1();
              },
              isSwipingRight: isSwipingRight,
            ),
          ),
        ),

        const SizedBox(width: 100), // Space for VS logo

        // Athlete 2
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AthleteBattleCard(
              athlete: widget.match.athlete2,
              onTap: () {
                context.read<TrackingCubit>().trackVersusVoteCast(
                      athleteName: widget.match.athlete2.athleteName,
                      marketName: widget.match.marketName,
                      walletId: '',
                    );
                widget.onVoteAthlete2();
              },
              isSwipingLeft: isSwipingLeft,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return PageView(
      children: [
        // Athlete 1
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: AthleteBattleCard(
                  athlete: widget.match.athlete1,
                  onTap: () {
                    context.read<TrackingCubit>().trackVersusVoteCast(
                          athleteName: widget.match.athlete1.athleteName,
                          marketName: widget.match.marketName,
                          walletId: '',
                        );
                    widget.onVoteAthlete1();
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Swipe for next athlete →',
                style: textStyle(
                  greyTextColor,
                  12,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ],
          ),
        ),

        // VS Divider
        Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent && _canCycleMarket()) {
              final scrollDelta = event.scrollDelta.dy;
              if (scrollDelta < -25) {
                // Scroll up → forward cycle
                widget.onSwipeUpMarket?.call();
              } else if (scrollDelta > 25) {
                // Scroll down → backward cycle
                widget.onSwipeDownMarket?.call();
              }
            }
          },
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (_canCycleMarket()) {
                final dy = details.velocity.pixelsPerSecond.dy;
                if (dy < -150) {
                  widget.onSwipeUpMarket?.call();
                } else if (dy > 150) {
                  widget.onSwipeDownMarket?.call();
                }
              }
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Swipe-up hint arrow
                  if (widget.onSwipeUpMarket != null)
                    AnimatedBuilder(
                      animation: _hintOffset,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _hintOffset.value),
                        child: child,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: Colors.white24,
                        size: 22,
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryOrangeColor.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      'VS',
                      style: textStyle(
                        primaryOrangeColor,
                        64,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                  ),
                  if (widget.onSwipeUpMarket != null || widget.onSwipeDownMarket != null) ...
                    [
                      // Swipe-down hint arrow
                      AnimatedBuilder(
                        animation: _hintOffset,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0, -_hintOffset.value),
                          child: child,
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white24,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'swipe or scroll to switch category',
                        style: TextStyle(
                          color: Colors.white24,
                          fontSize: 11,
                          fontFamily: 'OpenSans',
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                ],
              ),
            ),
          ),
        ),

        // Athlete 2
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: AthleteBattleCard(
                  athlete: widget.match.athlete2,
                  onTap: () {
                    context.read<TrackingCubit>().trackVersusVoteCast(
                          athleteName: widget.match.athlete2.athleteName,
                          marketName: widget.match.marketName,
                          walletId: '',
                        );
                    widget.onVoteAthlete2();
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '← Swipe back to compare',
                style: textStyle(
                  greyTextColor,
                  12,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
