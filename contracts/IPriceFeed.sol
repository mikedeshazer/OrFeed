pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

interface IPriceFeed {
    function name() external view returns(string memory);
    function getPriceInfo(string calldata symbol) external view returns(uint256, uint256, uint256);
}