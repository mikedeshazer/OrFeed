
interface OrFeedInterface {
    function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );
    function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
    function getTokenAddress ( string symbol ) external view returns ( address );
    function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );
    function getForexAddress ( string symbol ) external view returns ( address );
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


contract Roulette {
    OrFeedInterface orfeed = OrFeedInterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);
    using SafeMath for uint256;
    address owner;
    uint256 maxBet = 110000000000000000;
    
    modifier onlyOwner() {
        assert (msg.sender == owner);
        _;
    }

    constructor() public payable {
        owner = msg.sender;
    }
    
    function play(string oddOrEven) payable returns (uint256 result){
        
        require(msg.value <= maxBet, "You must bet less than the maxBet");
        require(msg.value >  0, "You cant bet zero");
        require(this.balance >= msg.value.mul(2), "There is not enough in the house to allow this bet to take place");
        require(tx.origin == msg.sender, "smart contract cannot call this contract");
        string memory theColor = toLower(oddOrEven);
        bool userInputBool;
       if (equal(theColor, "even")){
           userInputBool = true;
       }
       else{
           theColor = "odd";
           userInputBool = false;
       }
       
       uint256 number = getSpinResult();
         bool theResult = checkEven(number);
         
        if(number == 0){
            Result(userInputBool, theResult, theColor, number, "LOSE");
            return number;
        }
        
       
        
        if(userInputBool != theResult ){
            Result(userInputBool, theResult, theColor, number, "LOSE");
            return number;
           
        }
        else{
             msg.sender.transfer(msg.value.mul(2));
            Result(userInputBool, theResult, theColor, number, "WIN");
            return number;
        }
        
    }
    
    function () onlyOwner payable{
        //add funds to house
    }
    
    function checkEven(uint256 testNo) internal pure returns(bool){
        uint256 remainder = testNo % 2;
        if(remainder == 0){
            return true;
        }
        else{
            return false;
        }
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
    function toLower(string str) internal returns (string) {
    bytes memory bStr = bytes(str);
    bytes memory bLower = new bytes(bStr.length);
    for (uint i = 0; i < bStr.length; i++) {
      if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
        bLower[i] = bytes1(int(bStr[i]) + 32);
      } else {
        bLower[i] = bStr[i];
      }
    }
    return string(bLower);
  }
  
  function withdrawOwnerBalance(uint256 amount) onlyOwner returns(bool) {
      
        msg.sender.transfer(amount);
        return true;

    }
    
    function withdrawOwnerFullBalance() onlyOwner returns(bool) {
        uint amount = this.balance;
        msg.sender.transfer(amount);
        return true;

    }
    
    
    function changeMaxBet(uint256 newMax) onlyOwner returns(bool){
          maxBet = newMax;
          return true;
      }
      
     function getBlockNumber() constant returns(uint256){
         return block.number;
     }
     
     function getSpinResult() internal returns(uint256){
         uint256 number1 = orfeed.getExchangeRate("0", "36", "random", 0);
         return number1;
     }
     
     function getLastSpinResult() constant returns(uint256){
         uint256 number2 = orfeed.getExchangeRate("0", "36", "random", 0);
         return number2;
     }
      
    
event Result(bool inputBool, bool isNumEvenBool, string bet, uint256 numb, string result);
}
