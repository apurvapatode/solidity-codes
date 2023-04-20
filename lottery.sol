// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address payable[] public players; 
    uint public minimumBet; 

    constructor(uint _minimumBet) {
        manager = msg.sender;
        minimumBet = _minimumBet;
    }

    function enter() public payable {
        require(msg.value >= minimumBet, "Minimum bet amount not met.");
        players.push(payable(msg.sender));
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public restricted {
        require(players.length > 0, "No players have entered the lottery.");
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0); 
    }

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can pick a winner.");
        _;
    }
}
