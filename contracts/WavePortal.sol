// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);
    
    struct Wave {
        address waver; // address of user
        string message; // message the user sent
        uint256 timeStamp; // timestamp when the user waved
    }

    // a variable of waves that lets me store an array of structs
    Wave[] waves;

    // add address here
    mapping(address => uint256) public lastWavedAt;
    
    constructor() payable {
        console.log("apes strong together");
    }

    // function
    function wave(string memory _message) public {
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        // add a new wave to the Waves array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // generate a psuedo random number
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);

        // set the generated, random number as the seed for the next wave
        seed = randomNumber;

        if (randomNumber < 50) {
            console.log("%s won!", msg.sender);

            // send some ether!
            uint256 prizeAmount = 0.0001 ether; // this is a variable that is a small amount of ether
            
            // require checks to see if the condition is true (otherwise exits the function)
            require (
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
        emit NewWave(msg.sender, block.timestamp, _message);     
    }           

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    // access object value
    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}