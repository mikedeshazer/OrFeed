//Example contract on mainnet: 0xd56a221e41a790573288c5b0be281202f77f257b

    interface synthetixOracle {
        function gasPriceLimit() public view returns (uint);
    
    }

  
    contract registeredoracleExample {
        
    
      address owner; 
      modifier onlyOwner() {
            if (msg.sender != owner) {
                throw;
            }
             _;
        }
        synthetixOracle synthO;
        
      constructor() public payable {

            owner = msg.sender; 
            synthO = synthetixOracle(0x7cB89c509001D25dA9938999ABFeA6740212E5f0);
        }
        
        
    function getPriceFromOracle(string fromParam, string toParam, string  side, uint256 amount) public constant returns (uint256){  
          
        uint256 gasLimit = synthO.gasPriceLimit();
        return gasLimit;
          
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
    
    
    
}