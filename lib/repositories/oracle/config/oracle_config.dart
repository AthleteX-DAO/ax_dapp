/// Oracle configuration for Synthetix V3 on Sepolia testnet
/// Defines Chainlink, Pyth, and custom oracle endpoints
/// Fallback priority: Chainlink → Pyth → Custom Oracle
class OracleConfig {
  // Sepolia Chainlink Aggregators (USD feeds with 8 decimals)
  // See: https://docs.chain.link/data-feeds/price-feeds/addresses
  // Note: All addresses must be lowercase for web3dart EIP-55 validation
  static const Map<String, String> chainlinkFeeds = {
    'ETH': '0x694aa1769357215de4fac081bf1f309adc325306', // ETH/USD
    'BTC': '0x1b44f3514812d835eb1beab5e6602e888d9b6c71', // BTC/USD
    'USDC': '0xa2f78ab2d3474f7d82235ddc7b3626d8e630b87b', // USDC/USD
    'USDT': '0x3f3f5df88dc9f13eaf3de645d59213199ff5aa7b', // USDT/USD
    'DAI': '0x14866185b1962b63c3ea9e03bc1da838bab34c19', // DAI/USD
    'WETH': '0x694aa1769357215de4fac081bf1f309adc325306', // Use ETH feed for WETH
    'wstETH': '0x694aa1769357215de4fac081bf1f309adc325306', // Use ETH feed for wstETH
  };

  // Chainlink configuration
  static const int chainlinkDecimalPlaces = 8;
  static const Duration chainlinkTimeout = Duration(seconds: 30);

  // Pyth network configuration
  // Pyth feed IDs (32-byte identifiers on Sepolia)
  // See: https://pyth.network/price-feeds
  static const Map<String, String> pythFeedIds = {
    'ETH': '0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace', // Crypto.ETH/USD
    'BTC': '0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43', // Crypto.BTC/USD
    'USDC': '0xeaa020c61cc479712813461ce153894a96a6c00b21ed0416ddbf590b0f2d7c5c', // Stablecoin.USDC/USD
    'USDT': '0x2b89b9dc8fdf9f34709a5b106b472f0f39bb6ca9ce04b0fd7f2e971688d2f148', // Stablecoin.USDT/USD
    'DAI': '0xb0d7644ebb76e91264acff32fda6c3e4f86ca18bb7546381fb3b27bac07064e8', // Stablecoin.DAI/USD
    'WETH': '0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace', // Use ETH feed for WETH
    'wstETH': '0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace', // Use ETH feed for wstETH
  };

  // Pyth configuration
  static const int pythDecimalPlaces = 8;
  static const Duration pythTimeout = Duration(seconds: 30);

  // Custom oracle configuration
  static const String customOracleBaseUrl = 'https://api.athlete-x.io/oracle';
  static const Duration customOracleTimeout = Duration(seconds: 15);
  static const String customOracleApiKey = 'your-api-key-here'; // Should be from env

  // Optimistic ZK oracle configuration (on-chain contract, not deployed yet)
  // Set this to the deployed contract address when available
  static const String? optimisticZkOracleAddress = null;
  static const int optimisticZkOracleDecimals = 8;
  static const Duration optimisticZkOracleTimeout = Duration(seconds: 20);

  // Network configuration
  static const String sepoliaRpcUrl =
      'https://sepolia.infura.io/v3/295739f3c9f64796bccfc206fc476a88';
  static const int sepoliaChainId = 11155111;

  // Fallback oracle priority order
  static const List<OracleSource> fallbackPriority = [
    OracleSource.chainlink,
    OracleSource.pyth,
    OracleSource.optimisticZk,
    OracleSource.custom,
  ];

  // Price staleness threshold (how old a price can be before requesting fresh data)
  static const Duration priceStalenessDuration = Duration(minutes: 5);

  // Confidence threshold for Pyth (minimum acceptable confidence ratio)
  // Pyth confidence = confidence / price, so this should be a small decimal
  static const double pythMinimumConfidenceRatio = 0.01; // 1%

  // Retry configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryBackoffDuration = Duration(seconds: 2);
}

enum OracleSource {
  chainlink,
  pyth,
  optimisticZk,
  custom,
}
