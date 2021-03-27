pragma solidity ^0.5.16;

contract HelloWorld {
    // public fields
    string public yourName;

    constructor() public {
        yourName = "Unknown";
    }

    function setName(string memory _nm) public {
        yourName = _nm;
    }


}