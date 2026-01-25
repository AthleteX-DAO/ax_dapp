/// Synthetix V3 deployment configuration for Sepolia testnet
/// Generated: January 8, 2026
class SynthetixConfig {
  // Network
  static const int chainId = 11155111; // Sepolia
  static const String networkName = 'Sepolia';
  static const String rpcUrl =
      'https://sepolia.infura.io/v3/295739f3c9f64796bccfc206fc476a88';
  static const String explorerUrl = 'https://sepolia.etherscan.io';

  // Core Synthetix V3 (synthetix:3.13.0@main)
  static const String coreProxy = '0x81b67277d95889F665DD54cc070D956A8DC8c663';
  static const String usdProxy = '0x43203b045aBD358dE7dB13b9B0F5D6315BC37FEc';
  static const String accountRouter =
      '0xe0cdd89aa8e7f13b5493d463291de1811ac50318';
  static const String accountProxy =
      '0xae3B3f8cECB9111EDDdF96115E536be188403bE7';
  static const String usdRouter = '0x814fa0da1dea240df155a46653d1dc7d7e96b733';
  static const String coreRouter = '0x2f8bee4e0813ed5190422f2be22957487bcd788b';

  // Spot Market (synthetix-spot-market:3.12.2@main)
  static const String spotMarketProxy =
      '0xdBE114Ef3054Ad9Ed2A3b6beee538433f72BAfc2';
  static const String spotMarketRouter =
      '0x49232bd36374bd5e129dd2e91da18a81dc87832d';
  static const String synthRouter =
      '0x3bf31896b2cc5e18af9bb81cd007a1ce8613418c';

  // Perps Market (synthetix-perps-market:3.13.0@main)
  static const String perpsMarketProxy =
      '0x52EB4fCd18442D497Eb664225de15c23d4F4238f';
  static const String perpsMarketRouter =
      '0xc1c5f80f77f122ce2dc82545826bf4701680b907';
  static const String perpsAccountProxy =
      '0x45cB8b65bB88B33a7F06f9a2484Cb511506f753e';

  // AthleteX Tokens
  static const String axToken = '0xDc5Aa90C7ce823cFBc62aBC3c035c609a97a0A3C';
  static const String axUSD = '0x1cBc31Fe381442f108dE787038886a297AB68770';
  static const String sxPriceOracle =
      '0x5C0971FfeE102be263259Fc0A1b35f46BE81ce5c';

  // Owner (your wallet)
  static const String owner = '0x3E70f657AeaA09C413633d881A409a024D28E82C';

  // Helper methods
  static String getExplorerUrl(String address) =>
      '$explorerUrl/address/$address';

  static String getExplorerTxUrl(String txHash) => '$explorerUrl/tx/$txHash';

  static Map<String, String> get allContracts => {
        'CoreProxy': coreProxy,
        'USDProxy': usdProxy,
        'AccountRouter': accountRouter,
        'SpotMarketProxy': spotMarketProxy,
        'PerpsMarketProxy': perpsMarketProxy,
        'AX Token': axToken,
        'axUSD': axUSD,
      };
}
