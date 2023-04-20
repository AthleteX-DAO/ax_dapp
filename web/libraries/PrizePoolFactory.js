const PrizePoolContractAbi = require('./prizepool.abi.json');

var PrizePoolFactory = ( function () {
    function PrizePoolFactory() {

    }

    // This function creates a pool contract, and then 
    PrizePoolFactory.prototype.createLeague = async function() {
        var eth = window.ethereum;
        const PrizePoolContract = await web3.eth.Contract(PrizePoolContractAbi);
        PrizePoolContract.deploy({
            arguments: ['']
        });


        return contractAddress; //Returns the address of the deployment
    }

     //This is to test the prizepoolfactory js is working
    PrizePoolFactory.prototype.hello = async function() {
        console.log('Hello World!');
    }
})();