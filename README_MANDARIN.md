# OrFeed 智能合约

## 数字资产、外汇、股票、交易所交易基金等分散价格馈送

一款高度可靠的oracle，适用于基于以太坊的需要外部财务数据的DEFI应用。

![OrFeed Logo](https://www.orfeed.org/images/orfeed.png)


网站: [orfeed.org](https://www.orfeed.org)

[The Reality Stone on the Blockchain](https://medium.com/proof-of-fintech/the-reality-stone-on-the-blockchain-accessible-to-all-1654a3ec71a7) 博客帖子

[How OrFeed Was Conceived](https://medium.com/proof-of-fintech/introducing-orfeed-aa323342d34c) 博客帖子

演示: [https://etherscan.io/dapp/0x8316b082621cfedab95bf4a44a1d4b64a6ffc336](https://etherscan.io/dapp/0x8316b082621cfedab95bf4a44a1d4b64a6ffc336)

[Youtube video tutorial](https://youtu.be/LK1BiSveEI4)


## 入门指南

在智能合约的顶部或dApp项目中的引用文件中，包含此界面。

```javascript
interface OrFeedInterface {
  function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string symbol ) external view returns ( address );
  function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );
  function getForexAddress ( string symbol ) external view returns ( address );
}
```

要初始化OrFeed，只需包含以下代码:

```javascript
OrFeedInterface orfeed= OrFeedinterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);

```

OrFeed的一个优点是OrFeed会自动检测您在寻找哪种资产(尽管数据可能来自不同的提供者)，作为进行getExchangeRate调用时“venue”的参数。例如，您可以像获取JPY/ETH一样获取ETH/USD的价格。第三个参数是venue。默认oracle使用空白('')。将来，您可以参考几个venues/providers来获取数据，并丢弃任何偏离平均值太远的数据。

```javascript
uint jpyusdPrice = orfeed.getExchangeRate("JPY", "USD", "DEFAULT", 100000);
// returns 920 (or $920.00)
```

注意:用您希望从中获取数据的oracle提供程序替换“DEFAULT”。例如，如果你想知道购买方的Uniswap价格，使用“BUY-UNISWAP-EXCHANGE”。如果你希望Kyber销售相同的辅助数据，你可以使用“SELL-Kyber-EXchange”。 因为ERC-20s有很多整数，所以在从一个令牌到另一个令牌获取价格时，一定要使用非常大的数量....举例来说，1000000000 DAI不到一便士，因为可以被18整除。

更多示例:

```javascript
uint price = orfeed.getExchangeRate("ETH", "USDC", "BUY-KYBER-EXCHANGE", 100000000000000);
```

```javascript
uint price = orfeed.getExchangeRate("BTC", "DAI", "SELL-UNISWAP-EXCHANGE", 100);
```

```javascript
uint price = orfeed.getExchangeRate("MKR", "EUR", "", 100000000000000);
```


实验性:


```javascript
uint price = orfeed.getExchangeRate("AAPL", "USD", "PROVIDER1", 1);
```


股票和交易所交易基金是由一个集中的oracle公司提供的，我们目前正在开发一个登记册，在这个登记册中，可以向任何提供者(集中或分布式)提出请求...或者，当然，与异常值的去除相结合(推荐)。目前的合约支持市值前10名的股票(AAPL、AMZN、JNJ等)和前5名的交易所交易基金(SPY等)

您可以通过在/examples/oracleNodeExampleApp(合同代码在contacts/stocketfpriceContract.sol中)中部署具有示例代码的节点应用程序来运行您自己的oracle，并以您选择的更新频率提供尽可能多的库存。我们建议购买燃气代币(我们绝不是附属机构，也不是先令)，以降低您的以太网费用风险(因此，如果您计划长时间运行oracle，您可以支付合理的燃气价格)。否则，您将面临汽油费价格风险，或者您的价格可能不会按照您希望的频率更新。

## 来源和资产示例 (当前活动)


| 资产       | 示例提供者 (Venue)           | 类型  |
| ------------- |:-------------:| -----:|
| ETH      | DEFAULT | 密码货币 |
| BTC      | DEFAULT | 密码货币 |
| DAI      | BUY-KYBER-EXCHANGE      |   代币 |
| USDC | SELL-UNISWAP-EXCHANGE    |    代币 |
| MKR      | DEFAULT | 代币 |
| KNC      | DEFAULT      |   代币 |
| ZRX | DEFAULT    |    代币 |
| TUSD | DEFAULT    |    代币 |
| SNX | DEFAULT    |    代币 |
| CUSDC | DEFAULT    |    代币 |
| BAT | DEFAULT    |    代币 |
| OMG | DEFAULT    |    代币 |
| SAI | DEFAULT    |    代币 |
| JPY | DEFAULT    |    外汇 |
| EUR | DEFAULT    |    外汇 |
| CHF | DEFAULT    |    外汇 |
| USD | DEFAULT    |    外汇 |
| GBP | DEFAULT    |    外汇 |
| AAPL | PROVIDER1    |    股份 |
| MSFT | PROVIDER1    |    股份 |
| GOOGL | PROVIDER1    |    股份 |
| NFLX | PROVIDER1    |    股份 |
| BRK.A | PROVIDER1    |    股份 |
| FB | PROVIDER1    |    股份 |
| BABA | PROVIDER1    |    股份 |
| V | PROVIDER1    |    股份 |
| JNJ | PROVIDER1    |    股份 |
| TSLA | PROVIDER1    |    股份 |
| JPM | PROVIDER1    |    股份 |
| DIS | PROVIDER1    |    股份 |
| SPX | PROVIDER1    |    ETF |
| VOO | PROVIDER1    |    ETF |
| QQQ | PROVIDER1    |    ETF |
| GLD | PROVIDER1    |    ETF |
| VXX | PROVIDER1    |    ETF |



contracts/pegtokeExample.sol包含令牌的模板代码和实时合同引用，该令牌使用OrFeed数据，该数据与离线资产(示例中的阿里巴巴股票)的价值挂钩。我们期待着利用DAo、高级抵押技术等不那么原始的例子。

## 测试

要测试合同在各自的网络中运行良好，请执行以下操作

1. 如果尚未安装，请在您的系统/环境中安装`node.js`。
2. 安装truffle global，一旦`node.js`安装完成，即`yarn global add truffle`，然后也安装项目dev-dependencies，即`yarn install`
3. 在此项目的root文件夹中创建一个`.secrets`文件，并粘贴到您要用于在相应网络(即mainnet、kovan或rinkeby)中进行测试的钱包的`mnemonic phrase`中。
4. 在文件`truffle-config.js`中，为您用于在任一网络中测试的infura项目输入infura `project-ID`。
5. 确保钱包有足够的ETH用于测试。至少5美元对于合同部署和测试都应该足够了。
6. 最后运行以下任一命令来测试合同，具体取决于网络:
  - `truffle test --mainnet` 对于以太网mainnet，要小心，因为这会花掉你很多钱。
  - `truffle test --kovan` 用于kovan试验网络。
  - `truffle test --rinkeby` 用于rinkeby试验网络。

### 阅读完整的文档 [orfeed.org/docs](https://www.orfeed.org/docs)

免费数据由Kyber、Uniswap和Synthetix提供。

保费数据提供如下:

![How it all fits together](https://www.orfeed.org/images/diagram.png)

### 测试网演示
OrFeed演示已经部署到测试网  
**Kovan**: [0x31a29958301c407d4b4bf0d53dac1f2d154d9d8d](https://kovan.etherscan.io/address/0x31a29958301c407d4b4bf0d53dac1f2d154d9d8d)  
**Rinkeby**: [0x97875355ef55ae35613029df8b1c8cf8f89c9066](https://rinkeby.etherscan.io/address/0x97875355ef55ae35613029df8b1c8cf8f89c9066) 


### 通过发展作为思想灵感提供的作品:

[William George, Clément Lesaege: Smart Contract Oracle for Approximating Real-World, Real Number Values](http://drops.dagstuhl.de/opus/volltexte/2019/11396/pdf/OASIcs-Tokenomics-2019-6.pdf)

[Aragon Network Whitepaper](https://github.com/aragon/whitepaper)

[Vitalik Buterin: Minimal Anti-Collusion Infrastructure ](https://ethresear.ch/t/minimal-anti-collusion-infrastructure/5413)



