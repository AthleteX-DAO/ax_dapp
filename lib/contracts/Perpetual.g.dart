// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;import 'dart:typed_data' as _i2;final _contractAbi = _i1.ContractAbi.fromJson('[{"inputs":[{"components":[{"internalType":"uint256","name":"withdrawalLiveness","type":"uint256"},{"internalType":"address","name":"configStoreAddress","type":"address"},{"internalType":"address","name":"collateralAddress","type":"address"},{"internalType":"address","name":"tokenAddress","type":"address"},{"internalType":"address","name":"finderAddress","type":"address"},{"internalType":"address","name":"timerAddress","type":"address"},{"internalType":"bytes32","name":"priceFeedIdentifier","type":"bytes32"},{"internalType":"bytes32","name":"fundingRateIdentifier","type":"bytes32"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"minSponsorTokens","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"tokenScaling","type":"tuple"},{"internalType":"uint256","name":"liquidationLiveness","type":"uint256"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"collateralRequirement","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"disputeBondPercentage","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"sponsorDisputeRewardPercentage","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"disputerDisputeRewardPercentage","type":"tuple"}],"internalType":"struct PerpetualLiquidatable.ConstructorParams","name":"params","type":"tuple"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"uint256","name":"collateralAmount","type":"uint256"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"caller","type":"address"},{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"address","name":"liquidator","type":"address"},{"indexed":false,"internalType":"address","name":"disputer","type":"address"},{"indexed":false,"internalType":"uint256","name":"liquidationId","type":"uint256"},{"indexed":false,"internalType":"bool","name":"disputeSucceeded","type":"bool"}],"name":"DisputeSettled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"caller","type":"address"},{"indexed":false,"internalType":"uint256","name":"shutdownTimestamp","type":"uint256"}],"name":"EmergencyShutdown","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"}],"name":"EndedSponsorPosition","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"FinalFeesPaid","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"int256","name":"newFundingRate","type":"int256"},{"indexed":true,"internalType":"uint256","name":"updateTime","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"reward","type":"uint256"}],"name":"FundingRateUpdated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"address","name":"liquidator","type":"address"},{"indexed":true,"internalType":"uint256","name":"liquidationId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"tokensOutstanding","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"lockedCollateral","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"liquidatedCollateral","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"liquidationTime","type":"uint256"}],"name":"LiquidationCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"address","name":"liquidator","type":"address"},{"indexed":true,"internalType":"address","name":"disputer","type":"address"},{"indexed":false,"internalType":"uint256","name":"liquidationId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"disputeBondAmount","type":"uint256"}],"name":"LiquidationDisputed","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"caller","type":"address"},{"indexed":false,"internalType":"uint256","name":"paidToLiquidator","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"paidToDisputer","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"paidToSponsor","type":"uint256"},{"indexed":true,"internalType":"enum PerpetualLiquidatable.Status","name":"liquidationStatus","type":"uint8"},{"indexed":false,"internalType":"uint256","name":"settlementPrice","type":"uint256"}],"name":"LiquidationWithdrawn","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"}],"name":"NewSponsor","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"uint256","name":"collateralAmount","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"tokenAmount","type":"uint256"}],"name":"PositionCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"uint256","name":"collateralAmount","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"tokenAmount","type":"uint256"}],"name":"Redeem","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"regularFee","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"lateFee","type":"uint256"}],"name":"RegularFeesPaid","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"uint256","name":"numTokensRepaid","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"newTokenCount","type":"uint256"}],"name":"Repay","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"uint256","name":"collateralAmount","type":"uint256"}],"name":"RequestWithdrawal","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"uint256","name":"collateralAmount","type":"uint256"}],"name":"RequestWithdrawalCanceled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"uint256","name":"collateralAmount","type":"uint256"}],"name":"RequestWithdrawalExecuted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"caller","type":"address"},{"indexed":true,"internalType":"uint256","name":"collateralReturned","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"tokensBurned","type":"uint256"}],"name":"SettleEmergencyShutdown","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"uint256","name":"collateralAmount","type":"uint256"}],"name":"Withdrawal","type":"event"},{"inputs":[],"name":"applyFundingRate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"cancelWithdrawal","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"collateralCurrency","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"collateralRequirement","outputs":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"configStore","outputs":[{"internalType":"contract ConfigStoreInterface","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"collateralAmount","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"numTokens","type":"tuple"}],"name":"create","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"sponsor","type":"address"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"minCollateralPerToken","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"maxCollateralPerToken","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"maxTokensToLiquidate","type":"tuple"},{"internalType":"uint256","name":"deadline","type":"uint256"}],"name":"createLiquidation","outputs":[{"internalType":"uint256","name":"liquidationId","type":"uint256"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"tokensLiquidated","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"finalFeeBond","type":"tuple"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"cumulativeFeeMultiplier","outputs":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"collateralAmount","type":"tuple"}],"name":"deposit","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"sponsor","type":"address"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"collateralAmount","type":"tuple"}],"name":"depositTo","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"liquidationId","type":"uint256"},{"internalType":"address","name":"sponsor","type":"address"}],"name":"dispute","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"totalPaid","type":"tuple"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"disputeBondPercentage","outputs":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"disputerDisputeRewardPercentage","outputs":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"emergencyShutdown","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"emergencyShutdownPrice","outputs":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"emergencyShutdownTimestamp","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"finder","outputs":[{"internalType":"contract FinderInterface","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"fundingRate","outputs":[{"components":[{"internalType":"int256","name":"rawValue","type":"int256"}],"internalType":"struct FixedPoint.Signed","name":"rate","type":"tuple"},{"internalType":"bytes32","name":"identifier","type":"bytes32"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"cumulativeMultiplier","type":"tuple"},{"internalType":"uint256","name":"updateTime","type":"uint256"},{"internalType":"uint256","name":"applicationTime","type":"uint256"},{"internalType":"uint256","name":"proposalTime","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"sponsor","type":"address"}],"name":"getCollateral","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"collateralAmount","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCurrentTime","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"rawTokenDebt","type":"tuple"}],"name":"getFundingRateAppliedTokenDebt","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"totalCollateral","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"sponsor","type":"address"}],"name":"getLiquidations","outputs":[{"components":[{"internalType":"address","name":"sponsor","type":"address"},{"internalType":"address","name":"liquidator","type":"address"},{"internalType":"enum PerpetualLiquidatable.Status","name":"state","type":"uint8"},{"internalType":"uint256","name":"liquidationTime","type":"uint256"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"tokensOutstanding","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"lockedCollateral","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"liquidatedCollateral","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"rawUnitCollateral","type":"tuple"},{"internalType":"address","name":"disputer","type":"address"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"settlementPrice","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"finalFee","type":"tuple"}],"internalType":"struct PerpetualLiquidatable.LiquidationData[]","name":"liquidationData","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"time","type":"uint256"}],"name":"getOutstandingRegularFees","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"regularFee","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"latePenalty","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"totalPaid","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"gulp","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"liquidationLiveness","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"liquidations","outputs":[{"internalType":"address","name":"sponsor","type":"address"},{"internalType":"address","name":"liquidator","type":"address"},{"internalType":"enum PerpetualLiquidatable.Status","name":"state","type":"uint8"},{"internalType":"uint256","name":"liquidationTime","type":"uint256"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"tokensOutstanding","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"lockedCollateral","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"liquidatedCollateral","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"rawUnitCollateral","type":"tuple"},{"internalType":"address","name":"disputer","type":"address"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"settlementPrice","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"finalFee","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"minSponsorTokens","outputs":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"payRegularFees","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"","type":"tuple"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"pfc","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"positions","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"tokensOutstanding","type":"tuple"},{"internalType":"uint256","name":"withdrawalRequestPassTimestamp","type":"uint256"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"withdrawalRequestAmount","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"rawCollateral","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"priceIdentifier","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"components":[{"internalType":"int256","name":"rawValue","type":"int256"}],"internalType":"struct FixedPoint.Signed","name":"rate","type":"tuple"},{"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"proposeFundingRate","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"totalBond","type":"tuple"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"rawLiquidationCollateral","outputs":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rawTotalPositionCollateral","outputs":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"numTokens","type":"tuple"}],"name":"redeem","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"amountWithdrawn","type":"tuple"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"remargin","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"numTokens","type":"tuple"}],"name":"repay","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"collateralAmount","type":"tuple"}],"name":"requestWithdrawal","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"time","type":"uint256"}],"name":"setCurrentTime","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"settleEmergencyShutdown","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"amountWithdrawn","type":"tuple"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"sponsorDisputeRewardPercentage","outputs":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"timerAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"tokenCurrency","outputs":[{"internalType":"contract ExpandedIERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalPositionCollateral","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"totalCollateral","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalTokensOutstanding","outputs":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"collateralAmount","type":"tuple"}],"name":"withdraw","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"amountWithdrawn","type":"tuple"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"liquidationId","type":"uint256"},{"internalType":"address","name":"sponsor","type":"address"}],"name":"withdrawLiquidation","outputs":[{"components":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"payToSponsor","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"payToLiquidator","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"payToDisputer","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"paidToSponsor","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"paidToLiquidator","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"paidToDisputer","type":"tuple"}],"internalType":"struct PerpetualLiquidatable.RewardsData","name":"","type":"tuple"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"withdrawPassedRequest","outputs":[{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"amountWithdrawn","type":"tuple"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"withdrawalLiveness","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]', 'Perpetual');class Perpetual extends _i1.GeneratedContract {Perpetual({required _i1.EthereumAddress address, required _i1.Web3Client client, int? chainId}) : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> applyFundingRate({required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('applyFundingRate');
final params = [];
return  write(credentials, transaction, function, params); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> cancelWithdrawal({required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('cancelWithdrawal');
final params = [];
return  write(credentials, transaction, function, params); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> collateralCurrency({_i1.BlockNum? atBlock}) async  { final function = self.function('collateralCurrency');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> collateralRequirement({_i1.BlockNum? atBlock}) async  { final function = self.function('collateralRequirement');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> configStore({_i1.BlockNum? atBlock}) async  { final function = self.function('configStore');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// This contract must have the Minter role for the `tokenCurrency`.Reverts if minting these tokens would put the position's collateralization ratio below the global collateralization ratio. This contract must be approved to spend at least `collateralAmount` of `collateralCurrency`.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> create(dynamic collateralAmount, dynamic numTokens, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('create');
final params = [collateralAmount, numTokens];
return  write(credentials, transaction, function, params); } 
/// This method generates an ID that will uniquely identify liquidation for the sponsor. This contract must be approved to spend at least `tokensLiquidated` of `tokenCurrency` and at least `finalFeeBond` of `collateralCurrency`.This contract must have the Burner role for the `tokenCurrency`.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> createLiquidation(_i1.EthereumAddress sponsor, dynamic minCollateralPerToken, dynamic maxCollateralPerToken, dynamic maxTokensToLiquidate, BigInt deadline, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('createLiquidation');
final params = [sponsor, minCollateralPerToken, maxCollateralPerToken, maxTokensToLiquidate, deadline];
return  write(credentials, transaction, function, params); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> cumulativeFeeMultiplier({_i1.BlockNum? atBlock}) async  { final function = self.function('cumulativeFeeMultiplier');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// Increases the collateralization level of a position after creation. This contract must be approved to spend at least `collateralAmount` of `collateralCurrency`.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> deposit(dynamic collateralAmount, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('deposit');
final params = [collateralAmount];
return  write(credentials, transaction, function, params); } 
/// Increases the collateralization level of a position after creation. This contract must be approved to spend at least `collateralAmount` of `collateralCurrency`.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> depositTo(_i1.EthereumAddress sponsor, dynamic collateralAmount, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('depositTo');
final params = [sponsor, collateralAmount];
return  write(credentials, transaction, function, params); } 
/// Can only dispute a liquidation before the liquidation expires and if there are no other pending disputes. This contract must be approved to spend at least the dispute bond amount of `collateralCurrency`. This dispute bond amount is calculated from `disputeBondPercentage` times the collateral in the liquidation.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> dispute(BigInt liquidationId, _i1.EthereumAddress sponsor, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('dispute');
final params = [liquidationId, sponsor];
return  write(credentials, transaction, function, params); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> disputeBondPercentage({_i1.BlockNum? atBlock}) async  { final function = self.function('disputeBondPercentage');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> disputerDisputeRewardPercentage({_i1.BlockNum? atBlock}) async  { final function = self.function('disputerDisputeRewardPercentage');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// Only the governor can call this function as they are permissioned within the `FinancialContractAdmin`. Upon emergency shutdown, the contract settlement time is set to the shutdown time. This enables withdrawal to occur via the `settleEmergencyShutdown` function.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> emergencyShutdown({required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('emergencyShutdown');
final params = [];
return  write(credentials, transaction, function, params); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> emergencyShutdownPrice({_i1.BlockNum? atBlock}) async  { final function = self.function('emergencyShutdownPrice');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> emergencyShutdownTimestamp({_i1.BlockNum? atBlock}) async  { final function = self.function('emergencyShutdownTimestamp');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> finder({_i1.BlockNum? atBlock}) async  { final function = self.function('finder');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<FundingRate> fundingRate({_i1.BlockNum? atBlock}) async  { final function = self.function('fundingRate');
final params = [];
final response =  await read(function, params, atBlock);
return  FundingRate(response); } 
/// This is necessary because the struct returned by the positions() method shows rawCollateral, which isn't a user-readable value.This method accounts for pending regular fees that have not yet been withdrawn from this contract, for example if the `lastPaymentTime != currentTime`.
///
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<dynamic> getCollateral(_i1.EthereumAddress sponsor, {_i1.BlockNum? atBlock}) async  { final function = self.function('getCollateral');
final params = [sponsor];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as dynamic); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> getCurrentTime({_i1.BlockNum? atBlock}) async  { final function = self.function('getCurrentTime');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<dynamic> getFundingRateAppliedTokenDebt(dynamic rawTokenDebt, {_i1.BlockNum? atBlock}) async  { final function = self.function('getFundingRateAppliedTokenDebt');
final params = [rawTokenDebt];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as dynamic); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<List<dynamic>> getLiquidations(_i1.EthereumAddress sponsor, {_i1.BlockNum? atBlock}) async  { final function = self.function('getLiquidations');
final params = [sponsor];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as List<dynamic>).cast<dynamic>(); } 
/// This returns 0 and exit early if there is no pfc, fees were already paid during the current block, or the fee rate is 0.
///
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<GetOutstandingRegularFees> getOutstandingRegularFees(BigInt time, {_i1.BlockNum? atBlock}) async  { final function = self.function('getOutstandingRegularFees');
final params = [time];
final response =  await read(function, params, atBlock);
return  GetOutstandingRegularFees(response); } 
/// Multiplying the `cumulativeFeeMultiplier` by the ratio of non-PfC-collateral :: PfC-collateral effectively pays all sponsors a pro-rata portion of the excess collateral.This will revert if PfC is 0 and this contract's collateral balance > 0.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> gulp({required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('gulp');
final params = [];
return  write(credentials, transaction, function, params); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> liquidationLiveness({_i1.BlockNum? atBlock}) async  { final function = self.function('liquidationLiveness');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<Liquidations> liquidations(_i1.EthereumAddress , BigInt , {_i1.BlockNum? atBlock}) async  { final function = self.function('liquidations');
final params = [, ];
final response =  await read(function, params, atBlock);
return  Liquidations(response); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> minSponsorTokens({_i1.BlockNum? atBlock}) async  { final function = self.function('minSponsorTokens');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// These must be paid periodically for the life of the contract. If the contract has not paid its regular fee in a week or more then a late penalty is applied which is sent to the caller. If the amount of fees owed are greater than the pfc, then this will pay as much as possible from the available collateral. An event is only fired if the fees charged are greater than 0.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> payRegularFees({required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('payRegularFees');
final params = [];
return  write(credentials, transaction, function, params); } 
/// This is equivalent to the collateral pool available from which to pay fees. Therefore, derived contracts are expected to implement this so that pay-fee methods can correctly compute the owed fees as a % of PfC.
///
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<dynamic> pfc({_i1.BlockNum? atBlock}) async  { final function = self.function('pfc');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as dynamic); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<Positions> positions(_i1.EthereumAddress , {_i1.BlockNum? atBlock}) async  { final function = self.function('positions');
final params = [];
final response =  await read(function, params, atBlock);
return  Positions(response); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i2.Uint8List> priceIdentifier({_i1.BlockNum? atBlock}) async  { final function = self.function('priceIdentifier');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i2.Uint8List); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> proposeFundingRate(dynamic rate, BigInt timestamp, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('proposeFundingRate');
final params = [rate, timestamp];
return  write(credentials, transaction, function, params); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> rawLiquidationCollateral({_i1.BlockNum? atBlock}) async  { final function = self.function('rawLiquidationCollateral');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> rawTotalPositionCollateral({_i1.BlockNum? atBlock}) async  { final function = self.function('rawTotalPositionCollateral');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// Can only be called by a token sponsor. Might not redeem the full proportional amount of collateral in order to account for precision loss. This contract must be approved to spend at least `numTokens` of `tokenCurrency`.This contract must have the Burner role for the `tokenCurrency`.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> redeem(dynamic numTokens, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('redeem');
final params = [numTokens];
return  write(credentials, transaction, function, params); } 
/// This is supposed to be implemented by any contract that inherits `AdministrateeInterface` and callable only by the Governor contract. This method is therefore minimally implemented in this contract and does nothing.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> remargin({required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('remargin');
final params = [];
return  write(credentials, transaction, function, params); } 
/// Can only be called by token sponsor. This contract must be approved to spend `numTokens` of `tokenCurrency`.This contract must have the Burner role for the `tokenCurrency`.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> repay(dynamic numTokens, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('repay');
final params = [numTokens];
return  write(credentials, transaction, function, params); } 
/// The request will be pending for `withdrawalLiveness`, during which the position can be liquidated.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> requestWithdrawal(dynamic collateralAmount, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('requestWithdrawal');
final params = [collateralAmount];
return  write(credentials, transaction, function, params); } 
/// Will revert if not running in test mode.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> setCurrentTime(BigInt time, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('setCurrentTime');
final params = [time];
return  write(credentials, transaction, function, params); } 
/// This burns all tokens from the caller of `tokenCurrency` and sends back the resolved settlement value of `collateralCurrency`. Might not redeem the full proportional amount of collateral in order to account for precision loss. This contract must be approved to spend `tokenCurrency` at least up to the caller's full balance.This contract must have the Burner role for the `tokenCurrency`.Note that this function does not call the updateFundingRate modifier to update the funding rate as this function is only called after an emergency shutdown & there should be no funding rate updates after the shutdown.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> settleEmergencyShutdown({required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('settleEmergencyShutdown');
final params = [];
return  write(credentials, transaction, function, params); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> sponsorDisputeRewardPercentage({_i1.BlockNum? atBlock}) async  { final function = self.function('sponsorDisputeRewardPercentage');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> timerAddress({_i1.BlockNum? atBlock}) async  { final function = self.function('timerAddress');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> tokenCurrency({_i1.BlockNum? atBlock}) async  { final function = self.function('tokenCurrency');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<dynamic> totalPositionCollateral({_i1.BlockNum? atBlock}) async  { final function = self.function('totalPositionCollateral');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as dynamic); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> totalTokensOutstanding({_i1.BlockNum? atBlock}) async  { final function = self.function('totalTokensOutstanding');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// Reverts if the withdrawal puts this position's collateralization ratio below the global collateralization ratio. In that case, use `requestWithdrawal`. Might not withdraw the full requested amount to account for precision loss.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> withdraw(dynamic collateralAmount, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('withdraw');
final params = [collateralAmount];
return  write(credentials, transaction, function, params); } 
/// If the dispute SUCCEEDED: the sponsor, liquidator, and disputer are eligible for payment. If the dispute FAILED: only the liquidator receives payment. This method deletes the liquidation data. This method will revert if rewards have already been dispersed.
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> withdrawLiquidation(BigInt liquidationId, _i1.EthereumAddress sponsor, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('withdrawLiquidation');
final params = [liquidationId, sponsor];
return  write(credentials, transaction, function, params); } 
/// Might not withdraw the full requested amount in order to account for precision loss or if the full requested amount exceeds the collateral in the position (due to paying fees).
///
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> withdrawPassedRequest({required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('withdrawPassedRequest');
final params = [];
return  write(credentials, transaction, function, params); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> withdrawalLiveness({_i1.BlockNum? atBlock}) async  { final function = self.function('withdrawalLiveness');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// Returns a live stream of all Deposit events emitted by this contract.
Stream<Deposit> depositEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('Deposit');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  Deposit(decoded); } ); } 
/// Returns a live stream of all DisputeSettled events emitted by this contract.
Stream<DisputeSettled> disputeSettledEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('DisputeSettled');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  DisputeSettled(decoded); } ); } 
/// Returns a live stream of all EmergencyShutdown events emitted by this contract.
Stream<EmergencyShutdown> emergencyShutdownEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('EmergencyShutdown');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  EmergencyShutdown(decoded); } ); } 
/// Returns a live stream of all EndedSponsorPosition events emitted by this contract.
Stream<EndedSponsorPosition> endedSponsorPositionEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('EndedSponsorPosition');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  EndedSponsorPosition(decoded); } ); } 
/// Returns a live stream of all FinalFeesPaid events emitted by this contract.
Stream<FinalFeesPaid> finalFeesPaidEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('FinalFeesPaid');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  FinalFeesPaid(decoded); } ); } 
/// Returns a live stream of all FundingRateUpdated events emitted by this contract.
Stream<FundingRateUpdated> fundingRateUpdatedEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('FundingRateUpdated');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  FundingRateUpdated(decoded); } ); } 
/// Returns a live stream of all LiquidationCreated events emitted by this contract.
Stream<LiquidationCreated> liquidationCreatedEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('LiquidationCreated');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  LiquidationCreated(decoded); } ); } 
/// Returns a live stream of all LiquidationDisputed events emitted by this contract.
Stream<LiquidationDisputed> liquidationDisputedEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('LiquidationDisputed');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  LiquidationDisputed(decoded); } ); } 
/// Returns a live stream of all LiquidationWithdrawn events emitted by this contract.
Stream<LiquidationWithdrawn> liquidationWithdrawnEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('LiquidationWithdrawn');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  LiquidationWithdrawn(decoded); } ); } 
/// Returns a live stream of all NewSponsor events emitted by this contract.
Stream<NewSponsor> newSponsorEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('NewSponsor');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  NewSponsor(decoded); } ); } 
/// Returns a live stream of all PositionCreated events emitted by this contract.
Stream<PositionCreated> positionCreatedEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('PositionCreated');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  PositionCreated(decoded); } ); } 
/// Returns a live stream of all Redeem events emitted by this contract.
Stream<Redeem> redeemEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('Redeem');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  Redeem(decoded); } ); } 
/// Returns a live stream of all RegularFeesPaid events emitted by this contract.
Stream<RegularFeesPaid> regularFeesPaidEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('RegularFeesPaid');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  RegularFeesPaid(decoded); } ); } 
/// Returns a live stream of all Repay events emitted by this contract.
Stream<Repay> repayEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('Repay');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  Repay(decoded); } ); } 
/// Returns a live stream of all RequestWithdrawal events emitted by this contract.
Stream<RequestWithdrawal> requestWithdrawalEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('RequestWithdrawal');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  RequestWithdrawal(decoded); } ); } 
/// Returns a live stream of all RequestWithdrawalCanceled events emitted by this contract.
Stream<RequestWithdrawalCanceled> requestWithdrawalCanceledEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('RequestWithdrawalCanceled');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  RequestWithdrawalCanceled(decoded); } ); } 
/// Returns a live stream of all RequestWithdrawalExecuted events emitted by this contract.
Stream<RequestWithdrawalExecuted> requestWithdrawalExecutedEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('RequestWithdrawalExecuted');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  RequestWithdrawalExecuted(decoded); } ); } 
/// Returns a live stream of all SettleEmergencyShutdown events emitted by this contract.
Stream<SettleEmergencyShutdown> settleEmergencyShutdownEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('SettleEmergencyShutdown');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  SettleEmergencyShutdown(decoded); } ); } 
/// Returns a live stream of all Withdrawal events emitted by this contract.
Stream<Withdrawal> withdrawalEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('Withdrawal');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  Withdrawal(decoded); } ); } 
 }
class FundingRate {FundingRate(List<dynamic> response) : rate = (response[0] as dynamic), identifier = (response[1] as _i2.Uint8List), cumulativeMultiplier = (response[2] as dynamic), updateTime = (response[3] as BigInt), applicationTime = (response[4] as BigInt), proposalTime = (response[5] as BigInt);

final dynamic rate;

final _i2.Uint8List identifier;

final dynamic cumulativeMultiplier;

final BigInt updateTime;

final BigInt applicationTime;

final BigInt proposalTime;

 }
class GetOutstandingRegularFees {GetOutstandingRegularFees(List<dynamic> response) : regularFee = (response[0] as dynamic), latePenalty = (response[1] as dynamic), totalPaid = (response[2] as dynamic);

final dynamic regularFee;

final dynamic latePenalty;

final dynamic totalPaid;

 }
class Liquidations {Liquidations(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), liquidator = (response[1] as _i1.EthereumAddress), state = (response[2] as BigInt), liquidationTime = (response[3] as BigInt), tokensOutstanding = (response[4] as dynamic), lockedCollateral = (response[5] as dynamic), liquidatedCollateral = (response[6] as dynamic), rawUnitCollateral = (response[7] as dynamic), disputer = (response[8] as _i1.EthereumAddress), settlementPrice = (response[9] as dynamic), finalFee = (response[10] as dynamic);

final _i1.EthereumAddress sponsor;

final _i1.EthereumAddress liquidator;

final BigInt state;

final BigInt liquidationTime;

final dynamic tokensOutstanding;

final dynamic lockedCollateral;

final dynamic liquidatedCollateral;

final dynamic rawUnitCollateral;

final _i1.EthereumAddress disputer;

final dynamic settlementPrice;

final dynamic finalFee;

 }
class Positions {Positions(List<dynamic> response) : tokensOutstanding = (response[0] as dynamic), withdrawalRequestPassTimestamp = (response[1] as BigInt), withdrawalRequestAmount = (response[2] as dynamic), rawCollateral = (response[3] as dynamic);

final dynamic tokensOutstanding;

final BigInt withdrawalRequestPassTimestamp;

final dynamic withdrawalRequestAmount;

final dynamic rawCollateral;

 }
class Deposit {Deposit(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), collateralAmount = (response[1] as BigInt);

final _i1.EthereumAddress sponsor;

final BigInt collateralAmount;

 }
class DisputeSettled {DisputeSettled(List<dynamic> response) : caller = (response[0] as _i1.EthereumAddress), sponsor = (response[1] as _i1.EthereumAddress), liquidator = (response[2] as _i1.EthereumAddress), disputer = (response[3] as _i1.EthereumAddress), liquidationId = (response[4] as BigInt), disputeSucceeded = (response[5] as bool);

final _i1.EthereumAddress caller;

final _i1.EthereumAddress sponsor;

final _i1.EthereumAddress liquidator;

final _i1.EthereumAddress disputer;

final BigInt liquidationId;

final bool disputeSucceeded;

 }
class EmergencyShutdown {EmergencyShutdown(List<dynamic> response) : caller = (response[0] as _i1.EthereumAddress), shutdownTimestamp = (response[1] as BigInt);

final _i1.EthereumAddress caller;

final BigInt shutdownTimestamp;

 }
class EndedSponsorPosition {EndedSponsorPosition(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress);

final _i1.EthereumAddress sponsor;

 }
class FinalFeesPaid {FinalFeesPaid(List<dynamic> response) : amount = (response[0] as BigInt);

final BigInt amount;

 }
class FundingRateUpdated {FundingRateUpdated(List<dynamic> response) : newFundingRate = (response[0] as BigInt), updateTime = (response[1] as BigInt), reward = (response[2] as BigInt);

final BigInt newFundingRate;

final BigInt updateTime;

final BigInt reward;

 }
class LiquidationCreated {LiquidationCreated(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), liquidator = (response[1] as _i1.EthereumAddress), liquidationId = (response[2] as BigInt), tokensOutstanding = (response[3] as BigInt), lockedCollateral = (response[4] as BigInt), liquidatedCollateral = (response[5] as BigInt), liquidationTime = (response[6] as BigInt);

final _i1.EthereumAddress sponsor;

final _i1.EthereumAddress liquidator;

final BigInt liquidationId;

final BigInt tokensOutstanding;

final BigInt lockedCollateral;

final BigInt liquidatedCollateral;

final BigInt liquidationTime;

 }
class LiquidationDisputed {LiquidationDisputed(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), liquidator = (response[1] as _i1.EthereumAddress), disputer = (response[2] as _i1.EthereumAddress), liquidationId = (response[3] as BigInt), disputeBondAmount = (response[4] as BigInt);

final _i1.EthereumAddress sponsor;

final _i1.EthereumAddress liquidator;

final _i1.EthereumAddress disputer;

final BigInt liquidationId;

final BigInt disputeBondAmount;

 }
class LiquidationWithdrawn {LiquidationWithdrawn(List<dynamic> response) : caller = (response[0] as _i1.EthereumAddress), paidToLiquidator = (response[1] as BigInt), paidToDisputer = (response[2] as BigInt), paidToSponsor = (response[3] as BigInt), liquidationStatus = (response[4] as BigInt), settlementPrice = (response[5] as BigInt);

final _i1.EthereumAddress caller;

final BigInt paidToLiquidator;

final BigInt paidToDisputer;

final BigInt paidToSponsor;

final BigInt liquidationStatus;

final BigInt settlementPrice;

 }
class NewSponsor {NewSponsor(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress);

final _i1.EthereumAddress sponsor;

 }
class PositionCreated {PositionCreated(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), collateralAmount = (response[1] as BigInt), tokenAmount = (response[2] as BigInt);

final _i1.EthereumAddress sponsor;

final BigInt collateralAmount;

final BigInt tokenAmount;

 }
class Redeem {Redeem(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), collateralAmount = (response[1] as BigInt), tokenAmount = (response[2] as BigInt);

final _i1.EthereumAddress sponsor;

final BigInt collateralAmount;

final BigInt tokenAmount;

 }
class RegularFeesPaid {RegularFeesPaid(List<dynamic> response) : regularFee = (response[0] as BigInt), lateFee = (response[1] as BigInt);

final BigInt regularFee;

final BigInt lateFee;

 }
class Repay {Repay(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), numTokensRepaid = (response[1] as BigInt), newTokenCount = (response[2] as BigInt);

final _i1.EthereumAddress sponsor;

final BigInt numTokensRepaid;

final BigInt newTokenCount;

 }
class RequestWithdrawal {RequestWithdrawal(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), collateralAmount = (response[1] as BigInt);

final _i1.EthereumAddress sponsor;

final BigInt collateralAmount;

 }
class RequestWithdrawalCanceled {RequestWithdrawalCanceled(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), collateralAmount = (response[1] as BigInt);

final _i1.EthereumAddress sponsor;

final BigInt collateralAmount;

 }
class RequestWithdrawalExecuted {RequestWithdrawalExecuted(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), collateralAmount = (response[1] as BigInt);

final _i1.EthereumAddress sponsor;

final BigInt collateralAmount;

 }
class SettleEmergencyShutdown {SettleEmergencyShutdown(List<dynamic> response) : caller = (response[0] as _i1.EthereumAddress), collateralReturned = (response[1] as BigInt), tokensBurned = (response[2] as BigInt);

final _i1.EthereumAddress caller;

final BigInt collateralReturned;

final BigInt tokensBurned;

 }
class Withdrawal {Withdrawal(List<dynamic> response) : sponsor = (response[0] as _i1.EthereumAddress), collateralAmount = (response[1] as BigInt);

final _i1.EthereumAddress sponsor;

final BigInt collateralAmount;

 }
