// SPDX-License-Identifier: MIT
//Tested on Solidity 0.7.4
pragma solidity >=0.4.22 <0.8.0;

//This code has not been audited and is a simplified version of a more robust contract. This is meant for educational purposes.
// Contains interfaces for Pickle.finance and Harvest.finance for entering and exiting farming pools
// To test you need to approve this deployed updateStakingContracts

interface HarvestStakingInterface {
  function balanceOf ( address who ) external view returns ( uint256 );
  function exit (  ) external;
  function stake ( uint256 amount ) external;

}


interface PickleStakingInterface {
  function approve ( address spender, uint256 amount ) external returns ( bool );
  function balanceOf ( address account ) external view returns ( uint256 );
  function deposit ( uint256 _amount ) external;
  function depositAll (  ) external;
  function withdrawAll (  ) external;
}





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

interface ERC20 {
    function totalSupply() external view returns(uint supply);

    function balanceOf(address _owner) external view returns(uint balance);

    function transfer(address _to, uint _value) external returns(bool success);

    function transferFrom(address _from, address _to, uint _value) external returns(bool success);

    function approve(address _spender, uint _value) external returns(bool success);

    function allowance(address _owner, address _spender) external view returns(uint remaining);

    function decimals() external view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


interface UniswapV2{

 function swapExactTokensForTokens ( uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline ) external returns ( uint256[] memory amounts );

}



contract FarmEnterAndExit{

  using SafeMath
    for uint256;

  address payable public owner;
  address ETH_TOKEN_ADDRESS  = address(0x0);
  mapping (uint256=> mapping(address=>address)) public stakingDirectory;
  ERC20 usdcToken = ERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
  address public usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  UniswapV2 uniswapEx = UniswapV2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
  address public uniAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;


 modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _;
}


  constructor() public payable {

        owner= msg.sender;
        //farm token, farm staking
        stakingDirectory[1][0xa0246c9032bC3A600820415aE600c6388619A14D] = 0x25550Cccbd68533Fa04bFD3e3AC4D09f9e00Fc50;

        //pickle's USDT/Pickle staking jar
        stakingDirectory[2][0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852] = 0x09FC573c502037B149ba87782ACC81cF093EC6ef;

  }


  fallback() external payable {


  }


  function updateStakingContracts(uint256 whichFarm, address stakingAddress, address stakingToken ) public onlyOwner returns (bool){

    stakingDirectory[whichFarm][stakingToken]=stakingAddress;
    return true;

  }

  function updateUSDCToken(address newAddress ) public onlyOwner returns (bool){

    usdcToken = ERC20( newAddress);
    usdcAddress = newAddress;
    return true;

  }

  function updateUniswap(address newAddress ) public onlyOwner returns (bool){

    uniswapEx = UniswapV2( newAddress);
    uniAddress = newAddress;
    return true;

  }



  function enterFarm(uint256 whichFarm, address tokenAddress) payable onlyOwner public returns (bool){

        ERC20 thisToken = ERC20(tokenAddress);
        uint256 ownerBalance = thisToken.balanceOf(msg.sender);

        require(thisToken.transferFrom(msg.sender, address(this), ownerBalance), "Not enough tokens to transferFrom or no approval");


        uint256 approvedAmount = thisToken.allowance(address(this), stakingDirectory[whichFarm][tokenAddress]);
        if(approvedAmount < ownerBalance  ){
            thisToken.approve(stakingDirectory[whichFarm][tokenAddress], ownerBalance.mul(10000));
        }

        stake(whichFarm, ownerBalance, tokenAddress );
        return true;
   }


   function exitFarm(uint256 whichFarm, address tokenAddress) onlyOwner payable public returns(bool){

      ERC20 thisToken = ERC20(tokenAddress);
      unstake(whichFarm, tokenAddress);
      uint256 currentTokenBalance = thisToken.balanceOf(address(this));
        if(whichFarm==1){
          //swap from unstaked tokens to usdc and transfer back to owner
          thisToken.approve(uniAddress, 1000000000000000000000000000000000000);

          performUniswap(tokenAddress, usdcAddress, currentTokenBalance);
          require(usdcToken.transfer(msg.sender, usdcToken.balanceOf(address(this))), "You dont have enough tokens inside this contract to withdraw from deposits");
          return true;
        }
        else{
            //JUST example code, this one doesnt unwrap, trade and send as its an LP token, and just sends to the user as an example in the tutorial
            require(thisToken.transfer(msg.sender, currentTokenBalance), "You dont have enough tokens inside this contract to withdraw from deposits");
        }
    }


   function stake(uint256 whichFarm, uint256 amount,  address tokenAddress) internal returns(bool){


      if(whichFarm == 1){
        HarvestStakingInterface staker  = HarvestStakingInterface(stakingDirectory[whichFarm][tokenAddress]);
        staker.stake(amount);
        return true;
      }
      else{

        PickleStakingInterface staker1  = PickleStakingInterface(stakingDirectory[whichFarm][tokenAddress]);
        staker1.deposit(amount);
      }


   }

   function unstake(uint256 whichFarm, address tokenAddress) internal returns(bool){
     if(whichFarm == 1){
       HarvestStakingInterface staker  =  HarvestStakingInterface(stakingDirectory[whichFarm][tokenAddress]);
       staker.exit();
     }
     else{
       PickleStakingInterface staker1  =  PickleStakingInterface(stakingDirectory[whichFarm][tokenAddress]);
       staker1.approve(stakingDirectory[whichFarm][tokenAddress], 10000000000000000000000000000000);
       staker1.withdrawAll();

     }


      return true;

   }



   function performUniswap(address sellToken, address buyToken, uint amount) internal returns (uint256 amounts1){
          address [] memory addresses = new address[](2);
          addresses[0] = sellToken;
          addresses[1] = buyToken;
           uint256 [] memory amounts = performUniswapT4T(addresses, amount );
           uint256 resultingTokens = amounts[1];
           return resultingTokens;
    }

    function performUniswapT4T(address  [] memory theAddresses, uint amount) internal returns (uint256[] memory amounts1){

           uint256 deadline = 1000000000000000;
           uint256 [] memory amounts =  uniswapEx.swapExactTokensForTokens(amount, 1, theAddresses, address(this),deadline );
           return amounts;

    }


   function updateOwnerAddress(address payable newOwner) onlyOwner public returns (bool){
     owner = newOwner;
     return true;
   }


   function getMyStakedBalance(uint256 whichFarm, address _owner, address tokenAddress) public view returns(uint256){
    if(whichFarm== 1){
        HarvestStakingInterface staker  = HarvestStakingInterface(stakingDirectory[whichFarm][tokenAddress]);
       return staker.balanceOf(_owner);
    }
    else{
        PickleStakingInterface staker1  = PickleStakingInterface(stakingDirectory[whichFarm][tokenAddress]);
       return staker1.balanceOf(_owner);
    }

   }



  function withdrawTokens(address token, uint amount, address payable destination) public onlyOwner returns(bool) {

      if (address(token) == ETH_TOKEN_ADDRESS) {
          destination.transfer(amount);
      }
      else {
          ERC20 tokenToken = ERC20(token);
          require(tokenToken.transfer(destination, amount));
      }
      return true;
  }



 function kill() virtual public onlyOwner {
         selfdestruct(owner);
 }




}
