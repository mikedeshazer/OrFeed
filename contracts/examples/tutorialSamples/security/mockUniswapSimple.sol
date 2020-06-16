//DO NOT USE THIS CODE FOR YOUR SWAP PLATFORM. IT CONTAINS VULNERABILITIES THAT ALLOW IT TO BE HACK. THIS WAS CREATED AS AN EXAMPLE IN TUTORIALS ON SMART CONTRACT VULNERABILITIES.

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




contract UniswapMockInsecureExchange {

    uint256 reserveTokenBalance = 0;
    uint256 continuousTokenPrice = 0;
    uint256 ethReserves = 0;
    address currentTokenContract;
    ERC20 currentERC20;



    //Usually this particular function is in a seperate contract, but for the purposes of this example we have put it here for simplicity reasons
    function createExchange(address token) external returns (address exchange){
        currentTokenContract = token;
        currentERC20 = ERC20(token);
        return token;
    }


    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256){
        //Super simple, insecure function
        require(currentERC20.transferFrom(msg.sender, address(this), max_tokens), "Please add to your token balance or give this contract permission to handle your tokens");
        reserveTokenBalance = reserveTokenBalance + max_tokens;
        ethReserves = ethReserves + msg.value;
        return true;

    }

    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (bool){
        //Super simple, insecure function
        reserveTokenBalance = reserveTokenBalance - min_tokens;
        currentERC20.transfer(msg.sender, min_tokens);
        msg.send(msg.sender, min_tokens*continuousTokenPrice);
        return true;
    }

    function getEthToTokenInputPrice(uint256 eth_sold) public view returns (uint256 tokens_bought){
        //Super simple, insecure function
        // /Reserve Ratio = Reserve Token Balance / (Continuous Token Supply x Continuous Token Price)
        // /Continuous Token Price = Reserve Token Balance / (Continuous Token Supply x Reserve Ratio)
        uint256 tokenSupply = currentERC20.balanceOf(msg.sender);
        uint256 reserveRatio = reserveTokenBalance / continuousTokenPrice;
        uint256 continuousTokenPriceNew = reserveTokenBalance / (tokenSupply * reserveRatio);
        return eth_sold * continuousTokenPriceNew;

    }

    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought){
        //Super simple, insecure function

        uint256 tokensToSend = getEthToTokenInputPrice(msg.value);
        require(tokensToSend < min_tokens, "The amount of min_tokens specified can not be transferred given the amount of eth you provided");
        currentERC20.transfer(msg.sender, tokensToSend);
        reserveTokenBalance = reserveTokenBalance - tokensToSend;
        ethReserves = ethReserves+ msg.value;
        return tokensToSend;


    }

     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought){
        require(currentERC20.transferFrom(msg.sender, address(this), max_tokens), "Please add to your token balance or give this contract permission to handle your tokens");
         uint256 ethToSend = tokens_sold*continuousTokenPrice
         msg.send(msg.sender, ethToSend);
         reserveTokenBalance = reserveTokenBalance+ tokens_sold;
         ethReserves = ethReserves - ethToSend;
         return ethToSend;

     }

}
