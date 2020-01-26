// random number oracle example contract
// fromParam and toParam must be positive integers of less than 100 digits. amount can be extra entropy to generate the random number.

interface OrFeedInterface {
    function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );
    function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
    function getTokenAddress ( string symbol ) external view returns ( address );
    function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );
    function getForexAddress ( string symbol ) external view returns ( address );
}

contract randomregisteredoracleExample {
    OrFeedInterface orfeed = OrFeedInterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);

    address owner;
    modifier onlyOwner() {
        assert (msg.sender == owner);
        _;
    }

    constructor() public payable {
        owner = msg.sender;
    }

    function getPriceFromOracle(string fromParam, string toParam, string, uint256 amount) public returns (uint256){
        uint256 start = stringToUint(fromParam);
        uint256 end = stringToUint(toParam);
        assert(start < end);
        uint256 width = end - start;

        uint256 rate1 = orfeed.getExchangeRate("MKR", "DAI", "DEFAULT", 10000000);
        uint256 rate2 = orfeed.getExchangeRate("ETH", "DAI", "DEFAULT", 10000000);
        uint256 rate3 = orfeed.getExchangeRate("WBTC", "ETH", "DEFAULT", 10000000);
        uint256 rate4 = orfeed.getExchangeRate("KNC", "ETH", "DEFAULT", 10000000);
        uint256 rate5 = orfeed.getExchangeRate("SNX", "ETH", "DEFAULT", 10000000);
        uint256 seed = uint256(keccak256(abi.encodePacked(amount, block.coinbase, block.difficulty, block.timestamp, rate1, rate2, rate3, rate4, rate5)));
        return (seed % width) + start;
    }

    function stringToUint(string s) pure private returns (uint) {
        bytes memory b = bytes(s);
        assert(b.length < 100);
        uint result = 0;
        for (uint i = 0; i < b.length; i++) {
            assert(b[i] >= 48 && b[i] <= 57);
            result = result * 10 + (uint(b[i]) - 48);
        }
        return result;
    }


    function changeOwner(address newOwner) onlyOwner public returns(bool){
        owner = newOwner;
        return true;
    }

    function withdrawBalance() onlyOwner public returns(bool) {
        uint amount = this.balance;
        msg.sender.transfer(amount);
        return true;
    }
}
