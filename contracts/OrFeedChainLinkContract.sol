pragma solidity ^0.4.24; 

import "https://github.com/smartcontractkit/chainlink/evm/contracts/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/evm/contracts/vendor/Ownable.sol";

contract OrFeedChainLinkContract is ChainlinkClient, Ownable {
    
     uint256 constant private ORACLE_PAYMENT = 1 * LINK;
     
    constructor() public Ownable() {
      setPublicChainlinkToken();
    }
    
    function getChainlinkTokenAddress() public view returns (address) {
         return chainlinkTokenAddress();
    }
    
    function totalBalance() public view returns (uint256){
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        return link.balanceOf(address(this));
    }
    
    function requestPriceResult(string fromSymbol, string toSymbol, string venue, uint256 amount) external returns (string) {
      return "";
    }

    function getRequestedPriceResult(string fromSymbol, string toSymbol, string venue, uint256 amount, string referenceId) external view
    returns (string){
      return "";
    }
    
}