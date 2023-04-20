//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract vendingmachine{
    address public owner;
    mapping(address=>uint) public donutBalances;

    constructor(){
        owner=msg.sender;
        donutBalances[address(this)]=100;
    }
    function getVendingMachineBalance() public view returns(uint){
        return donutBalances[address(this)];
    }
    function restock(uint amount) public {
        require(owner==msg.sender,"only owner can call this");
        donutBalances[address(this)]+=amount;
    }
    function purchase(uint amount ) public payable{
        require(msg.value >= amount * 2 ether, "you must pay atleast 2 ether");
        require(donutBalances[address(this)]>=amount,"not enough donuts left");
        donutBalances[address(this)]-=amount;
        donutBalances[msg.sender]+=amount;
    }
}