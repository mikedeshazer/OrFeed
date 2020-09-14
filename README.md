# OrFeed

[![Discord](https://img.shields.io/discord/671195829524103199)](https://discord.gg/byCPVsY)


```OrFeed is currently being refactored.```

```The next release will be OrFeed 0.5.```

```Current functionality will not be affected / All current contracts will operate as normal, but new ones will be deployed that are hopefully better and do more.```

```What's coming? Code will be cleaner, tests will be at the core, Ganache and mainnet forks will be documented, and a newer Solidity compiler will be used. ```


### Homemade high-reliability oracle aggregator for Ethereum-based DeFi apps that need on and off-chain data, with a bit of streamlined execution functionality in there, as well.


![OrFeed Logo](https://www.orfeed.org/images/orfeed.png)


Website: [orfeed.org](https://www.orfeed.org)

## [Try out](https://www.orfeed.org/explorer) OrFeed

[![Test Drive Button](https://www.orfeed.org/images/testdrive.png)](https://www.orfeed.org/explorer)

[OrFeed DeFi Arbitrage Discovery Tool](https://www.orfeed.org/defiarbfinder)

[The Reality Stone on the Blockchain](https://medium.com/proof-of-fintech/the-reality-stone-on-the-blockchain-accessible-to-all-1654a3ec71a7) blog post

[How OrFeed Was Conceived](https://medium.com/proof-of-fintech/introducing-orfeed-aa323342d34c) blog post

A [Use-Case](https://medium.com/proof-of-fintech/how-a-penny-can-affect-billions-a88c0837d17e) blog post

[OrFeed DAO](https://medium.com/proof-of-fintech/why-defi-needs-an-oracle-management-dao-8eec65c2e15b) proposal blog post


Etherscan Smart Contract Interface: [https://etherscan.io/dapp/0x8316b082621cfedab95bf4a44a1d4b64a6ffc336](https://etherscan.io/dapp/0x8316b082621cfedab95bf4a44a1d4b64a6ffc336) (Helper: getExchangeRate is a good place to start)

Oracle Price/Numerical Data Registry [dApp](https://etherscan.io/dapp/0x74b5ce2330389391cc61bf2287bdc9ac73757891)

General Data/Event Result Registry [dApp](https://etherscan.io/address/0xd754f58d9d6d705b98bde698f9f9cec0bded1b8a#writeContract)

[Youtube video tutorial](https://youtu.be/LK1BiSveEI4)


## Getting Started

At the top of your smart contract or in a referenced file in your dApp project, include this interface.

If you're using Solidity 0.5.0+:

```javascript
pragma experimental ABIEncoderV2;

interface OrFeedInterface {
  function getExchangeRate ( string calldata fromSymbol, string calldata  toSymbol, string calldata venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string calldata  symbol ) external view returns ( address );
  function getSynthBytes32 ( string calldata  symbol ) external view returns ( bytes32 );
  function getForexAddress ( string calldata symbol ) external view returns ( address );
  function arb(address  fundsReturnToAddress,  address liquidityProviderContractAddress, string[] calldata   tokens,  uint256 amount, string[] calldata  exchanges) external payable returns (bool);
}
```

Under Solidity 0.5.0:


```javascript
interface OrFeedInterface {
  function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string symbol ) external view returns ( address );
  function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );
  function getForexAddress ( string symbol ) external view returns ( address );
  function requestAsyncEvent(string eventName, string source)  external returns(string);
  function getAsyncEventResult(string eventName, string source, string referenceId) external view returns (string);
  function arb(address fundsReturnToAddress, address liquidityProviderContractAddress, string[] tokens,  uint256 amount, string[] exchanges) payable returns (bool);
}
```



To Initialize OrFeed on mainnet, simply include this code:

```javascript
OrFeedInterface orfeed= OrFeedInterface(0x8316B082621CFedAB95bf4a44a1d4B64a6ffc336);

```

Ganache and Truffle documentation coming soon.


One of the best things about OrFeed is that OrFeed automatically detects which kind of asset you are looking for (though the data can come from different providers), as the parameter of "venue" when making the getExchangeRate call. For example, you can get the price for ETH/USD the same way you get the price for JPY/ETH. The 3rd parameter is the venue. Use blank ('') for default oracle. In the future, you can reference several venues/providers to get their data and throw out any that deviate too far from the average.

```javascript
uint jpyusdPrice = orfeed.getExchangeRate("JPY", "USD", "DEFAULT", 100000);
// returns 920 (or $920.00)
```

Note: Replace "DEFAULT" with the oracle provider you would like data from. For example, if you want to know Uniswap's price on the buy side, use "BUY-UNISWAP-EXCHANGE". If you want Kyber's sell side data for the same, you can use "SELL-KYBER-EXCHANGE". Due to the way Bancor works with swaps/liquidity paths, you can simply use "BANCOR" when querying Bancor. Because ERC-20s have many, many integers, when getting prices from token to token, be sure to use very large amounts.... 1000000000 DAI is less than one penny, for example, due to divisibility at 18.

More examples:

```javascript
uint price = orfeed.getExchangeRate("ETH", "USDC", "UNISWAPBYSYMBOLV1", 100000000000000);
```

Supports Uniswap v.2 as follows:

```javascript
uint price = orfeed.getExchangeRate("ETH", "USDC", "UNISWAPBYSYMBOLV2", 100000000000000);
```

Get prices by address on Uniswap v.2 using the `UNISWAPBYADDRESSV2` provider. WETH/DAI example:

```javascript
uint price = orfeed.getExchangeRate("0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", "0x6B175474E89094C44Da98b954EedeAC495271d0F", "UNISWAPBYADDRESSV2", 10000000000000000);
```



```javascript
uint price = orfeed.getExchangeRate("BTC", "DAI", "SELL-UNISWAP-EXCHANGE", 100);
```

```javascript
uint price = orfeed.getExchangeRate("ETH", "DAI", "BANCOR", 1000000000000000);
```

```javascript
uint price = orfeed.getExchangeRate("MKR", "EUR", "", 100000000000000);
```


Experimental:


```javascript
uint price = orfeed.getExchangeRate("AAPL", "USD", "PROVIDER1", 1);
```


Additionally, you can do hacky things like retrieve a "safe" gas price that prevents front-running within your dApp by querying Synthetix's `gasPriceLimit`.


```javascript
uint gasLimit = orfeed.getExchangeRate("skip", "skip", "synthetix-gas-price-limit", 0);
```


## Data And Event Oracles

In addition to pricing and numerical data, string data can also be retrieved using the get `getEventResult` method. You can get string data from registered OrFeed oracles (who can optionally leave notes about how their oracles work and other details). This can be used for sporting events, documents, and notes that one might want to store permanently/temprarily with an expiration for when aliens come and want data on what the human were up to. You can register an oracle via this OrFeed [dApp](https://etherscan.io/address/0xd754f58d9d6d705b98bde698f9f9cec0bded1b8a#writeContract) and set tules for how you would like to return data based on parameters sent (example: /contracts/examples/ProvideDataExamples/userRegisteredDataOrEventOracleExample.sol). Usage for retrieving data example:

```javascript
string memory info = orfeed.getEventResult("skip", "satoshi-first-block");
```
Returns: The Times 03/Jan/2009 Chancellor on brink of second bailout for banks



## RESTful API

You can access the getExchangeRate functionality via RESTful API calls. e.g.
```javascript
https://api.orfeed.org/getExchangeRate?fromSymbol=JPY&toSymbol=USD&venue=DEFAULT&amount=10000000000000000
```

More of OrFeed's smart contract functionality will be added to RESTful calls soon. You can find the source code for the Node.js API app in /nodeJSAppExamples/orfeedapi



## Providing Data As An Oracle Provider

You can register a provider name and connect it to your custom oracle contract (DNS-style) via the OrFeed Oracle Registry: [here](https://etherscan.io/dapp/0x74b5ce2330389391cc61bf2287bdc9ac73757891) by calling the registerOracle function.
Additionally, you can tranfer the oracle name, provide contact details in case you are considering selling it, and discover other oracle providers via the smart contract.
An example of an oracle smart contract that will be compatible with the OrFeed proxy contract is available in /contracts/examples/ProvideDataExamples/userGeneratedOracleExample.sol (very simple example that either returns 500 or 2)
Once you deploy your contract and register it to the registry (paying a small amount of ETH to prevent spamming of names), you can check/verify your registration by calling the getOracleAddress function.

As more reputable, as well as trustless, oracle smart contracts register within the OrFeed registry, we will update a new list as a reference.


## Source and Asset Examples (Currently on Main-net)


| Asset       | Example Provider (Venue)           | Type  |
| ------------- |:-------------:| -----:|
| ETH      | DEFAULT | Cryptocurrency |
| BTC      | DEFAULT | Cryptocurrency |
| DAI      | KYBERBYSYMBOLV1      |   Token |
| USDC | UNISWAPBYSYMBOLV1   |    Token |
| LINK | UNISWAPBYSYMBOLV2   |    Token |
| MKR      | BANCOR | Token |
| KNC      | DEFAULT      |   Token |
| ZRX | DEFAULT    |    Token |
| TUSD | DEFAULT    |    Token |
| SNX | DEFAULT    |    Token |
| CUSDC | DEFAULT    |    Token |
| BAT | DEFAULT    |    Token |
| OMG | DEFAULT    |    Token |
| SAI | DEFAULT    |    Token |
| JPY | DEFAULT    |    Forex |
| EUR | DEFAULT    |    Forex |
| CHF | DEFAULT    |    Forex |
| USD | DEFAULT    |    Forex |
| GBP | DEFAULT    |    Forex |
| AAPL | PROVIDER1    |    Equity |
| MSFT | PROVIDER1    |    Equity |
| GOOGL | PROVIDER1    |    Equity |
| NFLX | PROVIDER1    |    Equity |
| BRK.A | PROVIDER1    |    Equity |
| FB | PROVIDER1    |    Equity |
| BABA | PROVIDER1    |    Equity |
| V | PROVIDER1    |    Equity |
| JNJ | PROVIDER1    |    Equity |
| TSLA | PROVIDER1    |    Equity |
| JPM | PROVIDER1    |    Equity |
| DIS | PROVIDER1    |    Equity |
| SPX | PROVIDER1    |    ETF |
| VOO | PROVIDER1    |    ETF |
| QQQ | PROVIDER1    |    ETF |
| GLD | PROVIDER1    |    ETF |
| VXX | PROVIDER1    |    ETF |



The top 20 ERC-20 tokens are available.

contracts/pegTokenExample.sol contains a template code and live contract reference for a token using OrFeed data that is pegged to the value of an off-chain asset (Alibaba Stock in the example). We are looking forward to less primitive examples that leverage DAOs, advanced collateralization techniques, etc. Also, contracts/levFacility.sol is in very early stages and is the begining of creating a token that has a built-in leveraged short/long credit facility for margin trading of futures settled by OrFeed data (very early).

Note: "PROVIDER1" was the first external financial data provider for the OrFeed oracle system, and you can check the updates from this address on mainnet: 0xc807bef0cc81911a34b1a9a0dad29fd78fa7e703. The code example to run your own external data oracle is located in /contracts/examples/ProvideDataExamples/stockETFPriceContract.sol (smart contract) and /contracts/examples/oraclenodeExampleApp (for node application to interface with that smart contract)



## DeFi Interest Rate Data/Calculator

Learn more here: [Youtube Tutorial](https://www.youtube.com/watch?v=AFBi_2c6CUQ)


## DeFi Legos Tutorials

Vulnerability/exploit smart contract examples, DeFi mock contracts/projects and other files from Youtube and Coursera material can be found in `/contracts/examples/tutorialSamples/`


## Examples

The contracts/examples folder contains contracts for both writing data as an oracle provider and for consuming data as an oracle consumer.

The /nodeJSAppExamples folder contains Node.js apps that interface with smart contracts that either read or write oracle data



## Getting Data From [Chainlink](https://chain.link/) via OrFeed

You can retrieve data from a website (off-chain) asynchronously via the Chainlink integration. To use this feature, please follow these steps:

1. Make sure you have [LINK](https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca) coins in your wallet that you are making the request from. If you don't have LINK, you can visit Uniswap.io or Kyberswap to convert Ether to LINK. You will need .1 LINK per request.

2. Approve the OrFeed Chainlink proxy contract to use your LINK coins to pay the Chainlink fees. Visit [https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca#writeContract](https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca#writeContract) and use the "Approve" function. In the "_spender" field, paste this address: 0xa0f806d435f6acaf57c60d034e57666d21294c47. In the "_amount" field, input: 100000000000000000000000000. Additionally, at the top of the page, right above the approve function, make sure to click Connect to Web3.

Optionally, for subsidized LINK fees, you can use PRFT token to pay for fees (.01 PRFT per request). Visit [https://etherscan.io/token/0xc5cea8292e514405967d958c2325106f2f48da77#writeContract](https://etherscan.io/token/0xc5cea8292e514405967d958c2325106f2f48da77#writeContract) and use the "Approve" function in the same way you would do for LINK described above.




Now you are ready!

```javascript
string status = orfeed.requestAsyncEvent("https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD", "CHAINLINK");
```

After 1 to 3 blocks, Chainlink will send the website data to OrFeed and you can access that data without making a transaction (synchronously). Additionally, you can access data from websites that others have already paid for by inputting their the URL.

```javascript
string result = orfeed.getAsyncEventResult("https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD", "CHAINLINK", "");
```

Similar integrations with Augur, Provable and Band Protocol are coming soon.


Once your transaction has been confirmed on the blockchain, Chainlink then waits 1-3 blocks and sends the response from their smart contract.


## Understanding the OrFeed.arb method

### Primer

Trianglular arbitrage enables a user to perform a multi-point exchange of funds between specified Assets on supported decentralized exchanges. The orfeed.arb method also supports a simple 2-way exchange, in addition to multi-way exchange. Additionally, you can try flash loans from Aave which are built directly into the tool.

Example usage

Simple 3-Way trade in which `0x08906e8e5193929181011043b52432973E5F8446` is your account or the account that should receive the assets at the end of the transaction:
```
orfeed.arb('0x08906e8e5193929181011043b52432973E5F8446', '0x08906e8e5193929181011043b52432973E5F8446', ["DAI","MKR","USDC"], 5000000000000000000, ["KYBER","UNISWAP","KYBER"]);
```

Same Simple 3-Way trade as above with an Aave Flash Loan and much higher amount:
```
orfeed.arb('0x08906e8e5193929181011043b52432973E5F8446', '0x398eC7346DcD622eDc5ae82352F02bE94C62d119', ["ETH","DAI","MKR","USDC"], 5000000000000000000000, ["SKIP","KYBER","UNISWAP","KYBER"]);
```

For simple mult-way trades using your own capital, approve the orfeed contract: `0x8316b082621cfedab95bf4a44a1d4b64a6ffc336`

For simple multi-way way trades using Aave capital, approve the orfeed flash loan contract: `0xc6eba20877dc64e920975b9f5e6f1a0da48ee68e`




### [OrFeed Angle](https://www.orfeed.org/angle)

OrFeed [Angle](https://www.orfeed.org/angle) provides a user interface to engage in triangle arbitrage and test OrFeed's arb method. Configuring the Angle system with your wallet of choice will require approving access between the OrFeed contract and one of your tokens. For example, in order to perform arbitrage between USDC, ETH and DAI a user will be required to confirm an approval transaction for the first of the three tokens (USDC in this case).

### OrFeed Arb method

The OrFeed contract provides a function called `arb` which is used to perform a streamlined triangular arbitrage operation.

### Example of the Arb method

Provided in this repository is a smart contract which uses the arb function in conjunction with a flash loan as a source of funds.

+ [Arb function used with a Flash Loan](https://github.com/ProofSuite/OrFeed/blob/0145979b9428ce10b1b6bc892b1ceb10cc955688/contracts/examples/tutorialSamples/flashLoanWithArb.sol)

### Parameters of the Arb Method

`address fundsReturnToAddress` - After execution this is the address funds are sent to to conclude the operation

`address liquidityProviderContractAddress` - The address that will be used as a source of liquidity. Can be the same value as `fundsReturnToAddress`

`string[] tokens` - An array containing the symbols or 2 or three tokens to be arbitraged

`uint256 amount` - The amount of funds that will be used for the arbitrage

`string[] exchanges` - An array containing the names of 2 or 3 exchange which will be used during the arbitrage

## Testing

To test that the contracts are working well in the respective networks, please do the following

1. Install `node.js` in your system/environment, if it is not installed already.
2. Install truffle globall, once `node.js` is done installing i.e. `yarn global add truffle` and then install the project dev-dependencies too i.e. `yarn install`
3. Create a `.secrets` file in the root folder of this project, and paste into it the `mnemonic phrase` of the the wallet you want to use for testing in the respective network i.e. mainnet, kovan or rinkeby.
4. Enter the infura `project-ID` for the infura project you are using to test in either of the networks, in the file `truffle-config.js`.
5. Make sure the wallet has enough eth for testing. Atleast `$5` should be enough for both contract deployment and testing.
6. Finally run either of the following commands to test the contracts, depending on the network,
  - `truffle test --mainnet` for the main ethereum network, be careful though as this will cost you real money.
  - `truffle test --kovan` for the kovan test network.
  - `truffle test --rinkeby` for the rinkeby test network.

### Read the full docs [orfeed.org/docs](https://www.orfeed.org/docs)

Common default data providers when venue parameters are left blank are Kyber, Uniswap, Chainlink and Synthetix.

Future private/premium data may be provided as follows (though we are to suggestions, and welcome you to join the OrFeed DAO where we will be voting on future governance decisions):

![How it all fits together](https://www.orfeed.org/images/diagram.png)

### Demos on Testnets

These can often fall out-of-date as we take a MainNet-first approach as most of the OrFeed functionality does not require gas, as OrFeed serves as a proxy to many other contracts.

**Kovan**: [0x31a29958301c407d4b4bf0d53dac1f2d154d9d8d](https://kovan.etherscan.io/address/0x31a29958301c407d4b4bf0d53dac1f2d154d9d8d)  
**Rinkeby**: [0x97875355ef55ae35613029df8b1c8cf8f89c9066](https://rinkeby.etherscan.io/address/0x97875355ef55ae35613029df8b1c8cf8f89c9066)


### Works Provided As Inspiration Of Thought Through Development:

[William George, Clément Lesaege: Smart Contract Oracle for Approximating Real-World, Real Number Values](http://drops.dagstuhl.de/opus/volltexte/2019/11396/pdf/OASIcs-Tokenomics-2019-6.pdf)

[Aragon Network Whitepaper](https://github.com/aragon/whitepaper)

[Vitalik Buterin: Minimal Anti-Collusion Infrastructure ](https://ethresear.ch/t/minimal-anti-collusion-infrastructure/5413)


## Contributing

OrFeed's source code is [licensed under the Apache 2.0 license](https://github.com/ProofSuite/OrFeed/blob/master/LICENSE), and we welcome contributions.

The preferred branch of pull requests is the `develop` branch. Additionally, we are frequently adding small bounties on Gitcoin for mission-critical initiatives.

Thanks for being awesome!
