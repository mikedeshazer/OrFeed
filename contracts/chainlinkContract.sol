pragma solidity ^0.4.26;

/*
    ERC20 Standard Token interface
*/
contract IERC20Token {
    // these functions aren't abstract since the compiler emits automatically generated getter functions as external
    function name() public view returns (string) {this;}
    function symbol() public view returns (string) {this;}
    function decimals() public view returns (uint8) {this;}
    function totalSupply() public view returns (uint256) {this;}
    function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
    function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}

    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
}

contract Chainlink {

    // mainnet link token contract
    //IERC20Token linkToken = IERC20Token("0x514910771af9ca656af840dff83e8264ecf986ca");

    // ropsten testnet link contract
    IERC20Token linkToken = IERC20Token("0x20fe562d797a42dcb3399062ae9546cd06f63280");

    function depositLink(uint256 linkTokens) external {
        require(linkToken.transferFrom(msg.sender, address(this), linkTokens), "Sender not authorized.");
    }

    function linkBalanceOf(address owner) external {
        return linkToken.balanceOf(owner);
    }

    function requestPriceResult(string fromSymbol, string toSymbol, string venue, uint256 amount) external {
      return "";
    }

    function getRequestedPriceResult(string fromSymbol, string toSymbol, string venue, uint256 amount, string referenceId) external view {
      return "";
    }

}