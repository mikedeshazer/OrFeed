pragma solidity ^0.5.0;

import "./Ownable.sol";
import "./IPriceFeed.sol";

contract PriceFeedProxy is Ownable {
	struct PFStruct {
		IPriceFeed _pf;
		string _pfName;
		address _pfOwner;
		bool _exists;
	}

	modifier onlyPriceFeedOwner(string memory provider) { 
		require (priceFeeds[provider]._pfOwner == msg.sender, 'Only PriceFeed owner can execute!'); 
		_; 
	}
	
	modifier existProvider(string memory provider) {
		require(priceFeeds[provider]._exists, 'Provider not found!');
		_;
	}

	modifier notExistProvider(string memory provider) {
		require(!priceFeeds[provider]._exists, 'Provider found!');
		_;
	}

	mapping(string => PFStruct) public priceFeeds;

	function getPriceInfo(string calldata provider, string calldata symbol) external view 
	existProvider(provider) returns(uint256, uint256, uint256) 
	{
		return priceFeeds[provider]._pf.getPriceInfo(symbol);
	}

	function addPriceFeed(string calldata provider, address addr) external 
	notExistProvider(provider) 
	{
		IPriceFeed priceFeed = IPriceFeed(addr);
		priceFeeds[provider] = PFStruct({_pf: priceFeed, _pfName: priceFeed.name(), _pfOwner: msg.sender, _exists: true});
	}

	function deletePriceFeed(string calldata provider) external 
	onlyPriceFeedOwner(provider) 
	{
		priceFeeds[provider]._exists = false;
	}

	function updatePriceFeedAddress(string calldata provider, address addr) external
	onlyPriceFeedOwner(provider) 
	{
		PFStruct storage priceFeed = priceFeeds[provider];
		priceFeed._pf = IPriceFeed(addr);
		priceFeed._pfName = priceFeed._pf.name();
	}

	function updatePriceFeedOwner(string calldata provider, address newOwner) external
	onlyPriceFeedOwner(provider)
	{
		priceFeeds[provider]._pfOwner = newOwner;
	}
}