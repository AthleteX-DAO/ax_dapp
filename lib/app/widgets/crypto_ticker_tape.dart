import 'dart:async';
import 'package:ax_dapp/repositories/market_price/market_price_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cryptocurrency ticker tape widget showing top 15 cryptos with scrolling animation
class CryptoTickerTape extends StatefulWidget {
  const CryptoTickerTape({super.key});

  @override
  State<CryptoTickerTape> createState() => _CryptoTickerTapeState();
}

class _CryptoTickerTapeState extends State<CryptoTickerTape>
    with SingleTickerProviderStateMixin {
  late AnimationController _scrollController;
  List<CryptoTicker> _cryptos = [];
  bool _isLoading = true;
  late ScrollController _scrollController2;
  Timer? _refreshTimer;
  MarketPriceRepository? _ownedRepository;
  late MarketPriceRepository _marketPriceRepository;
  DateTime _lastUserScroll = DateTime.fromMillisecondsSinceEpoch(0);
  static const double _scrollSpeed = 0.6;

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _scrollController2 = ScrollController();

    _scrollController.addListener(_onAutoScrollTick);
    _scrollController.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Try to read shared MarketPriceRepository from widget tree.
    // Fall back to creating our own if none is provided.
    try {
      _marketPriceRepository = context.read<MarketPriceRepository>();
    } catch (_) {
      _ownedRepository ??= MarketPriceRepository();
      _marketPriceRepository = _ownedRepository!;
    }

    // Start fetching and polling (idempotent — timer is created once)
    if (_refreshTimer == null) {
      _fetchCryptoData();
      _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        _fetchCryptoData();
      });
    }
  }

  void _onAutoScrollTick() {
    if (!_scrollController2.hasClients) return;

    final now = DateTime.now();
    if (now.difference(_lastUserScroll).inSeconds < 2) return;

    final maxScroll = _scrollController2.position.maxScrollExtent;
    if (maxScroll == 0) return;

    final halfScroll = maxScroll / 2;
    final nextOffset = _scrollController2.offset + _scrollSpeed;

    if (nextOffset >= halfScroll) {
      _scrollController2.jumpTo(nextOffset - halfScroll);
    } else {
      _scrollController2.jumpTo(nextOffset);
    }
  }

  Future<void> _fetchCryptoData() async {
    try {
      final symbols = <String>[
        'BTC',
        'ETH',
        'SOL',
        'XRP',
        'ADA',
        'DOT',
        'LINK',
        'MATIC',
        'AVAX',
        'OP',
        'ARB',
        'LDO',
        'UNI',
        'AAVE',
        'USDC',
      ];

      final summaries =
          await _marketPriceRepository.fetchMarketSummaries(symbols);

      final cryptos = <CryptoTicker>[];
      for (final symbol in symbols) {
        final summary = summaries[symbol];
        if (summary == null) continue;
        cryptos.add(
          CryptoTicker(
            summary.symbol,
            summary.name,
            summary.price,
            summary.change1h,
          ),
        );
      }

      if (mounted) {
        setState(() {
          _cryptos = cryptos.isNotEmpty ? cryptos : _getMockCryptos();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching crypto data: $e');
      if (mounted) {
        setState(() {
          _cryptos = _getMockCryptos();
          _isLoading = false;
        });
      }
    }
  }

  List<CryptoTicker> _getMockCryptos() {
    return [
      CryptoTicker('BTC', 'Bitcoin', 42850.50, 2.35),
      CryptoTicker('ETH', 'Ethereum', 2280.75, 1.82),
      CryptoTicker('SOL', 'Solana', 185.40, -0.95),
      CryptoTicker('XRP', 'Ripple', 2.45, 3.12),
      CryptoTicker('ADA', 'Cardano', 0.98, -1.23),
      CryptoTicker('DOT', 'Polkadot', 8.75, 2.45),
      CryptoTicker('LINK', 'Chainlink', 22.30, 1.67),
      CryptoTicker('MATIC', 'Polygon', 0.89, -0.45),
      CryptoTicker('AVAX', 'Avalanche', 38.50, 2.12),
      CryptoTicker('OP', 'Optimism', 3.45, 1.56),
      CryptoTicker('ARB', 'Arbitrum', 1.78, 2.34),
      CryptoTicker('LDO', 'Lido', 18.90, -1.12),
      CryptoTicker('UNI', 'Uniswap', 12.35, 1.89),
      CryptoTicker('AAVE', 'Aave', 285.60, 2.76),
      CryptoTicker('USDC', 'USD Coin', 1, 0.02),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController2.dispose();
    _refreshTimer?.cancel();
    // Only dispose the repository if we created it ourselves
    _ownedRepository?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _cryptos.isEmpty) {
      return Container(
        height: 40,
        color: const Color(0xFF1a1a1a),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Color(0xFFFFD700)),
            ),
          ),
        ),
      );
    }

    // Duplicate cryptos for seamless scrolling
    final displayCryptos = [..._cryptos, ..._cryptos];

    return Container(
      height: 40,
      color: const Color(0xFF1a1a1a),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification) {
            _lastUserScroll = DateTime.now();
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: _scrollController2,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (int i = 0; i < displayCryptos.length; i++)
                _TickerItem(crypto: displayCryptos[i]),
            ],
          ),
        ),
      ),
    );
  }
}

class _TickerItem extends StatelessWidget {

  const _TickerItem({required this.crypto});
  final CryptoTicker crypto;

  @override
  Widget build(BuildContext context) {
    final isPositive = crypto.change24h >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey.withAlpha(30),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ticker symbol
          SizedBox(
            width: 50,
            child: Text(
              crypto.symbol,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Price
          SizedBox(
            width: 80,
            child: Text(
              '\$${crypto.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          // 1h change
          SizedBox(
            width: 60,
            child: Text(
              '${isPositive ? '+' : ''}${crypto.change24h.toStringAsFixed(2)}%',
              style: TextStyle(
                color: changeColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class CryptoTicker {

  CryptoTicker(this.symbol, this.name, this.price, this.change24h);
  final String symbol;
  final String name;
  final double price;
  final double change24h;
}
