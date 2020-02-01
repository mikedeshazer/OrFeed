# OrFeed

[![Discord](https://img.shields.io/discord/671195829524103199)](https://discord.gg/byCPVsY)

## Децентрализованный ценовой поток и веб-сайт поставщик данных для смарт-контрактов, которые нуждаются в финансовой, спортивной и другой разнообразной полезной информации, которую можно найти: `On-`, `and/or` или `Off-Chain`.

Высоконадежный oracle агрегатор для приложений DeFi на базе Ethereum, которым требуются финансовые данные внешнего мира.

![OrFeed Logo](https://www.orfeed.org/images/orfeed.png)


Вебсайт и общая информация: [orfeed.org](https://www.orfeed.org)

## [Попробуйте наш продукт в действии](https://www.orfeed.org/explorer) OrFeed

[![Превью ссылка на продукт](https://www.orfeed.org/images/testdrive.png)](https://www.orfeed.org/explorer)


[Камень реальности блокчейна](https://medium.com/proof-of-fintech/the-reality-stone-on-the-blockchain-accessible-to-all-1654a3ec71a7) (отсылка к фильму марвел) блог

[Как родилась идея OrFeed](https://medium.com/proof-of-fintech/introducing-orfeed-aa323342d34c) блог

[Пример использования](https://medium.com/proof-of-fintech/how-a-penny-can-affect-billions-a88c0837d17e) блог

[OrFeed DAO](https://medium.com/proof-of-fintech/why-defi-needs-an-oracle-management-dao-8eec65c2e15b) блог с предложением


Интерфейс Etherscan Smart Contract: [https://etherscan.io/dapp/0x8316b082621cfedab95bf4a44a1d4b64a6ffc336](https://etherscan.io/dapp/0x8316b082621cfedab95bf4a44a1d4b64a6ffc336) (getExchangeRate это хорошее место для начала)

Регистр приложений Oracle [dApp](https://etherscan.io/dapp/0x74b5ce2330389391cc61bf2287bdc9ac73757891)

[Youtube обучающее видео](https://youtu.be/LK1BiSveEI4)


## Начало использования

Вставьте этот интерфейс в начало вашего smart-contract или в выбранный вами файл в вашем проекте dApp.

```javascript
interface OrFeedInterface {
  function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string symbol ) external view returns ( address );
  function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );
  function getForexAddress ( string symbol ) external view returns ( address );
  function requestAsyncEvent(string eventName, string source)  external returns(string);
  function getAsyncEventResult(string eventName, string source, string referenceId) external view returns (string);
}
```


Чтобы инициализировать OrFeed, просто включите этот код:

```javascript
OrFeedInterface orfeed= OrFeedinterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);

```

Одна из лучших особенностей OrFeed заключается в том, что OrFeed автоматически определяет, какой тип актива вы ищете (хотя данные могут поступать от разных поставщиков), в качестве параметра "venue" при выполнении вызова `getExchangeRate`. Например, вы можете получить цену для ETH / USD так же, как вы получаете цену для JPY / ETH. Третий параметр - venue. Используйте пустой ('') для обозревания по умолчанию. В будущем вы можете ссылаться на несколько venues/providers(мест / поставщиков), чтобы получить их данные и убрать любые, которые слишком сильно отличаются от средних.

```javascript
uint jpyusdPrice = orfeed.getExchangeRate("JPY", "USD", "DEFAULT", 100000);
// returns 920 (or $920.00)
```

Примечание: Замените "DEFAULT" провайдером оракула, от которого вы хотите получать данные. Например, если вы хотите узнать цену Uniswap на стороне покупки, используйте "BUY-UNISWAP-EXCHANGE". Если вы хотите, чтобы данные о продажах в Kyber были одинаковыми, вы можете использовать "SELL-KYBER-EXCHANGE". Поскольку у ERC-20 много, много целых чисел, при получении цены от токена к токену обязательно используйте очень большие суммы ... 1000000000 DAI меньше, чем, например, один пенни из-за делимости на 10<sup>18</sup>. 

Больше примеров:

```javascript
uint price = orfeed.getExchangeRate("ETH", "USDC", "BUY-KYBER-EXCHANGE", 100000000000000);
```

```javascript
uint price = orfeed.getExchangeRate("BTC", "DAI", "SELL-UNISWAP-EXCHANGE", 100);
```

```javascript
uint price = orfeed.getExchangeRate("MKR", "EUR", "", 100000000000000);
```


Экспериментально:


```javascript
uint price = orfeed.getExchangeRate("AAPL", "USD", "PROVIDER1", 1);
```


Кроме того, вы можете создавать хитрые вещи, например генерировать случайное число между двумя числами, используя метод getExchangeRate, который вызывает 'random'(«случайное») пространство имен oracle в реестре oracle, а затем вычисляет число на основе метки времени блока, сложности блока, а также динамическая цена BTC, ETH и DAI на Kyber (часто изменяется во время синтаксического анализа блока, поэтому будет сложнее в реализации, чем обычный метод хэша блока-времени / сложности):

```javascript
uint price = orfeed.getExchangeRate("10", "50", "random", 0);
```



## RESTful API

Вы можете получить доступ к функциональности getExchangeRate через вызовы RESTful API, например:
```javascript
https://api.orfeed.org/getExchangeRate?fromSymbol=JPY&toSymbol=USD&venue=DEFAULT&amount=10000000000000000
```

В ближайшее время в RESTful будут добавлены дополнительные функции умного контракта OrFeed. Вы можете найти исходный код для АПИ приложения Node.js в /nodeJSAppExamples/orfeedapi



## Providing Data As An Oracle Provider
## Предоставление данных в качестве поставщика Oracle

Вы можете зарегистрировать имя провайдера и подключить его к своему заказному oracle договору (в стиле DNS) через реестр Oracle OrFeed: [здесь] (https://etherscan.io/dapp/0x74b5ce2330389391cc61bf2287bdc9ac73757891), вызвав функцию registerOracle.
Так же, вы можете передать имя оракула, предоставить контактную информацию на случай, если вы планируете его продать, и найти других поставщиков оракула с помощью смарт-контракта.
Пример умного контракта oracle, который будет совместим с прокси-контрактом OrFeed, доступен в /contracts/examples/ProvideDataExamples/userGeneratedOracleExample.sol (очень простой пример, который возвращает 500 или 2)
Как только вы развернете свой договор и зарегистрируете его в реестре (заплатив небольшую сумму ETH, чтобы предотвратить рассылку имен), вы можете проверить/подтвердить свою регистрацию, вызвав функцию getOracleAddress.

Поскольку в реестре OrFeed регистрируются более авторитетные, а также ненадежные интеллектуальные контракты Oracle, мы обновим новый список в качестве справочного.

## Примеры источников и активов (в настоящее время на MainNet)


| Asset       | Example Provider (Venue)           | Type  |
| ------------- |:-------------:| -----:|
| ETH      | DEFAULT | Cryptocurrency |
| BTC      | DEFAULT | Cryptocurrency |
| DAI      | BUY-KYBER-EXCHANGE      |   Token |
| USDC | SELL-UNISWAP-EXCHANGE    |    Token |
| MKR      | DEFAULT | Token |
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


contract/pegTokenExample.sol содержит код шаблона и ссылку на действующий контракт для токена, использующего данные OrFeed, которые привязаны к значению off-chain актива (в примере Alibaba Stock). Мы с нетерпением ждем менее примитивных примеров, которые используют DAO, передовые методы обеспечения итд. Кроме того, contract/levFacility.sol находится на очень ранних стадиях написания и является началом создания токена, который имеет встроенную кредитную линию для коротких/длинных кредитов. для маржинальной торговли фьючерсами, рассчитанными по данным OrFeed (очень рано).

Примечание: "PROVIDER1" был первым внешним поставщиком финансовых данных для системы oracle, и вы можете проверить обновления с этого адреса в сети: `0xc807bef0cc81911a34b1a9a0dad29fd78fa7e703`. Пример кода для запуска собственного оракула внешних данных находится в /contracts/examples/ProvideDataExamples/stockETFPriceContract.sol (smart contract) и /contract/examples/oraclenodeExampleApp (для приложения узла для взаимодействия с этим умным контрактом)


## Примеры

Папка contract/examples содержит контракты как для записи данных в качестве поставщика oracle, так и для использования данных в качестве потребителя oracle.

Папка /nodeJSAppExamples содержит приложения Node.js, которые взаимодействуют со смарт-контрактами, которые либо читают, либо записывают данные oracle.


## Получение данных от [Chainlink] (https://chain.link/) с помощью OrFeed

Вы можете получать данные с веб-сайта (off-chain) асинхронно через интеграцию Chainlink. Чтобы использовать эту функцию, выполните следующие действия:

1. Убедитесь, что в кошельке, с которого вы делаете запрос, есть [LINK] (https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca) монеты. Если у вас нет LINK, вы можете посетить Uniswap.io или Kyberswap, чтобы конвертировать Ether в LINK. Вам потребуется .1 LINK на запрос.

2. Утвердите контракт с прокси-сервером OrFeed Chainlink, чтобы использовать монеты LINK для оплаты комиссий Chainlink. Перейдите на страницу [https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca#writeContract](https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca#writeContract) и используйте "Approve" функцию. В поле "_spender" вставьте этот адрес: `0xa0f806d435f6acaf57c60d034e57666d21294c47`. В поле "_amount" введите: `100000000000000000000000000`. Кроме того, в верхней части страницы, прямо над функцией подтверждения, обязательно нажмите «Подключиться к Web3».

Дополнительно, для субсидированных комиссий LINK, вы можете использовать токен PRFT для оплаты сборов (.01 PRFT за запрос). Перейдите на страницу [https://etherscan.io/token/0xc5cea8292e514405967d958c2325106f2f48da77#writeContract](https://etherscan.io/token/0xc5cea8292e514405967d958c2325106f2f48da77#writeContract) и воспользуйтесь "Approve" функцией так же, как вы сделали бы с LINK, в примере выше.



Теперь вы готовы!

```javascript
string status = orfeed.requestAsyncEvent("https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD", "CHAINLINK");
```

После 1-3 блоков Chainlink отправит данные веб-сайта в OrFeed, и вы сможете получить доступ к этим данным без проведения транзакции (синхронно). Кроме того, вы можете получить доступ к данным с веб-сайтов, за которые уже заплатили другие, введя их URL.

```javascript
string result = orfeed.getAsyncEventResult("https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD", "CHAINLINK", "");
```

Подобные интеграции с Augur, Provable и Band Protocol скоро появятся.


Как только ваша транзакция будет подтверждена в блокчейне, Chainlink ожидает 1-3 блока и отправляет ответ от их smart contract.


## Тестирование

Чтобы проверить, хорошо ли работают контракты в соответствующих сетях, выполните следующие действия:

1. Установите `node.js` в вашей системе / среде, если он еще не установлен.
2. Установите truffle and globall, как только `node.js` закончит установку, т.е.` yarn global add truffle`, а затем установите проект dev-dependencies, то есть `yarn install`
3. Создайте файл `.secrets` в корневой папке этого проекта и вставьте в него `мнемоническую фразу` кошелька, который вы хотите использовать для тестирования в соответствующей сети, например: mainnet, kovan или rinkeby.
4. Введите infura `project-ID` для проекта infura, который вы используете для тестирования в любой из сетей, в файле `truffle-config.js`.
5. Убедитесь, что в кошельке достаточно eth для тестирования. Примерно `5$` должно быть достаточно как для развертывания контракта, так и для тестирования.
6. Наконец, выполните одну из следующих команд для проверки контрактов, в зависимости от сети:
  - `truffle test --mainnet` для основной сети ethereum будьте осторожны, так как это будет стоить вам реальных денег.
  - `truffle test --kovan` для тестовой сети kovan.
  - `truffle test --rinkeby` для тестовой сети rinkeby.

### Прочитайте полную документацию [orfeed.org/docs](https://www.orfeed.org/docs)

Распространенными поставщиками данных по умолчанию, когда параметры места остаются пустыми, являются Kyber, Uniswap, Chainlink и Synthetix.

Будущие частные/премиум-данные могут быть предоставлены следующим образом (хотя мы ожидаем предложений и приглашаем вас присоединиться к OrFeed DAO, где мы будем голосовать за будущие управленческие решения):

![Как все это сочетается](https://www.orfeed.org/images/diagram.png)

### Демо для Testnet

Они часто могут устаревать, так как мы используем подход MainNet-first, так как большая часть функциональности OrFeed не требует gas, поскольку OrFeed служит прокси для многих других контрактов.

**Kovan**: [0x31a29958301c407d4b4bf0d53dac1f2d154d9d8d](https://kovan.etherscan.io/address/0x31a29958301c407d4b4bf0d53dac1f2d154d9d8d)  
**Rinkeby**: [0x97875355ef55ae35613029df8b1c8cf8f89c9066](https://rinkeby.etherscan.io/address/0x97875355ef55ae35613029df8b1c8cf8f89c9066) 


### Works Provided As Inspiration Of Thought Through Development:
### Работы, которые вдохновляли нас во время развития:

[William George, Clément Lesaege: Smart Contract Oracle for Approximating Real-World, Real Number Values](http://drops.dagstuhl.de/opus/volltexte/2019/11396/pdf/OASIcs-Tokenomics-2019-6.pdf)

[Aragon Network Whitepaper](https://github.com/aragon/whitepaper)

[Vitalik Buterin: Minimal Anti-Collusion Infrastructure](https://ethresear.ch/t/minimal-anti-collusion-infrastructure/5413)


## Разработка

Исходный код OrFeed [licensed under the Apache 2.0 license](https://github.com/ProofSuite/OrFeed/blob/master/LICENSE), и мы рады новым разработчикам. (Таким как тот, который перевёл всё это на русский :-))

Предпочтительной ветвью для пул реквестов является ветвь `develop`. Кроме того, мы часто добавляем небольшие денежные бонусы на Gitcoin для критически важных инициатив.

Спасибо вам большое!
