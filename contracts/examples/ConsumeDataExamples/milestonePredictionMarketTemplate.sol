//Example Prediction market for www.floater.market

pragma solidity ^0.4.26;

interface OrFeedInterface {
    function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );
    function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
    function getTokenAddress ( string symbol ) external view returns ( address );
    function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );
    function getForexAddress ( string symbol ) external view returns ( address );
    function getEventResult(string eventName, string source)  constant external returns(string);
}
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

interface IKyberNetworkProxy {
    function maxGasPrice() external view returns(uint);
    function getUserCapInWei(address user) external view returns(uint);
    function getUserCapInTokenWei(address user, ERC20 token) external view returns(uint);
    function enabled() external view returns(bool);
    function info(bytes32 id) external view returns(uint);
    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view returns (uint expectedRate, uint slippageRate);
    function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) external payable returns(uint);
    function swapEtherToToken(ERC20 token, uint minRate) external payable returns (uint);
    function swapTokenToEther(ERC20 token, uint tokenQty, uint minRate) external returns (uint);
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


contract Floater{
    
    mapping(address => uint256) predictionBalances;
    mapping(address => uint256) predictionSides;
    //.01 minimum by default
    uint256 minETHPrediction = 10000000000000000;
    string  public eventTitle = 'Example Project';
    string public eventDescription = "This is an example project that is due 60 days from the date set. Alledgedly, the owner can refund all bets as well as resolution can be set when the time is up via OrFeed";
    uint256 public expirationTimestamp;
    uint256 predictionUserLimit = 100;
    uint256 currentPredictionUsers = 0;
    uint256 public daiPotSize = 0;
    uint256 public daiTrueSize = 0;
    uint256 public daiFalseSize = 0;
    uint256 public ethTotalPot = 0;
    bool active = true;
    address kyberProxyAddress = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
    IKyberNetworkProxy kyberProxy; 
    OrFeedInterface orfeed= OrFeedInterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);
    using SafeMath for uint256; 
     address public owner; 
    modifier onlyOwner() {
            if (msg.sender != owner) {
                throw;
            }
             _;
    }
    constructor() public payable {
            owner = msg.sender; 
            expirationTimestamp = now + 5 days;
            
    }
        
    
    
    
    function predict(uint256 side) payable external returns(bool){
        
        require(msg.value >= minETHPrediction, "Please send the minimum to place a prediciton");
        bytes memory PERM_HINT = "PERM";
        kyberProxy = IKyberNetworkProxy(kyberProxyAddress);
        ERC20 eth = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
        ERC20 dai = ERC20(0x6b175474e89094c44da98b954eedeac495271d0f);
        uint daiAmount = kyberProxy.tradeWithHint.value(msg.value)(eth, msg.value, dai, this, 8000000000000000000000000000000000000000000000000000000000000000, 0, 0x0000000000000000000000000000000000000004, PERM_HINT);
       
        
        
        
        if(side ==0){
            daiFalseSize = daiFalseSize.add(daiAmount);
            
            
        }
        else{
            daiFalseSize = daiTrueSize.add(daiAmount);
            
        }
        
        daiPotSize = daiPotSize.add(daiAmount);
        ethTotalPot = ethTotalPot.add(msg.value);
        
    }
    
    function resolveEvent() external returns(bool){
        
        //TODO: calcualte winnings, convert dai back to eth, and distribute to the right side, leaving a 2% commission for owner.
        
        string memory result = orfeed.getEventResult("floater.market", toString(this));
        if(equal(result, "TRUE")){
            
            return true;
        }
        else if(equal(result, "FALSE")){
            
            return true;
        }
        else{
            
            return false;
        }
        
    }
    
    function emergencyReturnAllFunds() onlyOwner returns(bool){
        
        //TODO: if there is an issue, the owner can redistribute funds to all participants
        
        for (uint i=0; i<currentPredictionUsers; i++) {
            
           
        }
        
        
    }
    
    function toString(address x)  internal returns (string) {
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++)
            b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
        return string(b);
    }
    
    function compare(string _a, string _b) internal returns (int) {
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
    
    function equal(string _a, string _b) internal returns (bool) {
        return compare(_a, _b) == 0;
    }
    
    function indexOf(string _haystack, string _needle) internal returns (int)
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
    function timeCalculatePerDay(uint256 amountDays) public returns (uint256){
        uint256 timeMul = 1 days;
        uint howMuchTime = amountDays * amountDays;
        return howMuchTime;
    }
    
    
    
}



