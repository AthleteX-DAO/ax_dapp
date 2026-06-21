import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/trade/widgets/price_chart.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class AssetDetailsDialog extends StatefulWidget {
  const AssetDetailsDialog({
    super.key,
    required this.token,
  });

  final Token token;

  @override
  State<AssetDetailsDialog> createState() => _AssetDetailsDialogState();
}

class _AssetDetailsDialogState extends State<AssetDetailsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CoinData? _coinData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchCoinData();
  }

  Future<void> _fetchCoinData() async {
    try {
      final tokensRepository = context.read<TokensRepository>();
      // Use ticker/symbol as ID for now, or map it.
      // CoinGecko IDs are usually lowercase full names (e.g. 'bitcoin', 'ethereum').
      // Token model has 'ticker' (e.g. 'BTC').
      // This is a known issue: mapping symbols to CoinGecko IDs.
      // For now, let's try using the ticker in lowercase or name in lowercase.
      // Ideally, Token model should have a 'coinGeckoId'.
      // Fallback: try name.toLowerCase().replaceAll(' ', '-')

      var coinId = widget.token.name.toLowerCase().replaceAll(' ', '-');
      if (widget.token.ticker == 'AX') coinId = 'athletex';
      if (widget.token.ticker == 'MATIC') coinId = 'matic-network';

      final data = await tokensRepository.getCoinData(coinId);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey),
      ),
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(20),
        decoration: boxDecoration(Colors.black, 12, 1, Colors.grey),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: tokenImage(widget.token),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.token.name,
                      style: textStyle(Colors.white, 20,
                          isBold: true, isUline: false,),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.amber,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Price Chart'),
                Tab(text: 'Insights'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPriceChartTab(),
                  _buildInsightsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceChartTab() {
    var coinId = widget.token.name.toLowerCase().replaceAll(' ', '-');
    if (widget.token.ticker == 'AX') coinId = 'athletex';
    if (widget.token.ticker == 'MATIC') coinId = 'matic-network';

    return PriceChart(coinId: coinId);
  }

  Widget _buildInsightsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_coinData == null) {
      return const Center(
          child:
              Text('No data available', style: TextStyle(color: Colors.white)),);
    }

    final description = (_coinData?.description?['en'] as String?) ??
        'No description available.';
    final links = _coinData?.links ?? {};
    final homepage = (links['homepage'] as List?)?.firstOrNull as String?;
    final twitter = links['twitter_screen_name'] as String?;
    final github =
        (links['repos_url']?['github'] as List?)?.firstOrNull as String?;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: textStyle(Colors.white, 16, isBold: true, isUline: false),
          ),
          const SizedBox(height: 10),
          Text(
            description.replaceAll(RegExp('<[^>]*>'), ''), // Remove HTML tags
            style:
                textStyle(Colors.grey[400]!, 14, isBold: false, isUline: false),
          ),
          const SizedBox(height: 20),
          Text(
            'Resources',
            style: textStyle(Colors.white, 16, isBold: true, isUline: false),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (homepage != null && homepage.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.language, color: Colors.white),
                  onPressed: () => launchUrl(Uri.parse(homepage)),
                  tooltip: 'Website',
                ),
              if (twitter != null && twitter.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.alternate_email,
                      color: Colors.white,), // Twitter icon replacement
                  onPressed: () =>
                      launchUrl(Uri.parse('https://twitter.com/$twitter')),
                  tooltip: 'Twitter',
                ),
              if (github != null && github.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.code, color: Colors.white),
                  onPressed: () => launchUrl(Uri.parse(github)),
                  tooltip: 'Github',
                ),
            ],
          ),
        ],
      ),
    );
  }
}
