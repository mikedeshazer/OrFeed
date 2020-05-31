//Draft: Gas retail contract for buying, storing and selling gas token at set rates, as well as deploying gas as a proxy contract

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

interface ERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function symbol() external view returns (string memory);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


interface ERC20GasToken {
    function name (  ) external view returns ( string );
  function freeFromUpTo ( address from, uint256 value ) external returns ( uint256 freed );
  function approve ( address spender, uint256 value ) external returns ( bool success );
  function totalSupply (  ) external view returns ( uint256 supply );
  function transferFrom ( address from, address to, uint256 value ) external returns ( bool success );
  function decimals (  ) external view returns ( uint8 );
  function freeFrom ( address from, uint256 value ) external returns ( bool success );
  function freeUpTo ( uint256 value ) external returns ( uint256 freed );
  function balanceOf ( address owner ) external view returns ( uint256 balance );
  function symbol (  ) external view returns ( string );
  function mint ( uint256 value ) external;
  function transfer ( address to, uint256 value ) external returns ( bool success );
  function free ( uint256 value ) external returns ( bool success );
  function allowance ( address owner, address spender ) external view returns ( uint256 remaining );
}


interface OrFeedInterface {
  function getExchangeRate ( string calldata fromSymbol, string calldata  toSymbol, string calldata venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string calldata  symbol ) external view returns ( address );
  function getSynthBytes32 ( string calldata  symbol ) external view returns ( bytes32 );
  function getForexAddress ( string calldata symbol ) external view returns ( address );
  function arb(address  fundsReturnToAddress,  address liquidityProviderContractAddress, string[] calldata   tokens,  uint256 amount, string[] calldata  exchanges) external payable returns (bool);
}

contract GasRetailContract {
    using SafeMath
    for uint256;
 
    OrFeedInterface orfeed= OrFeedInterface(0x8316B082621CFedAB95bf4a44a1d4B64a6ffc336);
    ERC20GasToken gasToken = ERC20GasToken(0x0000000000b3F879cb30FE243b4Dfee438691c04);
    uint8 public constant decimals = 2;
    uint256 public constant buyPrice = 2500; //25 gwei
    uint256 public constant sellPrice = 2000; //20 gwei
    address owner;
    mapping(address => uint256) balances;
    uint256 public constant thirdPartyStored =0;
    uint256 public constant totalSupply =0;
    
     // Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
            if (msg.sender != owner) {
                throw;
            }
             _;
    }

    
    constructor() public payable {
         owner = msg.sender;
    }

    function balanceOf(address _owner) public constant returns(uint256){
            return balances[_owner];
    }


    function setGasBuyPrice(uint256 newPrice) onlyOwner returns(bool){
        buyPrice = newPrice;
        return true;
    }

    function setGasSellPrice(uint256 newPrice) onlyOwner returns(bool){
        sellPrice = newPrice;
        return true;
    }

    function buyGas() payable public returns (bool){
        
        uint256 ethSent = msg.value;
        amountToSend = msg.value.mul(buyPrice).div(10000000000000000);
        require(gasToken.transfer(msg.sender, amountToSend), "This contract does not have enough gas token to fill your order");
        return true;
    }

    function sellGas(uint256 amount){
        uint256 amountToPay = amount.div(sellPrice).mul(amount);
        require(msg.send(msg.sender, amountToPay), "Not enough ETH in the contract to fill this order");
        return true;
    }

    function storeGas()public returns (bool){

        require(gasToken.transferFrom(msg.sender, this, amount ), "You must approve this contract at the following smart contract before buying: 0x0000000000b3F879cb30FE243b4Dfee438691c04");
        balances[msg.sender] = amount;
        thirdPartyStored = thirdPartyStored.add(amount);
        totalSupply = totalSupply.add(amount);
        return true;
    }

    function returnOwnerStoredGas(address tokenAddress, uint256 amount) onlyOwner public returns(bool){
       ERC20 tokenToWithdraw = ERC20(tokenAddress);
       tokenToWithdraw.transfer(owner, amount);
       return true;
    }

    function deployGas(address logic_contract) {
        gasToken.freeFromUpTo(msg.sender, balanceOf[msg.sender]);
         address target = logic_contract;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            let result := delegatecall(gas, target, ptr, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(ptr, 0, size)
            switch result
            case 0 { revert(ptr, size) }
            case 1 { return(ptr, size) }
        }
    }

    }



}