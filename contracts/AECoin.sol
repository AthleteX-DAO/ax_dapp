pragma solidity ^0.7.1;

contract AECoin {
    uint balance;

    constructor() public {
        // init user account balance
        balance = 0;
    }

    function getBalance() view public returns(uint) {
        return balance;
    }

    function deposit(uint _d) public {
        balance += _d;
    }

    function withdraw(uint _w) public {
        
        require(balance != 0, "Balance cannot be negative!");
        balance -= _w;
    }
}