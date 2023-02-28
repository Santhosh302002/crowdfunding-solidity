
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "./ERC20Token.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e


error CantWithDraw();

contract FundContract{

    string public ContractName;
    address public Owner;
    address public contractAddress;
    uint256 public erc20balance;
    address public con;
    uint256 public startTimestamp;
    uint256 public duration;
    uint256 public GoalAmount;

    struct funder{
        address FunderAddress;
        uint256 FundingAmount;
    }
    funder[] public funding;

    mapping(address=>uint256) public funderToAmount;
    mapping(address=>uint256) public funderToToken;

    ERC20Token token;
    AggregatorV3Interface public priceFeed;
    constructor (
        string memory name,
        address _Owner,
        address _token,
        uint256 _duration,
        address _priceFeed,
        uint256 _GoalAmount
        // address contractAddress
        ) 
        {
            ContractName=name;
            Owner=_Owner;
            token= ERC20Token(_token);
            con=_token;
            startTimestamp=block.timestamp;
            priceFeed= AggregatorV3Interface(_priceFeed);
            duration=_duration;
            GoalAmount=_GoalAmount;
        }
    function pay() public payable {
        require(block.timestamp - startTimestamp < duration,"Time Over for the funding");
        funding.push(funder(msg.sender,msg.value));
        token.transfer(msg.sender,calculateUSD(msg.value));
        funderToAmount[msg.sender]=msg.value;
        funderToToken[msg.sender]=calculateUSD(msg.value);
    }
    function erc20token() public{
        erc20balance = token.balanceOf(address(this));
    }


    function totalValue() public view returns(uint256){
        return address(this).balance;
    }
    function withdraw(uint256 amount) public {
        require(msg.sender==Owner, "You Don't have Access to WithDraw");
        payable(Owner).transfer(amount);
    }
    function getLatestPrice() public view returns(uint256) {
         (, int256 price, , , ) = priceFeed.latestRoundData();
        // return price;
        return uint256(price * 10000000000);
    }
    function calculateUSD(uint256 Amount) public returns(uint256){
        uint256 price= getLatestPrice();
        uint256 ethAmountInUsd = (price * Amount) / 1000000000000000000;
        return ethAmountInUsd;
    }
    function withdraw() public payable{
        if(block.timestamp - startTimestamp > duration && address(this).balance < GoalAmount){
            token.transfer(address(this),funderToAmount[msg.sender]);
           payable(msg.sender).transfer(funderToAmount[msg.sender]);
        } revert CantWithDraw();
    }
}