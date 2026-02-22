import 'package:ax_dapp/perps/bloc/perps_page_bloc.dart';
import 'package:ax_dapp/service/controller/perps/perps_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/perps/widgets/trading_view_chart.dart';
import 'package:ax_dapp/perps/widgets/perps_trading_column.dart';
import 'package:ax_dapp/perps/widgets/position_summary_card.dart';
import 'package:ax_dapp/perps/utils/perps_responsive.dart';

/// Desktop Perpetuals page displaying BTC Perps data with responsive 3-column layout
class DesktopPerpetualsPage extends StatefulWidget {
  const DesktopPerpetualsPage({super.key});

  @override
  State<DesktopPerpetualsPage> createState() => _DesktopPerpetualsPageState();
}

class _DesktopPerpetualsPageState extends State<DesktopPerpetualsPage> {
  String _selectedMarket = 'ETH';
  bool _showMarketDropdown = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  /// Available perps markets — matches on-chain IDs from PerpsMarket.marketIds.
  static const Map<String, String> _availableMarkets = {
    'ETH': 'Ethereum',
    'BTC': 'Bitcoin',
    'SOL': 'Solana',
    'LINK': 'Chainlink',
    'ARB': 'Arbitrum',
    'DOGE': 'Dogecoin',
    'BNB': 'BNB',
    'XRP': 'Ripple',
    'ADA': 'Cardano',
  };

  @override
  void initState() {
    super.initState();
    context.read<PerpsPageBloc>().add(const PerpsPageInitialize());
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<PerpsPageBloc, PerpsPageState>(
        builder: (context, state) {
          if (state is PerpsPageLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PerpsPageError) {
            return _buildErrorState(state.message);
          }

          if (state is PerpsPageLoaded) {
            final data = state.btcPerpsData;
            return _buildContent(data);
          }

          // Initial / unknown state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PerpsPageBloc>().add(const PerpsPageRefresh());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(PerpsMarketData data) {
    final isMobile = PerpResponsive.isMobile(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_showMarketDropdown) setState(() => _showMarketDropdown = false);
      },
      child: isMobile ? _buildMobileContent(data) : _buildDesktopContent(data),
    );
  }

  /// Desktop: header on top, then chart + trading panel side-by-side.
  /// No overlay on iframe — eliminates pointer-event conflicts.
  Widget _buildDesktopContent(PerpsMarketData data) {
    return Column(
      children: [
        // ── Header with market selector + stats ──
        // Wrapped in Stack so dropdown can overlay below header
        Stack(
          clipBehavior: Clip.none,
          children: [
            _buildMarketHeaderArea(data),
            // Market dropdown (renders below header, above chart)
            if (_showMarketDropdown)
              Positioned(
                top: 62,
                left: 24,
                child: _buildMarketDropdown(),
              ),
          ],
        ),
        // ── Main content: Chart + Trading panel ──
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Chart fills remaining space
              Expanded(
                child: TradingViewChart(
                  symbol: _tradingViewSymbol(_selectedMarket),
                ),
              ),
              // Divider
              Container(
                width: 1,
                color: Colors.white.withOpacity(0.06),
              ),
              // Trading panel — fixed width
              SizedBox(
                width: 300,
                child: _buildTradingPanel(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Mobile: stacked layout (chart → trading → positions)
  Widget _buildMobileContent(PerpsMarketData data) {
    return Column(
      children: [
        _buildMarketHeaderArea(data),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                // Chart
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: PerpResponsive.getChartHeight(context),
                    child: TradingViewChart(
                      symbol: _tradingViewSymbol(_selectedMarket),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Trading
                _buildTradingPanel(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Trading panel for the right-side column on desktop.
  Widget _buildTradingPanel() {
    return ColoredBox(
      color: const Color(0xFF0D0D0D),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            PerpsTradingColumn(symbol: _selectedMarket),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade800, height: 1),
            const SizedBox(height: 12),
            const PositionSummaryCard(hasPosition: false),
          ],
        ),
      ),
    );
  }

  /// Maps market symbol to TradingView ticker.
  String _tradingViewSymbol(String symbol) {
    const mapping = <String, String>{
      'BTC': 'BINANCE:BTCUSDT',
      'ETH': 'BINANCE:ETHUSDT',
      'SOL': 'BINANCE:SOLUSDT',
      'BNB': 'BINANCE:BNBUSDT',
      'XRP': 'BINANCE:XRPUSDT',
      'DOGE': 'BINANCE:DOGEUSDT',
      'ADA': 'BINANCE:ADAUSDT',
      'LINK': 'BINANCE:LINKUSDT',
      'ARB': 'BINANCE:ARBUSDT',
    };
    return mapping[symbol] ?? 'BINANCE:BTCUSDT';
  }

  /// Market header area: top row with search bar + market selector,
  /// bottom row with stats — fills the gap between nav and content.
  Widget _buildMarketHeaderArea(PerpsMarketData data) {
    final isMobile = PerpResponsive.isMobile(context);
    final price = data.priceInUSD;
    final funding = data.fundingRatePercentage;
    final oi = data.openInterestUSD;
    final skewPct = _calculateSkewPercent(data);
    final hPad = isMobile ? 12.0 : 24.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.92),
            Colors.black.withOpacity(0.80),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Row 1: Market selector + title + search ──
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 4, hPad, 4),
            child: Row(
              children: [
                // Clickable market pair selector
                GestureDetector(
                  onTap: () => setState(() =>
                      _showMarketDropdown = !_showMarketDropdown,),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8,),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _showMarketDropdown
                            ? Colors.amber.withOpacity(0.5)
                            : Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _marketIcon(_selectedMarket),
                        const SizedBox(width: 8),
                        Text(
                          '$_selectedMarket/USD',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          _showMarketDropdown
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Perpetual',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const Spacer(),
                // Search bar (desktop only)
                if (!isMobile)
                  SizedBox(
                    width: 220,
                    height: 36,
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Search markets',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search, color: Colors.grey, size: 18,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.04),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.amber.withOpacity(0.5),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8,
                        ),
                      ),
                      onTap: () {
                        if (!_showMarketDropdown) {
                          setState(() => _showMarketDropdown = true);
                        }
                      },
                    ),
                  ),
                const SizedBox(width: 8),
                // Refresh
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  onPressed: () => context
                      .read<PerpsPageBloc>()
                      .add(const PerpsPageRefresh()),
                  tooltip: 'Refresh',
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          // ── Row 2: Stats ribbon ──
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _headerStat('Price',
                    price > 0 ? '\$${_formatPrice(price)}' : '--',
                    Colors.white,),
                  _headerDivider(),
                  _headerStat('Funding / 8h',
                    price > 0
                        ? '${funding >= 0 ? "+" : ""}${funding.toStringAsFixed(4)}%'
                        : '--',
                    funding >= 0 ? Colors.greenAccent : Colors.redAccent,),
                  _headerDivider(),
                  _headerStat('Open Interest',
                    price > 0 ? '\$${_formatLargeNumber(oi)}' : '--',
                    Colors.white,),
                  _headerDivider(),
                  _headerStat('Skew',
                    price > 0
                        ? '${skewPct.toStringAsFixed(0)}% / '
                          '${(100 - skewPct).toStringAsFixed(0)}%'
                        : '--',
                    skewPct > 55
                        ? Colors.greenAccent
                        : skewPct < 45
                            ? Colors.redAccent
                            : Colors.grey,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dropdown overlay for selecting a market pair.
  Widget _buildMarketDropdown() {
    final filtered = _availableMarkets.entries.where((e) {
      if (_searchQuery.isEmpty) return true;
      return e.key.toLowerCase().contains(_searchQuery) ||
          e.value.toLowerCase().contains(_searchQuery);
    }).toList();

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 260,
        constraints: const BoxConstraints(maxHeight: 320),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.white.withOpacity(0.06),),
                  ),
                ),
                child: Row(
                  children: [
                    Text('Select Market',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),),
                    const Spacer(),
                    Text('${filtered.length} pairs',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),),
                  ],
                ),
              ),
              // Market list
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final entry = filtered[index];
                    final isSelected = entry.key == _selectedMarket;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMarket = entry.key;
                          _showMarketDropdown = false;
                          _searchController.clear();
                        });
                        context.read<PerpsPageBloc>().add(
                          MarketChanged(entry.key),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10,),
                        color: isSelected
                            ? Colors.amber.withOpacity(0.08)
                            : Colors.transparent,
                        child: Row(
                          children: [
                            _marketIcon(entry.key, size: 24),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${entry.key}/USD',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.amber
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  entry.value,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (isSelected)
                              const Icon(Icons.check,
                                  color: Colors.amber, size: 16,),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a colored circle icon for a given market symbol.
  Widget _marketIcon(String symbol, {double size = 28}) {
    const glyphs = <String, String>{
      'BTC': '₿', 'ETH': 'Ξ', 'SOL': '◎', 'BNB': '◆',
      'XRP': '✕', 'DOGE': 'Ð', 'ADA': '₳',
      'LINK': '⛓', 'ARB': '▲',
    };
    const colors = <String, Color>{
      'BTC': Colors.orange,
      'ETH': Color(0xFF627EEA),
      'SOL': Color(0xFF9945FF),
      'BNB': Color(0xFFF3BA2F),
      'XRP': Color(0xFF23292F),
      'DOGE': Color(0xFFC2A633),
      'ADA': Color(0xFF0033AD),
      'LINK': Color(0xFF2A5ADA),
      'ARB': Color(0xFF28A0F0),
    };
    final glyph = glyphs[symbol] ?? '?';
    final color = colors[symbol] ?? Colors.grey;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          glyph,
          style: TextStyle(
            fontSize: size * 0.55,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _headerStat(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(
          fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),),
        const SizedBox(height: 3),
        Text(value, style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: valueColor,
        ),),
      ],
    );
  }

  Widget _headerDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 1, height: 32,
        color: Colors.white.withOpacity(0.08),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(1).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
    }
    return price.toStringAsFixed(2);
  }

  String _formatLargeNumber(double number) {
    if (number >= 1e9) return '${(number / 1e9).toStringAsFixed(1)}B';
    if (number >= 1e6) return '${(number / 1e6).toStringAsFixed(1)}M';
    if (number >= 1e3) return '${(number / 1e3).toStringAsFixed(1)}K';
    return number.toStringAsFixed(0);
  }

  /// Calculates long percentage from raw native-unit skew and size.
  /// skew = longs - shorts, size = longs + shorts
  /// longs% = (size + skew) / (2 * size) * 100
  double _calculateSkewPercent(PerpsMarketData data) {
    final size = data.openInterest.toDouble() / 1e18; // native units
    final skew = data.skew.toDouble() / 1e18;
    if (size == 0) return 50;
    final longPct = ((size + skew) / (2 * size)) * 100;
    return longPct.clamp(0.0, 100.0);
  }
}
