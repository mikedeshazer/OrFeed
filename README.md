# OrFeed Smart Contract

## Decentralized Price Feed for Crypto, Forex, Stocks, ETFs and more.

A highly reliable oracle for Ethereum-based DeFi apps that need financial data from the outside world.

![OrFeed Logo](https://www.orfeed.org/images/orfeed.png)


Website: [orfeed.org](https://www.orfeed.org)

Demo: [orfeed.netlify.com](https://orfeed.netlify.com)

[Youtube video tutorial](https://youtu.be/LK1BiSveEI4)


## Getting Started

At the top of your smart contract or in a referenced file in your dApp project, include this interface.

```javascript
interface OrFeedInterface {
  function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string symbol ) external view returns ( address );
  function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );
  function getForexAddress ( string symbol ) external view returns ( address );
}
```


To Initialize OrFeed, simply include this code:

```javascript
OrFeedInterface orfeed= OrFeedinterface(0x298e0d904954e5076b1836937cb3b3527adf8783);

```

One of the best things about OrFeed is that OrFeed automatically detects which kind of asset you are looking for (though the data can come from different providers), as the parameter of "venue" when making the getExchangeRate call. For example, you can get the price for ETH/USD the same way you get the price for JPY/ETH. The 3rd parameter is the venue. Use blank ('') for default oracle. In the future, you can reference several venues/providers to get their data and throw out any that deviate too far from the average.

```javascript
uint jpyusdPrice = orfeed.getExchangeRate("JPY", "USD", "", 100000);
// returns 920 (or $920.00)
```


### Read the full docs [orfeed.org/docs](https://www.orfeed.org/docs)

Free data is provided by Kyber, Uniswap and Synthetix. 

Premium data is provided as follows:

![How it all fits together](https://www.orfeed.org/images/diagram.png)



