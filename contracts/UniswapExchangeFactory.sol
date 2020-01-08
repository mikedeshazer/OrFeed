pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol";


/// @title Factory Contract for creating Uniswap Market for Tokens
/// @author Manank Patni
/// @notice The contract creates a uniswap factory taking token as input and also add inital liquidity

/// @dev Interface for ERC20 Token
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

/// @dev Interface for Uniswap Factory Contract
interface UniswapFactoryInterface {
    function createExchange(address token) external returns (address exchange);
    function getExchange(address token) external view returns (address exchange);
    function getToken(address exchange) external view returns (address token);
    function getTokenWithId(uint256 tokenId) external view returns (address token);
}

/// @dev Interface for Uniswap Exchange Created
interface UniswapExchangeInterface {
    function tokenAddress() external view returns (address token);
    function factoryAddress() external view returns (address factory);
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
}

/// @dev Main Factory contract with creation and liquidity logic
contract ExchangeFactory is Ownable{
    address public uniswapfactory;
    address public myexchange;
    address public erctoken;
    
    /// @dev Provide Uniswap Factory Contract on Deployment
    constructor(address _uniswapaddress) public {
        uniswapfactory = _uniswapaddress;
    }
    
    /// @dev Change Uniswap factory contract address. Only Owner can perform action.
    function change_factory(address _uniswapfactory) public onlyOwner returns(bool){
        uniswapfactory = _uniswapfactory;
        return true;
    }
    
    /// @dev Get Exchange Address using the Token Address
    function getExchangefromToken(address _erctoken) public view returns(address) {
        address _exchange;
        UniswapFactoryInterface unifactory = UniswapFactoryInterface(uniswapfactory);
        _exchange = unifactory.getExchange(_erctoken);
    }
    
    /// @dev Generate exchange for the token given
    function create(address token) public returns(address) {
        UniswapFactoryInterface unifactory = UniswapFactoryInterface(uniswapfactory);
        erctoken = token;
        myexchange = unifactory.createExchange(token);
        return myexchange;
    }
    
    /// @dev Add initial liquidity to the exchange. Payable function. Token should be approved. 
    function addliquidity(uint256 tokens) payable public {
        address self = address(this);
        ERC20Interface tokeninterface = ERC20Interface(erctoken);
        tokeninterface.approve(myexchange, 2**256 - 1);
        tokeninterface.transferFrom(msg.sender,self, tokens);
        UniswapExchangeInterface exchangeinter = UniswapExchangeInterface(myexchange);
        exchangeinter.addLiquidity.value(msg.value)(0, tokens, block.timestamp + 3000);
    }
}
