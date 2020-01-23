//oracle registry
// Example: https://etherscan.io/address/0x45b0b6ac962a3b8bbad39868742302746c99e0d3#code

interface PriceOracleInterface{
      function getPriceFromOracle (string fromParam, string toParam, string  side, uint256 amount) returns (uint256);
 }
  
    // ERC20 Token Smart Contract
    contract oracleRegistry {
        
      mapping (string=>address) oracleMapping;
      mapping (string=>address) oracleOwners;
      address owner; 
      modifier onlyOwner() {
            if (msg.sender != owner) {
                throw;
            }
             _;
        }
        
      constructor() public payable {
            owner = msg.sender; 
           
        }
        
        
        
     
         
     function getPriceFromOracle(string selectedOracle, string fromParam, string toParam, string  side, uint256 amount) public constant returns (uint256){  
          selectedOracle = toLower(selectedOracle);
          address oracleAddress = getOracleAddress(selectedOracle);
          if (oracleAddress <= 0){
              //The requested provider is not registered in this oracle registry
              return 0;
          }
          
          PriceOracleInterface p = PriceOracleInterface(oracleAddress);
          return p.getPriceFromOracle(fromParam, toParam, side, amount);
          
      }
      
      function changeOwner(address newOwner) onlyOwner returns(bool){
          owner = newOwner;
          return true;
      }
      
     function withdrawBalance() onlyOwner returns(bool) {
        uint amount = this.balance;
        msg.sender.transfer(amount);
        return true;

    }
    
    
    function registerOracle(string name, address requestedAddress ) payable returns (bool){
        require(msg.value >= 50000000000000000, "Please send .05 ETH to register an oracle. This is to prevent registration spam");
        
        name = toLower(name);
        if(oracleMapping[name] != 0x0 && oracleOwners[name] != msg.sender){
            //you cant update this because you did not register this name
            throw;
            
        }
        
       oracleMapping[name] = requestedAddress;
       oracleOwners[name] = msg.sender;
       return true;
        
    }
    
    
    function getOracleAddress(string nameReference) constant returns (address){
        nameReference = toLower(nameReference);
        return oracleMapping[nameReference];
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
  
}