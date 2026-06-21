import 'package:flutter/material.dart';

/// Pulsing red "LIVE" badge for livestream cards.
class LiveBadge extends StatefulWidget {
  const LiveBadge({super.key, this.size = LiveBadgeSize.normal});

  final LiveBadgeSize size;

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

enum LiveBadgeSize { small, normal }

class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.6, end: 1.0).animate(
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
    final isSmall = widget.size == LiveBadgeSize.small;
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 6 : 8,
            vertical: isSmall ? 2 : 4,
          ),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(_opacity.value * 0.85),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(_opacity.value * 0.4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isSmall ? 5 : 6,
                height: isSmall ? 5 : 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: isSmall ? 3 : 4),
              Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: isSmall ? 9 : 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
