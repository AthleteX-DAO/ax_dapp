import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class PredictionGridPlaceholder extends StatelessWidget {
  const PredictionGridPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    const totalCards = 20; // 5 rows x 4 columns
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCards,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            return _PredictionPlaceholderCard(index: index + 1);
          },
        );
      },
    );
  }
}

class _PredictionPlaceholderCard extends StatelessWidget {
  const _PredictionPlaceholderCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondaryOrangeColor.withOpacity(0.8),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: const Icon(
                  Icons.sports_esports,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz,
                color: Colors.white.withOpacity(0.7),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Prediction placeholder #$index',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textStyle(
              Colors.white,
              14,
              isBold: true,
              isUline: false,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Market copy to be added here.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textStyle(
              Colors.white70,
              12,
              isBold: false,
              isUline: false,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _pill('Yes TBD'),
              const SizedBox(width: 6),
              _pill('No TBD'),
              const Spacer(),
              Icon(
                Icons.bar_chart,
                color: Colors.white.withOpacity(0.7),
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _pill(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.06),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white24, width: 1),
    ),
    child: Text(
      text,
      style: textStyle(
        Colors.white,
        11,
        isBold: false,
        isUline: false,
      ),
    ),
  );
}
