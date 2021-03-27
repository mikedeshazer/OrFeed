//Uniswap by address (v2)
//Better uniswap v2 oracle for orfeed
//v0.4.26+commit.1d4f565a.js&appVersion=0.7.7



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


interface IUniswapV2Router01 {


    function getAmountsOut(uint amountIn, address[]  path) external view returns (uint[] memory amounts);

}




    contract oracleInfo {


      address owner;

      address uniswapAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        IUniswapV2Router01 uniswap = IUniswapV2Router01(uniswapAddress);


      modifier onlyOwner() {
            if (msg.sender != owner) {
                revert();
            }
             _;
        }

      constructor() public payable {
            owner = msg.sender;

        }


    function getPriceFromOracle(string memory fromParam, string memory  toParam, string memory side, uint amount) public view returns (uint256 amounts1){


        address sellToken = stringToAddress(fromParam);
        address buyToken = stringToAddress(toParam);

        address [] memory addresses = new address[](2);

       addresses[0] = sellToken;
       addresses[1] = buyToken;


        uint256 [] memory amounts = getPriceFromOracleActual(addresses, amount );
        uint256 resultingTokens = amounts[1];
        return resultingTokens;

    }

    function getPriceFromOracleActual(address  [] memory theAddresses, uint amount) public view returns (uint256[] memory amounts1){



        uint256 [] memory amounts = uniswap.getAmountsOut(amount,theAddresses );

        return amounts;

    }









    function stringToAddress(string memory _address1) public view returns(address){
       // bytes32 theAddress = stringToBytes32(_address1);
        address retAddress= bytesToAddress(stringToByte(_address1));

        return retAddress;




    }
    function bytesToAddress (bytes b) view returns (address) {
    uint result = 0;
    for (uint i = 0; i < b.length; i++) {
        uint c = uint(b[i]);
        if (c >= 48 && c <= 57) {
            result = result * 16 + (c - 48);
        }
        if(c >= 65 && c<= 90) {
            result = result * 16 + (c - 55);
        }
        if(c >= 97 && c<= 122) {
            result = result * 16 + (c - 87);
        }
    }
    return address(result);
}




     function stringToByte(string memory s) view public returns (bytes) {
        bytes memory b = bytes(s);
      return b;
    }



}
