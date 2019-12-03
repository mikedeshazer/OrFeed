pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import './IERC20.sol';
import './IPriceFeed.sol';

contract PriceFeed is IPriceFeed, Ownable {
	struct Price {
		uint256 price;
		uint256 priceLastUpdate;
		uint256 priceTimesUpdate;
		bool _exists;
	}

    mapping(string => Price) public prices;
    string public priceFeedName;

    constructor(string memory _name) public {
    	priceFeedName = _name;
    }

    function getPriceInfo(string calldata symbol) external view returns(uint256, uint256, uint256) {
    	return (prices[symbol].price, prices[symbol].priceLastUpdate, prices[symbol].priceTimesUpdate);
    }
    
    function updatePrices(string[] calldata symbols, uint256[] calldata price) external onlyOwner {
    	require(symbols.length == price.length, 'Symbols are less than Prices or viceversa');      
        for(uint256 i = 0; i < symbols.length; i++) {
            prices[symbols[i]] = Price({price: price[i], priceLastUpdate: now, priceTimesUpdate: 1, _exists: true});
        }
    }
    
    function name() external view returns(string memory) {
    	return priceFeedName;
    }

    function withdraw(address _tokenAddress) public onlyOwner {
        msg.sender.transfer(address(this).balance);
        IERC20 token = IERC20(_tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        token.transfer(msg.sender, balance);
    }
}