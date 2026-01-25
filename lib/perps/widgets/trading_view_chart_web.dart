// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';
// Use web-specific ui registry (consistent with existing web code)
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

/// Web implementation using TradingView iframe embed with theme sync,
/// responsive height, and error fallback.
class TradingViewChart extends StatefulWidget {
  const TradingViewChart({
    super.key,
    this.symbol = 'BINANCE:BTCUSDT',
    this.interval = '60',
    this.theme, // 'light' or 'dark'; if null, syncs to app theme
    this.height, // if null, height is responsive
  });

  final String symbol;
  final String interval;
  final String? theme;
  final double? height;

  @override
  State<TradingViewChart> createState() => _TradingViewChartState();
}

class _TradingViewChartState extends State<TradingViewChart> {
  late String _viewType;
  late String _effectiveTheme;
  late double _effectiveHeight;
  bool _isLoaded = false;
  bool _hasError = false;
  Uri? _lastUri;
  bool _initialized = false;
  Timer? _loadTimeout;

  @override
  void initState() {
    super.initState();
    // Defer initial registration to after frame is built to avoid
    // Theme.of() calls during initialization.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _registerView();
        _initialized = true;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) return;
    // Re-register if theme changes via app theme.
    final brightness = Theme.of(context).brightness;
    final themeFromContext = brightness == Brightness.dark ? 'dark' : 'light';
    final desiredTheme = widget.theme ?? themeFromContext;
    if (_effectiveTheme != desiredTheme) {
      _registerView();
    }
  }

  @override
  void didUpdateWidget(covariant TradingViewChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.symbol != widget.symbol ||
        oldWidget.interval != widget.interval ||
        oldWidget.theme != widget.theme ||
        oldWidget.height != widget.height) {
      _registerView();
    }
  }

  void _registerView() {
    _isLoaded = false;
    _hasError = false;
    _viewType = 'tradingview-${DateTime.now().microsecondsSinceEpoch}';

    final brightness = Theme.of(context).brightness;
    _effectiveTheme = widget.theme ?? (brightness == Brightness.dark ? 'dark' : 'light');

    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    // Responsive height: small screens get a smaller chart
    _effectiveHeight = widget.height ?? (width < 700 ? 320 : 480);

    final uri = Uri.parse(
      'https://s.tradingview.com/widgetembed/?'
      'frameElementId=${_viewType}'
      '&symbol=${Uri.encodeComponent(widget.symbol)}'
      '&interval=${Uri.encodeComponent(widget.interval)}'
      '&theme=${Uri.encodeComponent(_effectiveTheme)}'
      '&style=1'
      '&timezone=Etc%2FUTC'
      '&hideideas=1'
      '&studies=[]'
    );
    _lastUri = uri;

    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = uri.toString()
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '${_effectiveHeight}px'
          ..allow = 'clipboard-write; fullscreen';

        // Mark as loaded once iframe loads; provide timeout fallback.
        iframe.onLoad.listen((_) {
          if (!mounted) return;
          _loadTimeout?.cancel();
          setState(() {
            _isLoaded = true;
            _hasError = false;
          });
        });
        // If not loaded within timeout, show fallback UI.
        _loadTimeout?.cancel();
        _loadTimeout = Timer(const Duration(seconds: 6), () {
          if (!mounted || _isLoaded) return;
          setState(() {
            _hasError = true;
          });
        });
        return iframe;
      },
    );
    // Trigger rebuild to attach new viewType
    if (mounted) {
      setState(() {});
    }
  }

  void _retry() {
    _registerView();
  }

  @override
  void dispose() {
    _loadTimeout?.cancel();
    super.dispose();
  }

  void _openInNewTab() {
    final url = _lastUri?.toString();
    if (url != null) {
      html.window.open(url, '_blank');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _effectiveHeight,
      child: Stack(
        children: [
          HtmlElementView(viewType: _viewType),
          if (!_isLoaded && !_hasError)
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            ),
          if (_hasError)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 32),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load chart. It may be blocked or offline.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(onPressed: _retry, child: const Text('Retry')),
                        TextButton(onPressed: _openInNewTab, child: const Text('Open in new tab')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
