// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract ERC20Token is ERC20Capped , ERC20Burnable{
    /* State variables*/
    address  payable immutable i_owner;
    uint256 public immutable i_totalSupply;
    string public s_TokenName;
    string public s_TokenSYM;
    uint256 public  _cap;
    uint256 public blockReward;
    address public TokenAddress;

    constructor(
        uint256 initalSupply,
        string memory TokenName,
        string memory TokenSYM,
        uint256 cap,
        uint256 reawrd
        ) 
        ERC20(TokenName,TokenSYM) ERC20Capped(cap) {
        i_owner=payable(msg.sender);
        s_TokenName=TokenName;
        s_TokenSYM=TokenSYM;
        _cap=cap;
        blockReward=reawrd;
        i_totalSupply = initalSupply;
        _mint(msg.sender,initalSupply);
        TokenAddress=address(this);
    }
    
    function burn(uint256 amount) public virtual override OnlyOwner {
        _burn(_msgSender(), amount);
    }

    function _mintMinerRewards() internal{
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        if(from != address(0) && to != block.coinbase && to != address(0))
        {
            _mintMinerRewards();
        }
        super._beforeTokenTransfer(from,to,value);
    }

    function _mint(address account, uint256 amount) internal virtual override (ERC20Capped,ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }
    
    function _blockReward(uint256 reward) public OnlyOwner{
        blockReward=reward;
    }

    modifier OnlyOwner(){
        require(msg.sender==i_owner,"Your not the Owner of the contract");
        _;
    }
    

}