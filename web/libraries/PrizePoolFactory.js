//import {PrizePoolContractAbi} from './prizepool.abi.json';

var PrizePoolFactory = ( function () {
    function PrizePoolFactory() {
        if (window.ethereum != null){
            this._web3 = new Web3(window.ethereum);
            //https://rpc.sx.technology/ 
        }
        
    }

    // This function creates a pool contract, and then https://github.com/Riiz0/AX_PrizePool/blob/main/Prizepool.sol#L16
    PrizePoolFactory.prototype.createLeague = async function(_axToken, _entryFeeAmount, _leagueStartTime, _leagueEndTime) {   
        const response = await fetch('./prizepool.abi.json');
        const json = await response.json();
        const PrizePoolContract = await this._web3.eth.Contract(json);
        // These arguments can be found here: 
        PrizePoolContract.deploy({
            arguments: ['_axToken', '_entryFeeAmount', '_leagueStartTime', '_leagueEndTime']
        });


        //return contractAddress; //Returns the address of the deployment
    }

     //This is to test the prizepoolfactory js is working
    PrizePoolFactory.prototype.hello = async function() {
        console.log('Hello World!');
    }
    return PrizePoolFactory;
})();