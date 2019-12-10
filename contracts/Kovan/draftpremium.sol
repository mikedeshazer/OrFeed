//Dapp test 0x5e00a16eb51157fb192bd4fcaef4f79a4f16f480

pragma solidity ^0.4.26;
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
    function totalSupply() public view returns (uint supply);
    function balanceOf(address _owner) public view returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint remaining);
    function decimals() public view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

interface OrFeedInterface {
  function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string symbol ) external view returns ( address );
  function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );
  function getForexAddress ( string symbol ) external view returns ( address );
}

interface Kyber {
    function getOutputAmount(ERC20 from, ERC20 to, uint256 amount) external view returns(uint256);

    function getInputAmount(ERC20 from, ERC20 to, uint256 amount) external view returns(uint256);
}


library SafeMath {
    function mul(uint256 a, uint256 b) internal constant returns(uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal constant returns(uint256) {
        assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal constant returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal constant returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}






contract PremiumFeedPrices{
    
    mapping (address=>address) uniswapAddresses;
    mapping (string=>address) tokenAddress;
    
    
     constructor() public  {
         
         
        
         //DAI v
         uniswapAddresses[0xc4375b7de8af5a38a93548eb8453a498222c4ff2] =  0x8779C708e2C3b1067de9Cd63698E4334866c691C;
         
         //SAI
         //uniswapAddresses[0x2303039ee502ad4d663b83cb4ce1102ff5846457] = 0x09cabec1ead1c0ba254b09efb3ee13841712be14;
         
         //usdc
         //uniswapAddresses[0x6c27debde8c5fe159c5b6b47f5fa56b7f532247a] = 0x97dec872013f6b5fb443861090ad931542878126;
         
         //MKR v
         
         uniswapAddresses[0xac94ea989f6955c67200dd67f0101e1865a560ea] = 0x4dc5f99912cca20418d39dc3cfb319680857552d;
         
         //BAT
         //uniswapAddresses[0xec88a5050c63bb9e073afc78b3b9378d0eb53257] = 0x2e642b8d59b45a1d8c5aef716a84ff44ea665914;
         
         //LINK
         //uniswapAddresses[0xad5ce863ae3e4e9394ab43d4ba0d80f419f61789] = 0xf173214c720f58e03e194085b1db28b50acdeead;
         
         //ZRX
         //uniswapAddresses[0x6ff6c0ff1d68b964901f986d4c9fa3ac68346570] = 0xae76c84c9262cdb9abc0c2c8888e62db8e22a0bf;
     
          //BTC
         //uniswapAddresses[0x2260fac5e5542a773aa44fbcfedf7c193bc2c599] = 0x4d2f5cfba55ae412221182d8475bc85799a5644b;
         
          //KNC
         //uniswapAddresses[0xb2f3dd487708ca7794f633d9df57fdb9347a7aff] =0x49c4f9bc14884f6210f28342ced592a633801a8b;
         
         
         
         
         
         
         
        
         tokenAddress['DAI'] = 0xc4375b7de8af5a38a93548eb8453a498222c4ff2;
         tokenAddress['SAI'] = 0x2303039ee502ad4d663b83cb4ce1102ff5846457;
        tokenAddress['USDC'] = 0x6c27debde8c5fe159c5b6b47f5fa56b7f532247a;
        tokenAddress['MKR'] = 0xac94ea989f6955c67200dd67f0101e1865a560ea;
        tokenAddress['LINK'] = 0xad5ce863ae3e4e9394ab43d4ba0d80f419f61789;
        tokenAddress['BAT'] = 0xec88a5050c63bb9e073afc78b3b9378d0eb53257;
        tokenAddress['WBTC'] = 0xa1d3eecb76285b4435550e4d963b8042a8bffbf0;
        tokenAddress['BTC'] = 0xa1d3eecb76285b4435550e4d963b8042a8bffbf0;
        tokenAddress['OMG'] = 0xdff868181120da44e8250855a21cdbed2ed039ab;
        tokenAddress['ZRX'] = 0x6ff6c0ff1d68b964901f986d4c9fa3ac68346570;
        tokenAddress['TUSD'] = 0xb41f85973606ceb0ac33316f04311348b6f2f288;
        tokenAddress['ETH'] = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
        tokenAddress['WETH'] = 0xd0a1e359811322d97991e03f863a0c30c2cf029c;
         tokenAddress['KNC'] = 0xb2f3dd487708ca7794f633d9df57fdb9347a7aff;

     }
     
     function getExchangeRate(string fromSymbol, string toSymbol, string venue, uint256 amount, address requestAddress) public constant returns(uint256){
         
         address toA1 = tokenAddress[fromSymbol];
         address toA2 = tokenAddress[toSymbol];
         
         
         
         string memory theSide = determineSide(venue);
         string memory theExchange = determineExchange(venue);
         
         uint256 price = 0;
         
         if(equal(theExchange,"UNISWAP")){
            price= uniswapPrice(toA1, toA2, theSide, amount);
         }
         
         if(equal(theExchange,"KYBER")){
            price= kyberPrice(toA1, toA2, theSide, amount);
         }
         
         
         return price;
     }
    
    function uniswapPrice(address token1, address token2, string  side, uint256 amount) public constant returns (uint256){
    
            address fromExchange = getUniswapContract(token1);
            address toExchange = getUniswapContract(token2);
            UniswapExchangeInterface usi1 = UniswapExchangeInterface(fromExchange);
            UniswapExchangeInterface usi2 = UniswapExchangeInterface(toExchange);    
        
            uint256  ethPrice1;
            uint256 ethPrice2;
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
    
    
    
     function kyberPrice(address token1, address token2, string  side, uint256 amount) public constant returns (uint256){
         
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
    
    
    
    function getUniswapContract(address tokenAddress) public constant returns (address){
        return uniswapAddresses[tokenAddress];
    }
    
    function determineSide(string sideString) public constant returns (string){
            
        if(contains("SELL", sideString ) == false){
            return "BUY";
        }
        
        else{
            return "SELL";
        }
    }
    
    
    
    function determineExchange(string exString) constant returns (string){
            
        if(contains("UNISWA", exString ) == true){
            return "UNISWAP";
        }
        
        else if(contains("KYBE", exString ) == true){
            return "KYBER";
        }
        else{
            return "NONE";
        }
    }
    
    
    function contains (string memory what, string memory where)  constant returns(bool){
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


   function compare(string _a, string _b) returns (int) {
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
    function equal(string _a, string _b) returns (bool) {
        return compare(_a, _b) == 0;
    }
    /// @dev Finds the index of the first occurrence of _needle in _haystack
    function indexOf(string _haystack, string _needle) returns (int)
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