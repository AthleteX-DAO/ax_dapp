import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class TradePageHeader extends StatefulWidget {
  const TradePageHeader({
    super.key,
    required this.coinId,
  });

  final String coinId;

  @override
  State<TradePageHeader> createState() => _TradePageHeaderState();
}

class _TradePageHeaderState extends State<TradePageHeader> {
  CoinData? _coinData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoinData();
  }

  Future<void> _fetchCoinData() async {
    try {
      final tokensRepository = context.read<TokensRepository>();
      final data = await tokensRepository.getCoinData(widget.coinId);
      if (mounted) {
        setState(() {
          _coinData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_coinData == null) {
      return const SizedBox(height: 80);
    }

    final currentPrice = _coinData?.marketData?.currentPrice?['usd'] ?? 0.0;
    final priceChange = _coinData?.marketData?.priceChangePercentage24H ?? 0.0;
    final isPositive = priceChange >= 0;
    final priceStr = '\$${currentPrice.toStringAsFixed(2)}';
    final changeStr = '${priceChange.toStringAsFixed(2)}%';

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: boxDecoration(
        Colors.grey[800]!.withOpacity(0.6),
        30,
        0.5,
        Colors.grey[400]!,
      ),
      child: Row(
        children: [
          // Token Icon & Name
          if (_coinData?.image?.thumb != null)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(_coinData!.image!.thumb),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _coinData?.name ?? 'Unknown',
                style:
                    textStyle(Colors.white, 24, isBold: true, isUline: false),
              ),
              Text(
                _coinData?.symbol.toUpperCase() ?? '',
                style:
                    textStyle(Colors.grey, 14, isBold: false, isUline: false),
              ),
            ],
          ),
          const Spacer(),
          // Price & Change
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceStr,
                style:
                    textStyle(Colors.white, 32, isBold: true, isUline: false),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    changeStr,
                    style: textStyle(
                      isPositive ? Colors.green : Colors.red,
                      16,
                      isBold: true,
                      isUline: false,
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
