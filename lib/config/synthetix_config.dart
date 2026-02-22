/// Synthetix V3 deployment configuration for Polygon mainnet
/// AthleteX-owned deployment — all contracts deployed fresh via cannon build
/// Updated: February 19, 2026
class SynthetixConfig {
  // Network
  static const int chainId = 137; // Polygon Mainnet
  static const String networkName = 'Polygon Mainnet';
  static const String rpcUrl =
      'https://polygon-mainnet.g.alchemy.com/v2/-GtuG61vyvQl39nydDR6l';
  static const String explorerUrl = 'https://polygonscan.com';

  // Core Synthetix V3 (AthleteX deployment on Polygon mainnet)
  static const String coreProxy =
      '0x4C2474365eE4d6Ab5c6B5cf3ec860530a9162552';
  static const String usdProxy =
      '0x1Ea27b8fa8D9Fb4370Dd654ffFad4734D0960fA6'; // axUSD (sUSD proxy)
  static const String accountRouter = '';
  static const String accountProxy = '';
  static const String usdRouter = '';
  static const String coreRouter = '';

  // Spot Market (AthleteX deployment on Polygon mainnet)
  static const String spotMarketProxy =
      '0xc79eC919a0A20E29873143AB9658aF75C0b73A23';
  static const String spotMarketRouter = '';
  static const String synthRouter = '';

  // Perps Market — not yet deployed on Polygon
  static const String perpsMarketProxy = '';
  static const String perpsMarketRouter = '';
  static const String perpsAccountProxy = '';

  // AthleteX Tokens (deployed on Polygon mainnet via cannon)
  static const String axToken =
      '0x5617604BA0a30E0ff1d2163aB94E50d8b6D0B0Df';
  static const String axUSD =
      '0x1Ea27b8fa8D9Fb4370Dd654ffFad4734D0960fA6'; // same as usdProxy
  static const String sxPriceOracle = '';

  // Oracle Manager (Polygon mainnet)
  static const String oracleManager =
      '0x37bCfB2AA84DE620b3ff4eb946a9CbcF1589DCe2';

  // Rewards Distributor (Polygon mainnet) — filled after deploy-reward-distributor.js
  static const String rewardsDistributor =
      '0x12055514cf8CEf890a012FecCEd580a01c98828a';

  // Oracle Node IDs
  static const String axOracleNodeId = '';

  // Owner of AthleteX Polygon deployment (deployer wallet)
  static const String owner = '0x3E70f657AeaA09C413633d881A409a024D28E82C';

  // Sepolia fallback — kept for reference / testing
  static const String sepoliaRpcUrl =
      'https://sepolia.infura.io/v3/295739f3c9f64796bccfc206fc476a88';
  static const String sepoliaCoreProxy =
      '0x81b67277d95889F665DD54cc070D956A8DC8c663';
  static const String sepoliaSpotMarketProxy =
      '0xdBE114Ef3054Ad9Ed2A3b6beee538433f72BAfc2';

  // Helper methods
  static String getExplorerUrl(String address) =>
      '$explorerUrl/address/$address';

  static String getExplorerTxUrl(String txHash) => '$explorerUrl/tx/$txHash';

  static Map<String, String> get allContracts => {
        'CoreProxy': coreProxy,
        'USDProxy': usdProxy,
        'SpotMarketProxy': spotMarketProxy,
        'OracleManager': oracleManager,
        'AX Token': axToken,
        'axUSD': axUSD,
      };
}
