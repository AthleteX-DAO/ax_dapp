# AthleteX Deployment Configuration

## Ethereum Sepolia (Chain ID: 11155111)
- **CoreProxy**: 0x81b67277d95889F665DD54cc070D956A8DC8c663
- **SpotMarketProxy**: 0xdBE114Ef3054Ad9Ed2A3b6beee538433f72BAfc2
- **PerpsMarketProxy**: 0x52EB4fCd18442D497Eb664225de15c23d4F4238f
- **USDProxy**: 0x43203b045aBD358dE7dB13b9B0F5D6315BC37FEc
- **RPC**: https://sepolia.infura.io/v3/295739f3c9f64796bccfc206fc476a88

## Base Sepolia (Chain ID: 84532)
- **PerpsMarketProxy**: 0xf53Ca60F031FAf0E347D44FbaA4870da68250c8d
- **SpotMarketProxy**: 0xaD2fE24969eb85fbCc55ff6C6f0CB8dDcF63C99e
- **RPC**: https://base-sepolia.infura.io/v3/295739f3c9f64796bccfc206fc476a88

## Tokens (Sepolia)
- **AX Token**: 0xDc5Aa90C7ce823cFBc62aBC3c035c609a97a0A3C
- **axUSD**: 0x1cBc31Fe381442f108dE787038886a297AB68770
- **Deployer**: 0x3E70f657AeaA09C413633d881A409a024D28E82C

## Uniswap V3 (Polygon Mainnet)
- **AX Token**: 0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df
- **Factory**: 0x1F98431c8aD98523631AE4a59f267346ea31F984
- **QuoterV2**: 0x61fFE014bA17989E743c5F6cB21bF9697530B21e

## Upgrade Process
Modify contract code, then run:
```bash
cd liquidity-engine/protocol/synthetix
yarn hardhat cannon:build tomls/omnibus-sepolia-athletex.toml --network sepolia
```
Cannon automatically detects bytecode changes, deploys new implementation, and upgrades proxy.
Verify with: `const impl = await proxy.getImplementation()`
