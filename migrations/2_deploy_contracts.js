const HelloWorld = artifacts.require("HelloWorld")
const AECoin = artifacts.require("AECoin");
module.exports = function (deployer) {
    deployer.deploy(AECoin);
    deployer.deploy(HelloWorld);
}