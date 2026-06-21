import 'package:ax_dapp/repositories/one_inch/one_inch_api_client.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair_info.dart';
import 'package:ax_dapp/swap/models/swap_type.dart';
import 'package:fpdart/fpdart.dart';

/// UseCase for fetching swap information from 1inch aggregator
///
/// This provides a fallback when no direct liquidity pool exists
class GetAggregatorSwapInfoUseCase {
  GetAggregatorSwapInfoUseCase(this._oneInchClient);

  final OneInchApiClient _oneInchClient;

  /// Fetches swap quote from 1inch and transforms to TokenSwapInfo
  ///
  /// [chainId]: Blockchain network ID (137 for Polygon, etc.)
  /// [tokenFrom]: Source token address
  /// [tokenTo]: Destination token address
  /// [fromInput]: Amount to swap (in token units, not wei)
  /// [slippage]: Slippage tolerance (default 1%)
  ///
  /// Returns Either.left(Success) with TokenSwapInfo or Either.right(Error)
  Future<Either<Success, Error>> fetchAggregatorSwapInfo({
    required int chainId,
    required String tokenFrom,
    required String tokenTo,
    required double fromInput,
    double? slippage,
  }) async {
    try {
      // Convert amount to wei (assuming 18 decimals for now)
      // TODO: Get actual decimals from token contract
      final amountInWei =
          (fromInput * 1e18).toStringAsFixed(0).replaceAll('.', '');

      // ignore: avoid_print
      print(
        '[GetAggregatorSwapInfo] Fetching 1inch quote for $fromInput tokens ($amountInWei wei)',
      );

      final quoteData = await _oneInchClient.getQuote(
        chainId: chainId,
        srcToken: tokenFrom,
        dstToken: tokenTo,
        amount: amountInWei,
      );

      // Extract data from 1inch response
      final dstAmount = double.parse(quoteData['dstAmount'] as String) / 1e18;

      final protocols = _extractProtocols(quoteData);
      final routePath = _buildRoutePath(quoteData, tokenFrom, tokenTo);

      final slippageTolerance = slippage ?? 0.01;

      // Calculate swap info
      final minimumReceived = dstAmount * (1 - slippageTolerance);

      // 1inch doesn't provide explicit price impact, calculate approximation
      final priceImpact = fromInput > 0
          ? ((fromInput - dstAmount) / fromInput * 100).abs()
          : 0.0;

      // 1inch fees are built into the quote
      final totalFee =
          fromInput * 0.005; // Approximate 0.5% for aggregated routes

      final swapInfo = TokenSwapInfo(
        toPrice: fromInput > 0 ? dstAmount / fromInput : 0,
        fromPrice: dstAmount > 0 ? fromInput / dstAmount : 0,
        minimumReceived: minimumReceived,
        priceImpact: priceImpact,
        receiveAmount: dstAmount,
        totalFee: totalFee,
        swapType: SwapType.aggregated,
        protocols: protocols,
        routePath: routePath,
      );

      // ignore: avoid_print
      print(
          '[GetAggregatorSwapInfo] 1inch quote successful: $dstAmount tokens',);

      return Either.left(Success(swapInfo));
    } on OneInchRateLimitException catch (e) {
      // ignore: avoid_print
      print('[GetAggregatorSwapInfo] Rate limit: $e');
      return Either.right(const Error('1inch rate limit exceeded, try again'));
    } on OneInchApiException catch (e) {
      // ignore: avoid_print
      print('[GetAggregatorSwapInfo] API error: $e');
      return Either.right(Error('1inch API error: ${e.message}'));
    } catch (e) {
      // ignore: avoid_print
      print('[GetAggregatorSwapInfo] Unexpected error: $e');
      return Either.right(Error('Failed to get aggregator quote: $e'));
    }
  }

  /// Extracts protocol names from 1inch response
  List<String> _extractProtocols(Map<String, dynamic> quoteData) {
    try {
      final protocols = <String>{};

      // 1inch protocols format: [[["UNISWAP_V3", ...], ...]]
      if (quoteData.containsKey('protocols')) {
        final protocolsList = quoteData['protocols'] as List<dynamic>;
        for (final route in protocolsList) {
          if (route is List) {
            for (final step in route) {
              if (step is List && step.isNotEmpty) {
                for (final protocol in step) {
                  if (protocol is List && protocol.isNotEmpty) {
                    final name = protocol[0]['name'] as String?;
                    if (name != null) {
                      protocols.add(_formatProtocolName(name));
                    }
                  }
                }
              }
            }
          }
        }
      }

      return protocols.toList();
    } catch (e) {
      // ignore: avoid_print
      print('[GetAggregatorSwapInfo] Error extracting protocols: $e');
      return [];
    }
  }

  /// Builds human-readable route path
  String _buildRoutePath(
    Map<String, dynamic> quoteData,
    String tokenFrom,
    String tokenTo,
  ) {
    try {
      // For now, simple direct route display
      // TODO: Parse intermediate tokens from protocols data
      return 'Direct';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Formats protocol name for display
  String _formatProtocolName(String name) {
    // Convert "UNISWAP_V3" to "Uniswap V3"
    return name
        .split('_')
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join(' ');
  }
}
