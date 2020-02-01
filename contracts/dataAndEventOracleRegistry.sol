//oracle for event and data registry
//Example: https://etherscan.io/address/0xd754f58d9d6d705b98bde698f9f9cec0bded1b8a#readContract

pragma experimental ABIEncoderV2;

interface DataOracleInterface{
    function getResultFromOracle (string theEvent) returns (string);
}
  
    // oracle registery main
    contract oracleForDataRegistry {
        
      mapping (string=>address) oracleMapping;
      mapping (string=>address) oracleOwners;
      mapping (string=>string) oracleOwnersInfo;
      
      string [] oracleNamesArr;
      address [] oracleOwnersArr;
      string [] oracleOwnersInfoArr;
      
      uint256 purchaseFee;
      
      address owner; 
      modifier onlyOwner() {
            if (msg.sender != owner) {
                throw;
            }
             _;
        }
        
      constructor() public payable {
            owner = msg.sender; 
            //default .001
            purchaseFee = 1000000000000000;
        }
        
        
     
         
     function getEventResult(string selectedEventOrData, string selectedOracle) public constant returns (string){  
          selectedOracle = toLower(selectedOracle);
          address oracleAddress = getOracleAddress(selectedOracle);
          if (oracleAddress <= 0){
              //The requested provider is not registered in this oracle registry
              return "";
          }
          
          DataOracleInterface p = DataOracleInterface(oracleAddress);
          return p.getResultFromOracle(selectedEventOrData);
          
      }
      
      function changeOwner(address newOwner) onlyOwner returns(bool){
          owner = newOwner;
          return true;
      }
      
      function changeFee(uint256 newFee) onlyOwner returns(bool){
          purchaseFee = newFee;
          return true;
      }
      
    
      
     function withdrawBalance() onlyOwner returns(bool) {
        uint amount = this.balance;
        msg.sender.transfer(amount);
        return true;

    }
    
    function registerOracle(string name, address requestedAddress, string info ) payable returns (bool){
        require(msg.value >= purchaseFee, "Please send .05 ETH to register an oracle. This is to prevent registration spam");
        
        name = toLower(name);
        
        if(oracleMapping[name] > 1){
            //you cant update/re-register an address
            throw;
            
        }
        if(oracleMapping[name] != 0x0 && oracleOwners[name] != msg.sender){
            //you cant update this because you did not register this name
            throw;
            
        }
        
    string memory theDetails = info;
       oracleMapping[name] = requestedAddress;
       oracleOwners[name] = msg.sender;
        oracleOwnersInfo[name] = theDetails;
        
        oracleNamesArr.push(name);
        oracleOwnersArr.push(msg.sender);
        oracleOwnersInfoArr.push(theDetails);
        
        
       return true;
        
    }
    
      function transferOracleName(string name, address toAddress) returns(bool){
           if(oracleMapping[name] != 0x0 && oracleOwners[name] != msg.sender){
            //you cant transfer this because you did not register this name
            throw;
            
         }
         oracleOwners[name] = toAddress;
         return true;
        
      }
    
    function editOracleInfo(string name, string info) payable returns (bool){
       
        name = toLower(name);
        
       
        if(oracleMapping[name] != 0x0 && oracleOwners[name] != msg.sender){
            //you cant update this because you did not register this name
            throw;
            
        }
        
        string memory theDetails = info;
      
        oracleOwnersInfo[name] = theDetails;
      

       return true;
        
    }

    function editOracleAddress(string name, address newOrSameOracleAddress) payable returns (bool){
       
        name = toLower(name);
        
       
        if(oracleMapping[name] != 0x0 && oracleOwners[name] != msg.sender){
            //you cant update this because you did not register this name
            throw;
            
        }
        
      
        oracleMapping[name] = newOrSameOracleAddress;

       return true;
        
    }
    
    
    function getAllOracles() constant returns (string []){
        return oracleNamesArr;
    }


    function getPurchaseFee() constant returns (uint256){
        return purchaseFee;
    }
    
    
    function getOracleAddress(string nameReference) constant returns (address){
        nameReference = toLower(nameReference);
        return oracleMapping[nameReference];
    }
    
    function getOracleOwner(string nameReference) constant returns (address){
        nameReference = toLower(nameReference);
        return oracleOwners[nameReference];
    }
    
    function getOracleInfo(string nameReference) constant returns (string){
        nameReference = toLower(nameReference);
        return oracleOwnersInfo[nameReference];
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