
//orfeed.org alpha premium contract
pragma solidity ^ 0.4 .26;

interface IKyberNetworkProxy {
    function maxGasPrice() external view returns(uint);

    function getUserCapInWei(address user) external view returns(uint);

    function getUserCapInTokenWei(address user, ERC20 token) external view returns(uint);

    function enabled() external view returns(bool);

    function info(bytes32 id) external view returns(uint);

    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view returns(uint expectedRate, uint slippageRate);

    function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount, uint minConversionRate, address walletId, bytes hint) external payable returns(uint);

    function swapEtherToToken(ERC20 token, uint minRate) external payable returns(uint);

    function swapTokenToEther(ERC20 token, uint tokenQty, uint minRate) external returns(uint);
}

interface SynthetixExchange {
    function effectiveValue(bytes32 from, uint256 amount, bytes32 to) external view returns(uint256);
}

interface Kyber {
    function getOutputAmount(ERC20 from, ERC20 to, uint256 amount) external view returns(uint256);

    function getInputAmount(ERC20 from, ERC20 to, uint256 amount) external view returns(uint256);
}

interface Synthetix {
    function getOutputAmount(bytes32 from, bytes32 to, uint256 amount) external view returns(uint256);

    function getInputAmount(bytes32 from, bytes32 to, uint256 amount) external view returns(uint256);
}

interface premiumSubInterface {
    function getExchangeRate(string fromSymbol, string toSymbol, string venue, uint256 amount, address requestAddress) external view returns(uint256);

}
interface synthetixMain {
    function getOutputAmount(bytes32 from, bytes32 to, uint256 amount) external view returns(uint256);

    function getInputAmount(bytes32 from, bytes32 to, uint256 amount) external view returns(uint256);
}

contract synthConvertInterface {
    function name() external view returns(string);

    function setGasPriceLimit(uint256 _gasPriceLimit) external;

    function approve(address spender, uint256 value) external returns(bool);

    function removeSynth(bytes32 currencyKey) external;

    function issueSynths(bytes32 currencyKey, uint256 amount) external;

    function mint() external returns(bool);

    function setIntegrationProxy(address _integrationProxy) external;

    function nominateNewOwner(address _owner) external;

    function initiationTime() external view returns(uint256);

    function totalSupply() external view returns(uint256);

    function setFeePool(address _feePool) external;

    function exchange(bytes32 sourceCurrencyKey, uint256 sourceAmount, bytes32 destinationCurrencyKey, address destinationAddress) external returns(bool);

    function setSelfDestructBeneficiary(address _beneficiary) external;

    function transferFrom(address from, address to, uint256 value) external returns(bool);

    function decimals() external view returns(uint8);

    function synths(bytes32) external view returns(address);

    function terminateSelfDestruct() external;

    function rewardsDistribution() external view returns(address);

    function exchangeRates() external view returns(address);

    function nominatedOwner() external view returns(address);

    function setExchangeRates(address _exchangeRates) external;

    function effectiveValue(bytes32 sourceCurrencyKey, uint256 sourceAmount, bytes32 destinationCurrencyKey) external view returns(uint256);

    function transferableSynthetix(address account) external view returns(uint256);

    function validateGasPrice(uint256 _givenGasPrice) external view;

    function balanceOf(address account) external view returns(uint256);

    function availableCurrencyKeys() external view returns(bytes32[]);

    function acceptOwnership() external;

    function remainingIssuableSynths(address issuer, bytes32 currencyKey) external view returns(uint256);

    function availableSynths(uint256) external view returns(address);

    function totalIssuedSynths(bytes32 currencyKey) external view returns(uint256);

    function addSynth(address synth) external;

    function owner() external view returns(address);

    function setExchangeEnabled(bool _exchangeEnabled) external;

    function symbol() external view returns(string);

    function gasPriceLimit() external view returns(uint256);

    function setProxy(address _proxy) external;

    function selfDestruct() external;

    function integrationProxy() external view returns(address);

    function setTokenState(address _tokenState) external;

    function collateralisationRatio(address issuer) external view returns(uint256);

    function rewardEscrow() external view returns(address);

    function SELFDESTRUCT_DELAY() external view returns(uint256);

    function collateral(address account) external view returns(uint256);

    function maxIssuableSynths(address issuer, bytes32 currencyKey) external view returns(uint256);

    function transfer(address to, uint256 value) external returns(bool);

    function synthInitiatedExchange(address from, bytes32 sourceCurrencyKey, uint256 sourceAmount, bytes32 destinationCurrencyKey, address destinationAddress) external returns(bool);

    function transferFrom(address from, address to, uint256 value, bytes data) external returns(bool);

    function feePool() external view returns(address);

    function selfDestructInitiated() external view returns(bool);

    function setMessageSender(address sender) external;

    function initiateSelfDestruct() external;

    function transfer(address to, uint256 value, bytes data) external returns(bool);

    function supplySchedule() external view returns(address);

    function selfDestructBeneficiary() external view returns(address);

    function setProtectionCircuit(bool _protectionCircuitIsActivated) external;

    function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns(uint256);

    function synthetixState() external view returns(address);

    function availableSynthCount() external view returns(uint256);

    function allowance(address owner, address spender) external view returns(uint256);

    function escrow() external view returns(address);

    function tokenState() external view returns(address);

    function burnSynths(bytes32 currencyKey, uint256 amount) external;

    function proxy() external view returns(address);

    function issueMaxSynths(bytes32 currencyKey) external;

    function exchangeEnabled() external view returns(bool);
}

interface Uniswap {
    function getEthToTokenInputPrice(uint256 ethSold) external view returns(uint256);

    function getEthToTokenOutputPrice(uint256 tokensBought) external view returns(uint256);

    function getTokenToEthInputPrice(uint256 tokensSold) external view returns(uint256);

    function getTokenToEthOutputPrice(uint256 ethBought) external view returns(uint256);
}

interface ERC20 {
    function totalSupply() public view returns(uint supply);

    function balanceOf(address _owner) public view returns(uint balance);

    function transfer(address _to, uint _value) public returns(bool success);

    function transferFrom(address _from, address _to, uint _value) public returns(bool success);

    function approve(address _spender, uint _value) public returns(bool success);

    function allowance(address _owner, address _spender) public view returns(uint remaining);

    function decimals() public view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract IERC20Token {
    // these functions aren't abstract since the compiler emits automatically generated getter functions as external
    function name() public view returns(string) {}

    function symbol() public view returns(string) {}

    function decimals() public view returns(uint8) {}

    function totalSupply() public view returns(uint256) {}

    function balanceOf(address _owner) public view returns(uint256) {
        _owner;
    }

    function allowance(address _owner, address _spender) public view returns(uint256) {
        _owner;
        _spender;
    }

    function transfer(address _to, uint256 _value) public returns(bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);

    function approve(address _spender, uint256 _value) public returns(bool success);
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

// Oracle Feed Contract
contract orfeedpremium {


}

function getKyberPrice(string symb1, string symb2, string side, amount){

}
