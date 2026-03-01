import 'dart:async';

import 'package:ax_dapp/predict/bloc/hero_carousel_bloc.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  int _currentPage = 0;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    // Load top markets when widget initializes
    context.read<HeroCarouselBloc>().add(const HeroCarouselLoadRequested());
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
      final itemCount = _pageController.positions.isNotEmpty ? 4 : 0;
      if (itemCount == 0) return;
      final next = (_currentPage + 1) % itemCount;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeroCarouselBloc, HeroCarouselState>(
      builder: (context, state) {
        if (state.status == HeroCarouselStatus.loading) {
          return _buildLoadingState();
        }

        if (state.status == HeroCarouselStatus.error) {
          return _buildErrorState(state.errorMessage);
        }

        if (state.topMarkets.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: state.topMarkets.length,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        final market = state.topMarkets[index];
                        context.goNamed(
                          'prediction',
                          pathParameters: {
                            'id': market.id.toString() + market.prompt,
                          },
                          extra: market,
                        );
                      },
                      child: _HeroCard(prediction: state.topMarkets[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _DotsIndicator(
              count: state.topMarkets.length,
              activeIndex: _currentPage,
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading top markets...',
          style: textStyle(
            Colors.white70,
            14,
            isBold: false,
            isUline: false,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: Colors.red.shade300,
          size: 48,
        ),
        const SizedBox(height: 12),
        Text(
          'Unable to load markets',
          style: textStyle(
            Colors.white70,
            14,
            isBold: false,
            isUline: false,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.inbox_outlined,
          color: Colors.white30,
          size: 48,
        ),
        const SizedBox(height: 12),
        Text(
          'No markets available',
          style: textStyle(
            Colors.white70,
            14,
            isBold: false,
            isUline: false,
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.prediction});

  final PredictionModel prediction;

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
    final colorIndex = prediction.prompt.hashCode % _colorPalette.length;
    final primaryColor = _colorPalette[colorIndex];
    final secondaryColor =
        _colorPalette[(colorIndex + 1) % _colorPalette.length];
    final icon = _iconPalette[colorIndex];
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;
    final cardPadding = isMobile ? 16.0 : 28.0;
    final iconSize = isMobile ? 52.0 : 80.0;
    final iconInnerSize = isMobile ? 26.0 : 40.0;
    final titleFontSize = isMobile ? 16.0 : 20.0;

    // Get leading option (YES if >= 50%, else NO)
    final leadingPercentage = prediction.longTokenPercentage ?? 50;
    final leadingLabel = leadingPercentage >= 50 ? 'Yes' : 'No';
    final leadingPrice =
        leadingPercentage >= 50 ? prediction.longTokenPrice : prediction.shortTokenPrice;
    final priceStr =
        leadingPrice != null ? '\$${leadingPrice.toStringAsFixed(2)}' : 'TBD';

    return Container(
      padding: EdgeInsets.all(cardPadding),
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
            children: [
              // Icon
              Container(
                height: iconSize,
                width: iconSize,
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
                  size: iconInnerSize,
                ),
              ),
              SizedBox(width: isMobile ? 14 : 28),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Top Market',
                      style: textStyle(
                        Colors.white70,
                        13,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      prediction.prompt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle(
                        Colors.white,
                        titleFontSize,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                    SizedBox(height: isMobile ? 6 : 14),
                    Text(
                      'Vol: \$${(prediction.tradingVolume / 1e6).toStringAsFixed(1)}M',
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
          if (!isMobile) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _FeatureBadge(icon: Icons.flash_on, label: 'Live'),
                    const SizedBox(width: 12),
                    _FeatureBadge(
                      icon: Icons.trending_up,
                      label: 'Leading: $leadingLabel',
                    ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        priceStr,
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
        ],
      ),
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
    final secondaryColor =
        _colorPalette[(colorIndex + 1) % _colorPalette.length];
    final icon = _iconPalette[colorIndex];
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;
    final cardPadding = isMobile ? 16.0 : 28.0;
    final iconSize = isMobile ? 52.0 : 80.0;
    final iconInnerSize = isMobile ? 26.0 : 40.0;
    final titleFontSize = isMobile ? 16.0 : 20.0;

    return Container(
      padding: EdgeInsets.all(cardPadding),
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
            children: [
              // Icon
              Container(
                height: iconSize,
                width: iconSize,
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
                  size: iconInnerSize,
                ),
              ),
              SizedBox(width: isMobile ? 14 : 28),
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
                        titleFontSize,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                    SizedBox(height: isMobile ? 6 : 14),
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
          if (!isMobile) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    _FeatureBadge(icon: Icons.flash_on, label: 'Live data'),
                    SizedBox(width: 12),
                    _FeatureBadge(
                      icon: Icons.trending_up,
                      label: 'Market driven',
                    ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
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
        border: Border.all(color: Colors.white.withOpacity(0.2)),
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
