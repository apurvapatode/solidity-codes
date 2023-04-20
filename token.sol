//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
contract Token{
    string public name;
    string public symbol;
    uint public decimals = 18;
    uint totalSupply;

    mapping(address=>uint) public balanceOf;
    mapping(address =>mapping(address=> uint)) public allowance;//video

    event Transfer(
        address indexed from,
        address indexed to,
        uint value
    );
    event Approval(
        address indexed owner,
        address indexed spender,
        uint value
    );
    constructor(
        string memory _name,
        string memory _symbol,
        uint _totalSupply
    ){
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply * (10**decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint _value) public returns(bool success){
        require(balanceOf[msg.sender]>=_value);
        _transfer(msg.sender, _to, _value);
        return true;
    }
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != address(0));
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from,_to,_value);
    }
    function approve(address _spender, uint _value) public returns(bool success){
        require(_spender!= address(0));
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender,_spender,_value);
        return true;
    }
    function transferFrom(address _from, address _to, uint _value) public returns(bool success){
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        allowance[_from][msg.sender]-=_value;
        _transfer(_from,_to,_value);
        return true;
    }
}