// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./FundContract.sol";
import "./ERC20Token.sol";
//0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e


contract CrowdFunding is ERC20Token{
    /* State Variables*/
    struct fundingDetails{
        string fundingName;
        uint256 fundingGoalValue;
        address fundingAddress;
    }
    struct funding{
        FundContract Name;
        address ContractAddress;
        string ContractName;
    }
    uint256 public count=0;
    address public add;
    ERC20Token token;
    address public priceFeed;

    fundingDetails[] public fundMe;     //fundingDetails 
    // FundContract[] public NewFund;      //createing new fund contract 
    funding[] public NewFund; 

    mapping(string => address) public ContractFund;


    constructor(uint256 initalSupply,
        string memory TokenName,
        string memory TokenSYM,
        uint256 cap,
        uint256 reawrd,
        address _priceFeed
        ) 

        ERC20Token(initalSupply,
        TokenName,
        TokenSYM,
        cap,
        reawrd){
            _mint(address(this),initalSupply);
            token = ERC20Token(TokenAddress);
            priceFeed=_priceFeed;

    }
    function NewFundContract(string memory ContractName,uint value,uint256 _Duration) public OnlyOwner{

        string memory name= ContractName;
        uint256 Duration=_Duration;
        new FundContract(ContractName,i_owner,TokenAddress,Duration,priceFeed);
        NewFund.push(funding(new FundContract(
            ContractName,
            i_owner,TokenAddress,Duration,priceFeed),
            address(new FundContract(
                ContractName,
                i_owner,
                TokenAddress,
                Duration,
                priceFeed
                )),ContractName));
        ContractFund[name]= address(new FundContract(ContractName,i_owner,TokenAddress,Duration,priceFeed));
        // approve(payable(address(new FundContract(ContractName,i_owner,TokenAddress))),value);
        // approve(address(new FundContract(ContractName,i_owner,TokenAddress)),value);
        // transferFrom(address(this),(address(new FundContract(ContractName,i_owner,TokenAddress))),value);
        add=address(NewFund[count].Name);
        transfer(address(NewFund[count].Name),value);
        count=count+1;
    }
}
