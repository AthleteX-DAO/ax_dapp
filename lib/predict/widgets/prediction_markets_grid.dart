import 'package:ax_dapp/predict/livestream/livestream_model.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/predict/widgets/livestream_grid_card.dart';
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
            childAspectRatio: 2.45,
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

/// Sliver-based grid for improved performance within CustomScrollView.
/// Interleaves [LiveStreamGridCard] at positions 3 and 5 within every group
/// of 5 items (2-of-5 ratio).
class PredictionMarketsSliverGrid extends StatelessWidget {
  const PredictionMarketsSliverGrid({
    required this.predictions,
    this.streams = const [],
    super.key,
  });

  final List<PredictionModel> predictions;
  final List<LiveStreamModel> streams;

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty && streams.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptySliverState());
    }

    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = ResponsiveConstants.getGridCrossAxisCount(width);

    // Build merged item list: for every 5 slots, 3 predictions + 2 streams
    final mergedItems = _buildMergedItems();

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.18,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = mergedItems[index];
          if (item is LiveStreamModel) {
            return LiveStreamGridCard(stream: item);
          }
          return ResponsivePredictionCard(
            prediction: item as PredictionModel,
          );
        },
        childCount: mergedItems.length,
      ),
    );
  }

  /// Interleaves streams at positions 2 and 4 within every group of 5.
  /// Pattern: [pred, pred, STREAM, pred, STREAM, pred, pred, STREAM, ...]
  List<Object> _buildMergedItems() {
    if (streams.isEmpty) return predictions;

    final items = <Object>[];
    var predIdx = 0;
    var streamIdx = 0;

    while (predIdx < predictions.length) {
      final posInGroup = items.length % 5;

      if ((posInGroup == 2 || posInGroup == 4) && streamIdx < streams.length) {
        // Insert a stream card
        items.add(streams[streamIdx]);
        streamIdx++;
      } else {
        // Insert a prediction card
        items.add(predictions[predIdx]);
        predIdx++;
      }
    }

    return items;
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
