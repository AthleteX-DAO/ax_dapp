import 'dart:async';

import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PredictionHeroCarouselPlaceholder extends StatefulWidget {
  const PredictionHeroCarouselPlaceholder({super.key});

  @override
  State<PredictionHeroCarouselPlaceholder> createState() =>
      _PredictionHeroCarouselPlaceholderState();
}

class _PredictionHeroCarouselPlaceholderState
    extends State<PredictionHeroCarouselPlaceholder> {
  final _pageController = PageController(viewportFraction: 0.9);
  final _items = const [
    'Featured Market Placeholder',
    'Trending Prediction Placeholder',
    'New Market Placeholder',
    'Top Volume Placeholder',
  ];
  int _currentPage = 0;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_pageController.hasClients) return;
      final next = (_currentPage + 1) % _items.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to a prediction when tapping hero card
                        final predictions = Global().predictions;
                        if (predictions.isNotEmpty) {
                          final target = predictions[index % predictions.length];
                          context.goNamed(
                            'prediction',
                            pathParameters: {
                              'id': target.id.toString() + target.prompt,
                            },
                            extra: target,
                          );
                        }
                      },
                      child: _HeroCardPlaceholder(title: _items[index]),
                    ),
                  );
            },
          ),
        ),
        const SizedBox(height: 12),
        _DotsIndicator(count: _items.length, activeIndex: _currentPage),
      ],
    );
  }
}

class _HeroCardPlaceholder extends StatelessWidget {
  const _HeroCardPlaceholder({required this.title});

  final String title;

  static const List<Color> _colorPalette = [
    Color(0xFFFF6B35),
    Color(0xFF9D4EDD),
    Color(0xFF004E89),
    Color(0xFF8B4513),
  ];

  static const List<IconData> _iconPalette = [
    Icons.sports_football,
    Icons.sports_basketball,
    Icons.sports_soccer,
    Icons.sports_hockey,
  ];

  @override
  Widget build(BuildContext context) {
    final colorIndex = title.hashCode % _colorPalette.length;
    final primaryColor = _colorPalette[colorIndex];
    final secondaryColor = _colorPalette[(colorIndex + 1) % _colorPalette.length];
    final icon = _iconPalette[colorIndex];

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.95),
            secondaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(width: 28),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Featured Market',
                      style: textStyle(
                        Colors.white70,
                        13,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle(
                        Colors.white,
                        20,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Coming soon: curated AthleteX prediction markets',
                      style: textStyle(
                        Colors.white.withOpacity(0.85),
                        12,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _FeatureBadge(icon: Icons.flash_on, label: 'Live data'),
                  const SizedBox(width: 12),
                  _FeatureBadge(icon: Icons.trending_up, label: 'Market driven'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Price',
                    style: textStyle(
                      Colors.white70,
                      11,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'TBD',
                      style: textStyle(
                        Colors.white,
                        13,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 8,
          width: isActive ? 18 : 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.amber[400] : Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: textStyle(
              Colors.white,
              11,
              isBold: false,
              isUline: false,
            ),
          ),
        ],
      ),
    );
  }
}
