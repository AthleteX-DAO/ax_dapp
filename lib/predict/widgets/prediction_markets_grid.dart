import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/responsive_constants.dart';
import 'package:flutter/material.dart';

class PredictionMarketsGrid extends StatelessWidget {
  const PredictionMarketsGrid({
    required this.predictions,
    super.key,
  });

  final List<PredictionModel> predictions;

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: predictions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            return ResponsivePredictionCard(
              prediction: predictions[index],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white.withOpacity(0.5),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No prediction markets available',
              style: textStyle(
                Colors.white70,
                16,
                isBold: false,
                isUline: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sliver-based grid for improved performance within CustomScrollView
class PredictionMarketsSliverGrid extends StatelessWidget {
  const PredictionMarketsSliverGrid({
    required this.predictions,
    super.key,
  });

  final List<PredictionModel> predictions;

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptySliverState());
    }

    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = ResponsiveConstants.getGridCrossAxisCount(width);

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => ResponsivePredictionCard(
          prediction: predictions[index],
        ),
        childCount: predictions.length,
      ),
    );
  }

  Widget _buildEmptySliverState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white.withOpacity(0.5),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No prediction markets available',
              style: textStyle(
                Colors.white70,
                16,
                isBold: false,
                isUline: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
