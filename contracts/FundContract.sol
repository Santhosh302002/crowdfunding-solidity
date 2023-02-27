
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "./ERC20Token.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e

contract FundContract is AggregatorV3Interface {
    string public ContractName;
    address public Owner;
    address public contractAddress;
    uint256 public erc20balance;
    address public con;
    uint256 public startTimestamp;
    uint256 public duration;

    struct funder {
        address FunderAddress;
        uint256 FundingAmount;
    }
    ERC20Token token;
    AggregatorV3Interface priceFeed;

    constructor(
        string memory name,
        address _Owner,
        address _token,
        uint256 _duration,
        address _priceFeed
    ) // address contractAddress
    {
        ContractName = name;
        Owner = _Owner;
        token = ERC20Token(_token);
        con = _token;
        startTimestamp = block.timestamp;
        priceFeed = AggregatorV3Interface(_priceFeed);
        duration = _duration;
    }

    // ERC20Token token = ERC20Token(contractAddress);
    function pay() public payable {
        require(block.timestamp - startTimestamp < duration, "Time Over for the funding");
        funding.push(funder(msg.sender, msg.value));
        token.transfer(msg.sender, msg.value);
    }

    function erc20token() public {
        erc20balance = token.balanceOf(address(this));
    }

    funder[] public funding;

    function totalValue() public view returns (uint256) {
        return address(this).balance;
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == Owner, "You Don't have Access to WithDraw");
        payable(Owner).transfer(amount);
    }

    function getLatestPrice() public view returns (uint256) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        // return price;
        return uint256(price * 10000000000);
    }

    function calculateUSD(uint256 ethAmount) public returns (uint256) {
        uint256 price = uint256(getLatestPrice());
        // uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (price * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }

    function decimals() external view override returns (uint8) {}

    function description() external view override returns (string memory) {}

    function version() external view override returns (uint256) {}

    function getRoundData(
        uint80 _roundId
    )
        external
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {}

    function latestRoundData()
        external
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {}
}