const PrizePoolContractAbi = require('./prizepool.abi.json');

var PrizePoolFactory = ( function () {
    function PrizePoolFactory() {

    }

    // This function creates a pool contract, and then https://github.com/Riiz0/AX_PrizePool/blob/main/Prizepool.sol#L16
    PrizePoolFactory.prototype.createLeague = async function(_axToken, _entryFeeAmount, _leagueStartTime, _leagueEndTime) {
        var eth = window.ethereum;

        const PrizePoolContract = await web3.eth.Contract(PrizePoolContractAbi);

        // These arguments can be found here: 
        PrizePoolContract.deploy({
            arguments: ['_axToken']
        });


        return contractAddress; //Returns the address of the deployment
    }

     //This is to test the prizepoolfactory js is working
    PrizePoolFactory.prototype.hello = async function() {
        console.log('Hello World!');
    }
})();