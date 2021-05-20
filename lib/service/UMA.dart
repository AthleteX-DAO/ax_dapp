import 'package:web3dart/web3dart.dart';
import 'package:ae_dapp/service/Controller.dart';

class UMA {
  // Uma Specific declarations
  DeployedContract empCreator,
      registry,
      identifierWhitelist,
      collateralTokenWhitelist,
      collateralToken,
      timer;
  Controller controller;

  UMA() {
    initUMAProtocol();
  }

  initUMAProtocol() async {
    empCreator = await controller.retrieveContract("ExpiringMultiPartyCreator");
    registry = await controller.retrieveContract("Registry");
    identifierWhitelist =
        await controller.retrieveContract("IdentifierWhiteList");
    collateralTokenWhitelist =
        await controller.retrieveContract("AddressWhitelist");
    collateralToken = await controller.retrieveContract("TestnetERC20");
    timer = await controller.retrieveContract("Timer");
  }

  // Creating tokens
  Future<void> createAthleteTokenContract() async {
    ContractFunction createEMP =
        empCreator.function("createExpiringMultiParty");
    Map<String, dynamic> params = constructorParams();
    Transaction.callContract(
        contract: empCreator, function: createEMP, parameters: [params]);
  }

  constructorParams() {
    String expirationTimestamp,
        collateralAddress,
        priceFeedIdentifier,
        syntheticName,
        syntheticSymbol,
        timerAddress;
    String financialProductLibraryAddress =
        '0x0000000000000000000000000000000000000000';
    EtherAmount rawValue;
    Map<String, EtherAmount> collateralRequirement,
        disputeBondPercentage,
        sponsorDisputeRewardPercentage,
        disputerDisputeRewardPercentage;
    int withdrawalLiveness, liquidationLiveness;
    Map<String, dynamic> params, minSponsorTokens;

    params = {
      expirationTimestamp: "",
      collateralAddress: "",
      priceFeedIdentifier: ""
    };
    return params;
  }
}
