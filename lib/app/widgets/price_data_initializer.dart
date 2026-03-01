import 'package:ax_dapp/predict/data/firebase_price_client.dart';
import 'package:ax_dapp/predict/usecases/get_top_prediction_markets_usecase.dart';
import 'package:ax_dapp/predict/utils/seed_dummy_prices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget that initializes Firebase price data on app load.
/// 
/// Seeds dummy prices for top prediction markets so the hero carousel
/// has realistic price history data without waiting for real market activity.
class PriceDataInitializer extends StatefulWidget {
  final Widget child;

  const PriceDataInitializer({
    required this.child,
    super.key,
  });

  @override
  State<PriceDataInitializer> createState() => _PriceDataInitializerState();
}

class _PriceDataInitializerState extends State<PriceDataInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePriceData();
  }

  Future<void> _initializePriceData() async {
    if (_isInitialized) return;

    try {
      debugPrint('🚀 Initializing Firebase price data...');

      final firebaseClient = context.read<FirebasePriceClient>();
      final getTopMarketsUseCase =
          context.read<GetTopPredictionMarketsUseCase>();

      await seedTopMarketsWithDummyPrices(
        firebaseClient: firebaseClient,
        getTopMarketsUseCase: getTopMarketsUseCase,
      );

      setState(() {
        _isInitialized = true;
      });

      debugPrint('✅ Price data initialized successfully!');
    } catch (e) {
      debugPrint('⚠️ Failed to initialize price data: $e');
      // Continue loading app even if seeding fails
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
