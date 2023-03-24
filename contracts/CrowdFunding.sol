// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./FundContract.sol";
import "./ERC20Token.sol";
//0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e


contract CrowdFunding is ERC20Token{
    /* State Variables*/
    struct funding{
        FundContract Name;
        address ContractAddress;
        string ContractName;
        uint256 duration;
        uint256 GoalAmount;
    }
    uint256 public count=0;
    ERC20Token token;
    address public priceFeed;
    address mainContractAddress;

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
            mainContractAddress=address(this);

    }
    function NewFundContract(
        string memory ContractName,
        uint value,
        uint256 _Duration,
        uint256 FundingGoal
        ) public OnlyOwner
            {

                string memory name= ContractName;
                uint256 Duration=_Duration;
                new FundContract(
                    ContractName,
                    i_owner,
                    TokenAddress,
                    Duration,
                    priceFeed,
                    FundingGoal,
                    mainContractAddress);
                NewFund.push(funding(new FundContract(
                            ContractName,
                            i_owner,
                            TokenAddress,
                            Duration,
                            priceFeed,
                            FundingGoal,
                            mainContractAddress),
                        address(new FundContract(
                            ContractName,
                            i_owner,
                            TokenAddress,
                            Duration,
                            priceFeed,
                            FundingGoal,
                            mainContractAddress)),
                            ContractName,
                            _Duration,
                            FundingGoal
                            )
                            );
        ContractFund[name]= address(new FundContract(ContractName,i_owner,TokenAddress,Duration,priceFeed,FundingGoal,mainContractAddress));
        _transfer(address(this),address(NewFund[count].Name),value);
        count=count+1;
    }


}

