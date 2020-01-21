//Example: https://etherscan.io/address/0x9b80013caff912149525c1bc1d264939a1a573a7#readContract

pragma solidity >=0.4.26;
contract UniswapExchangeInterface {
    // Address of ERC20 token sold on this exchange
    function tokenAddress() external view returns (address token);
    // Address of Uniswap Factory
    function factoryAddress() external view returns (address factory);
    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
    // Get Prices
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
    // Trade ETH to ERC20
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
    // Trade ERC20 to ETH
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
    // Trade ERC20 to ERC20
    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
    // Trade ERC20 to Custom Pool
    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
    // ERC20 comaptibility for liquidity tokens
    bytes32 public name;
    bytes32 public symbol;
    uint256 public decimals;
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    // Never use
    function setup(address token_addr) external;
}

interface ERC20 {
    function totalSupply() external view returns (uint supply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    function decimals() external view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract IERC20Token {
    function name() public view returns (string memory) {this;}
    function symbol() public view returns (string memory) {this;}
    function decimals() public view returns (uint8) {this;}
    function totalSupply() public view returns (uint256) {this;}
    function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
    function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}

    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
}

interface OrFeedInterface {
  function getExchangeRate ( string calldata fromSymbol, string calldata toSymbol, string calldata venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string calldata symbol ) external view returns ( address );
  function getSynthBytes32 ( string calldata symbol ) external view returns ( bytes32 );
  function getForexAddress ( string calldata symbol ) external view returns ( address );
}

interface StockETFPrice{
    function getLastPrice (string calldata symbol) external returns (uint256);
    function getTimeUpdated (string calldata symbol) external returns (uint256);
}

interface Kyber {
    function getOutputAmount(ERC20 from, ERC20 to, uint256 amount) external view returns(uint256);

    function getInputAmount(ERC20 from, ERC20 to, uint256 amount) external view returns(uint256);
}

interface IContractRegistry {
    function addressOf(bytes32 _contractName) external view returns (address);
}

interface IBancorNetwork {
    function getReturnByPath(IERC20Token[] calldata _path, uint256 _amount) external view returns (uint256, uint256);
}

interface IBancorNetworkPathFinder {
    function generatePath(address _sourceToken, address _targetToken) external view returns (address[] memory);
}


library SafeMath {
    function mul(uint256 a, uint256 b) internal view returns(uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal view returns(uint256) {
        assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal view returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal view returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}






contract PremiumFeedPrices{
    
    mapping (address=>address) uniswapAddresses;
    mapping (string=>address) tokenAddress;
    
    
     constructor() public  {
         
         
        
         //DAI
         uniswapAddresses[0x6B175474E89094C44Da98b954EedeAC495271d0F] =  0x2a1530C4C41db0B0b2bB646CB5Eb1A67b7158667;
         
         //SAI
         uniswapAddresses[0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359] = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;
         
         //usdc
         uniswapAddresses[0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48] = 0x97deC872013f6B5fB443861090ad931542878126;
         
         //MKR
         
         uniswapAddresses[0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2] = 0x2C4Bd064b998838076fa341A83d007FC2FA50957;
         
         //BAT
         uniswapAddresses[0x0D8775F648430679A709E98d2b0Cb6250d2887EF] = 0x0D8775F648430679A709E98d2b0Cb6250d2887EF;
         
         //LINK
         uniswapAddresses[0x514910771AF9Ca656af840dff83E8264EcF986CA] = 0xF173214C720f58E03e194085B1DB28B50aCDeeaD;
         
         //ZRX
         uniswapAddresses[0xF173214C720f58E03e194085B1DB28B50aCDeeaD] = 0xF173214C720f58E03e194085B1DB28B50aCDeeaD;

          //BTC
         uniswapAddresses[0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599] = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

          //KNC
         uniswapAddresses[0xdd974D5C2e2928deA5F71b9825b8b646686BD200] = 0xdd974D5C2e2928deA5F71b9825b8b646686BD200;

        tokenAddress['DAI'] = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        tokenAddress['SAI'] = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
        tokenAddress['USDC'] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        tokenAddress['MKR'] = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
        tokenAddress['LINK'] = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
        tokenAddress['BAT'] = 0x0D8775F648430679A709E98d2b0Cb6250d2887EF;
        tokenAddress['WBTC'] = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
        tokenAddress['BTC'] = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
        tokenAddress['OMG'] = 0xd26114cd6EE289AccF82350c8d8487fedB8A0C07;
        tokenAddress['ZRX'] = 0xE41d2489571d322189246DaFA5ebDe1F4699F498;
        tokenAddress['TUSD'] = 0x0000000000085d4780B73119b644AE5ecd22b376;
        tokenAddress['ETH'] = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
        tokenAddress['WETH'] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
         tokenAddress['KNC'] = 0xdd974D5C2e2928deA5F71b9825b8b646686BD200;
        
     }
     
     function getExchangeRate(string memory fromSymbol, string memory toSymbol, string memory venue, uint256 amount, address requestAddress) public returns(uint256){
         
         address toA1 = tokenAddress[fromSymbol];
         address toA2 = tokenAddress[toSymbol];
         
         
         
         string memory theSide = determineSide(venue);
         string memory theExchange = determineExchange(venue);
         
         uint256 price = 0;
         string memory queryVenue = venue;
         string memory queryToSymbol = toSymbol;
         string memory queryFromSymbol = fromSymbol;
         
        if(equal(queryVenue,"PROVIDER1") && equal(queryToSymbol,"USD")){
             StockETFPrice stockProvider = StockETFPrice(0x7556FccFB056Ada7aa10c6ed88B5DEF40D66c591);
             price = stockProvider.getLastPrice(queryFromSymbol);
         }
         
        if(equal(theExchange,"UNISWAP")){
            price= uniswapPrice(toA1, toA2, theSide, amount);
         }
         
        if(equal(theExchange,"KYBER")){
            price= kyberPrice(toA1, toA2, theSide, amount);
         }


        if (equal(theExchange, "BANCOR")){
            price = bancorPrice(toA1, toA2, theSide, amount);
        }
        return price;
     }
    
    function uniswapPrice(address token1, address token2, string memory  side, uint256 amount) public returns (uint256){
    
            address fromExchange = getUniswapContract(token1);
            address toExchange = getUniswapContract(token2);
            UniswapExchangeInterface usi1 = UniswapExchangeInterface(fromExchange);
            UniswapExchangeInterface usi2 = UniswapExchangeInterface(toExchange);    
        
            // uint256 ethPrice1;
            // uint256 ethPrice2;
            uint256 resultingTokens;
            uint256 ethBack;
            
        if(equal(side,"BUY")){
            //startingEth = usi1.getTokenToEthInputPrice(amount);
        
            if(token2 == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
                resultingTokens = usi1.getTokenToEthOutputPrice(amount);
                return resultingTokens;
            }
            if(token1 == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
                resultingTokens = usi2.getTokenToEthOutputPrice(amount);
                return resultingTokens;
            }
            
            
            ethBack = usi2.getTokenToEthOutputPrice(amount);
            resultingTokens = usi1.getEthToTokenOutputPrice(ethBack);
            
            //ethPrice1= usi2.getTokenToEthOutputPrice(amount);
            
            //ethPrice2 = usi1.getTokenToEthOutputPrice(amount);

            //resultingTokens = ethPrice1/ethPrice2;
            
            return resultingTokens;
        }
        
        else{
            
             if(token2 == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
                resultingTokens = usi1.getEthToTokenOutputPrice(amount);
                return resultingTokens;
            }
            if(token1 == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
                resultingTokens = usi2.getEthToTokenInputPrice(amount);
                return resultingTokens;
            }
            
              ethBack = usi2.getTokenToEthOutputPrice(amount);
            resultingTokens = usi1.getTokenToEthInputPrice(ethBack);
            
            
            return resultingTokens;
        }
    
    }
    
    
    
     function kyberPrice(address token1, address token2, string memory  side, uint256 amount) public returns (uint256){
         
         Kyber kyber = Kyber(0xFd9304Db24009694c680885e6aa0166C639727D6);
         uint256 price;
           if(equal(side,"BUY")){
            price = kyber.getInputAmount(ERC20(token2), ERC20(token1), amount);
           }
           else{
                price = kyber.getOutputAmount(ERC20(token1), ERC20(token2), amount);
                 
                
           }
         
         return price;
     }
    
    function bancorPrice(address token1, address token2, string memory side, uint256 amount) public returns (uint256){
        // updated with the newest address of the BancorNetwork contract deployed under the circumstances of old versions of `getReturnByPath`
        IContractRegistry contractRegistry = IContractRegistry(0x52Ae12ABe5D8BD778BD5397F99cA900624CfADD4);
        IBancorNetwork bancorNetwork = IBancorNetwork(contractRegistry.addressOf('BancorNetwork'));
        IBancorNetworkPathFinder bancorNetworkPathFinder = IBancorNetworkPathFinder(contractRegistry.addressOf('BancorNetworkPathFinder'));
        uint256 price;
        address token1ToBancor = token1;
        address token2ToBancor = token2;
        // in case of Ether (or Weth), we need to provide the address of the EtherToken to the BancorNetwork
        if (token1 == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || token1 == 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2){
            // the EtherToken addresss for BancorNetwork
            token1ToBancor = 0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315;
        }
        if (token2 == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || token2 == 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2){
            token2ToBancor = 0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315;
        }
        address[] memory addressPath;
        if(equal(side, "BUY")){
            addressPath = bancorNetworkPathFinder.generatePath(token1, token2);
        } else {
            addressPath = bancorNetworkPathFinder.generatePath(token2, token1);
        }
        IERC20Token[] memory tokenPath = new IERC20Token[](addressPath.length);
        for(uint256 i = 0; i < addressPath.length; i++) {
            tokenPath[i] = IERC20Token(addressPath[i]);
        }
        (price, ) = bancorNetwork.getReturnByPath(tokenPath, amount);
        return price;
    }
    
    
    function getUniswapContract(address tokenAddress) public view returns (address){
        return uniswapAddresses[tokenAddress];
    }
    
    function determineSide(string memory sideString) public view returns (string memory){
            
        if(contains("SELL", sideString ) == false){
            return "BUY";
        }
        
        else{
            return "SELL";
        }
    }
    
    
    
    function determineExchange(string memory exString) public view returns (string memory){
            
        if(contains("UNISWA", exString ) == true){
            return "UNISWAP";
        }
        
        else if(contains("KYBE", exString ) == true){
            return "KYBER";
        }
        else if(contains("BANCO", exString)) {
            return "BANCOR";
        }
        else{
            return "NONE";
        }
    }
    
    
    function contains (string memory what, string memory where) public view returns(bool){
    bytes memory whatBytes = bytes (what);
    bytes memory whereBytes = bytes (where);

    bool found = false;
    for (uint i = 0; i < whereBytes.length - whatBytes.length; i++) {
        bool flag = true;
        for (uint j = 0; j < whatBytes.length; j++)
            if (whereBytes [i + j] != whatBytes [j]) {
                flag = false;
                break;
            }
        if (flag) {
            found = true;
            break;
        }
    }
  
    return found;
    
}


   function compare(string memory _a, string memory _b) public returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
    /// @dev Compares two strings and returns true iff they are equal.
    function equal(string memory _a, string memory _b) public returns (bool) {
        return compare(_a, _b) == 0;
    }
    /// @dev Finds the index of the first occurrence of _needle in _haystack
    function indexOf(string memory _haystack, string memory _needle) public returns (int)
    {
        bytes memory h = bytes(_haystack);
        bytes memory n = bytes(_needle);
        if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
            return -1;
        else if(h.length > (2**128 -1)) // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
            return -1;                                  
        else
        {
            uint subindex = 0;
            for (uint i = 0; i < h.length; i ++)
            {
                if (h[i] == n[0]) // found the first char of b
                {
                    subindex = 1;
                    while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) // search until the chars don't match or until we reach the end of a or b
                    {
                        subindex++;
                    }   
                    if(subindex == n.length)
                        return int(i);
                }
            }
            return -1;
        }   
    }
    

    
}