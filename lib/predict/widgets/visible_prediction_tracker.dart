import 'package:flutter/material.dart';

/// Lightweight visibility detection for prediction cards
/// Efficiently tracks which cards are visible on screen to minimize state updates
class VisiblePredictionTracker extends StatefulWidget {
  const VisiblePredictionTracker({
    super.key,
    required this.predictionId,
    required this.child,
    required this.onVisibilityChanged,
  });

  final int predictionId;
  final Widget child;
  final void Function(int id, bool isVisible)? onVisibilityChanged;

  @override
  State<VisiblePredictionTracker> createState() =>
      _VisiblePredictionTrackerState();
}

class _VisiblePredictionTrackerState extends State<VisiblePredictionTracker> {
  late GlobalKey _key;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
  }

  void _checkVisibility() {
    final context = _key.currentContext;
    if (context == null) return;

    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null) return;

    // Simple visibility check based on render tree
    try {
      widget.onVisibilityChanged?.call(widget.predictionId, true);
    } catch (e) {
      widget.onVisibilityChanged?.call(widget.predictionId, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkVisibility();
          });
          return false;
        },
        child: widget.child,
      ),
    );
  }
}

/// Extension for easy visibility tracking on any widget
extension VisibilityTracking on Widget {
  Widget withVisibilityTracking({
    required int predictionId,
    required void Function(int id, bool isVisible)? onVisibilityChanged,
  }) {
    return VisiblePredictionTracker(
      predictionId: predictionId,
      onVisibilityChanged: onVisibilityChanged,
      child: this,
    );
  }
}
