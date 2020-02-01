# OrFeed

## Alimentación de Precio Descentralizada y Proveedor de Datos del Sitio Web para Smart Contratos Que Necesitan Finanzas, Deportivo y Otra Información Diversa Que Reside En y/o Off-Chain.  

Un agregador oráculo altamente confiable para aplicaciones DeFi basadas en Ethereum que necesitan datos financieros del mundo exterior.

![OrFeed Logo](https://www.orfeed.org/images/orfeed.png)


Sitio: [orfeed.org](https://www.orfeed.org)

## [Probar](https://www.orfeed.org/explorer) OrFeed

[![Test Drive Button](https://www.orfeed.org/images/testdrive.png)](https://www.orfeed.org/explorer)


[La piedra de la realidad en la cadena de Blockchain](https://medium.com/proof-of-fintech/the-reality-stone-on-the-blockchain-accessible-to-all-1654a3ec71a7) blog post

[Cómo se concibió OrFeed](https://medium.com/proof-of-fintech/introducing-orfeed-aa323342d34c) blog post

[Caso de uso](https://medium.com/proof-of-fintech/how-a-penny-can-affect-billions-a88c0837d17e) blog post

Etherscan Smart Contract Interfaz: [https://etherscan.io/dapp/0x8316b082621cfedab95bf4a44a1d4b64a6ffc336](https://etherscan.io/dapp/0x8316b082621cfedab95bf4a44a1d4b64a6ffc336) (Ayudante: getExchangeRate es un buen lugar para comenzar)

[Youtube vídeo tutorial](https://youtu.be/LK1BiSveEI4)


## Primeros pasos

En la parte superior de su Smart Contract o en un archivo referenciado en su proyecto dApp, incluya esta interfaz.

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


Para inicializar OrFeed, simplemente incluya este código:

```javascript
OrFeedInterface orfeed= OrFeedinterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);

```

Una de las mejores cosas de OrFeed es que OrFeed detecta automáticamente qué tipo de activo está buscando (aunque los datos pueden provenir de diferentes proveedores), como el parámetro de "lugar" al realizar la llamada a getExchangeRate. Por ejemplo, puede obtener el precio de ETH / USD de la misma manera que obtiene el precio de JPY / ETH. El tercer parámetro es el lugar. Utilice en blanco ('') para el oráculo predeterminado. En el futuro, puede hacer referencia a varios lugares / proveedores para obtener sus datos y tirar cualquiera que se desvíe demasiado lejos del promedio.
```javascript
uint jpyusdPrice = orfeed.getExchangeRate("JPY", "USD", "DEFAULT", 100000);
// returns 920 (or $920.00)
```

Nota: Reemplace "DEFAULT" con el proveedor de oráculo del que desea obtener datos. Por ejemplo, si desea conocer el precio de Uniswap en el lado de compra, use "BUY-UNISWAP-EXCHANGE". Si desea que los datos secundarios de venta de Kyber para el mismo, puede usar "SELL-KYBER-EXCHANGE". Debido a que los ERC-20 tienen muchos, muchos enteros, al obtener precios de token a token, asegúrese de usar cantidades muy grandes.... 1000000000 DAI es menos de un centavo, por ejemplo, debido a la divisibilidad en 18.
Más ejemplos:

```javascript
uint price = orfeed.getExchangeRate("ETH", "USDC", "BUY-KYBER-EXCHANGE", 100000000000000);
```

```javascript
uint price = orfeed.getExchangeRate("BTC", "DAI", "SELL-UNISWAP-EXCHANGE", 100);
```

```javascript
uint price = orfeed.getExchangeRate("MKR", "EUR", "", 100000000000000);
```


Experimental:


```javascript
uint price = orfeed.getExchangeRate("AAPL", "USD", "PROVIDER1", 1);
```



## RESTful API

Puede acceder a la funcionalidad getExchangeRate a través de llamadas a la API RESTful. Por ejemplo:
```javascript
https://api.orfeed.org/getExchangeRate?fromSymbol=JPY&toSymbol=USD&venue=DEFAULT&amount=10000000000000000
```

MMás de la funcionalidad de contrato inteligente de OrFeed se agregará a las llamadas RESTful pronto. Puede encontrar el código fuente para el Node.js API app in /nodeJSAppExamples/orfeedapi



## Proporcionar datos como un Oráculo Proveedor

Puede registrar un nombre de proveedor y conectarlo a su contrato de oráculo personalizado (estilo DNS) a través del OrFeed Oracle Registry: aquí llamando a la función registerOracle . 
Además, puede transferir el nombre de oráculo, proporcionar datos de contacto en caso de que esté considerando venderlo y descubrir otros proveedores de oráculo a través del contrato inteligente. 
Un ejemplo de un contrato inteligente de oráculo que será compatible con el contrato de proxy OrFeed está disponible en /contracts/examples/ProvideDataExample/userGeneratedOracleExample.sol (ejemplo muy simple que devuelve 500 o 2) 
Una vez que implementa su contrato y lo registra en el registro (pagando una pequeña cantidad de ETH para evitar el envío de spam de nombres), puede verificar / verificar su registro llamando a la función getOracleAddress .

Como contratos inteligentes de oráculo más reputados, así como sin confianza, se registran dentro del registro de OrFeed, actualizaremos una nueva lista como referencia.


## Ejemplos de Fuentes y Activos (Actualmente en MainNet)


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



contracts/pegTokenExample.sol contiene un código de plantilla y una referencia de contrato en vivo para un token utilizando datos de OrFeed que están vinculados al valor de un activo fuera de la cadena (Alibaba Stock en el ejemplo). Esperamos ejemplos menos primitivos que aprovechen DAO, técnicas avanzadas de colateralización, etc. Además, contratos/levFacility.sol se encuentra en etapas muy tempranas y es el comienzo de la creación de un token que tiene una línea de crédito a corto / largo apalancada incorporada para la negociación de márgenes de futuros liquidados por los datos de OrFeed (muy temprano).


Nota: "PROVIDER1" fue el primer proveedor de datos financieros externos para el sistema OrFeed oracle, y puede consultar las actualizaciones desde esta dirección en mainnet: 0xc807bef0cc81911a34b1a9a0dad29fd78fa7e703. El ejemplo de código para ejecutar su propio oráculo de datos externo se encuentra en /contracts/examples/ProvideDataExamples/stockETFPriceContract.sol (smart contract) y /contracts/examples/oraclenodeExampleApp (para que la aplicación de nodo interactúe con eso smart contract)



## Ejemplos

La carpeta de contratos / ejemplos contiene contratos para escribir datos como un proveedor de oráculo y para consumir datos como un consumidor de oráculo.
La carpeta /nodeJSAppExample contiene Node.aplicaciones js que interactúan con smart contratos que leen o escriben datos oráculo


## Obtención de datos de [Chainlink](https://chain.link/) mediante OrFeed

Puede recuperar datos de un sitio web (off-chain) de forma asíncrona a través de la integración de Chainlink. Para utilizar esta función, siga estos pasos:

1. Asegúrese de que tiene [LINK](https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca) monedas en su billetera desde las que está realizando la solicitud. Si no tienes LINK, puedes visitar Uniswap.io o Kyberswap para convertir Ether a LINK. Necesitará .1 LINK por solicitud.

2. Aprobar el contrato de proxy OrFeed Chainlink para usar sus monedas LINK para pagar las tarifas de Chainlink. Visitar [https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca#writeContract](https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca#writeContract) y use la función "Aprobar". En el campo "_spender", pegue esta dirección: 0xa0f806d435f6acaf57c60d034e57666d21294c47. In the "_amount" field, input: 100000000000000000000000000. Además, en la parte superior de la página, justo encima de la función de aprobación, asegúrese de hacer clic en Conectar a Web3.

Opcionalmente, para las tarifas LINK subsidiadas, puede usar el token PRFT para pagar las tarifas (.01 PRFT por solicitud). Visite https://etherscan.io/token/0xc5cea8292e514405967d958c2325106f2f48da77#writeContract y use la función "Aprobar" de la misma manera que lo haría para LINK descrito anteriormente.




¡Ahora estás listo!

```javascript
string status = orfeed.requestAsyncEvent("https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD", "CHAINLINK");
```

Después de 1 a 3 bloques, Chainlink enviará los datos del sitio web a OrFeed y podrá acceder a esos datos sin realizar una transacción (sincrónicamente). Además, puede acceder a datos de sitios web que otros ya han pagado ingresando su URL.

```javascript
string result = orfeed.getAsyncEventResult("https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD", "CHAINLINK", "");
```

Integraciones similares con Augur, Provable y Band Protocol llegarán pronto.


Una vez que su transacción ha sido confirmada en la cadena de bloques, Chainlink espera los bloques 1-3 y envía la respuesta de su contrato inteligente.



## Prueba

Para comprobar que los contratos están funcionando bien en las redes respectivas, haga lo siguiente

1. Instalar `node.js` en su sistema / entorno, si aún no está instalado.
2. Instalar globall trufa, una vez `node.js` se realiza la instalación, es decir, `yarn global add truffle` y luego instala las dependencias dev del proyecto también, es decir, `yarn install`
3. Crear un `.secrets` de secretos en la carpeta raíz de este proyecto, y pegar en él la frase `mnemonic phrase` de la cartera que desea utilizar para las pruebas en la red respectiva, es decir, mainnet, kovan o rinkeby.
4. Introduzca la infura `project-ID` para el proyecto infura que está utilizando para probar en cualquiera de las redes, en el archivo `truffle-config.js`.
5. Asegúrese de que la billetera tenga suficiente eth para probar. Al menos `$5` debería ser suficiente tanto para la implementación del contrato como para las pruebas.
6. Por último, ejecute cualquiera de los siguientes comandos para probar los contratos, dependiendo de la red,
  - `truffle test --mainnet` para la red principal de ethereum, tenga cuidado, ya que esto le costará dinero real.
  - `truffle test --kovan --kovan` para la red de pruebas kovan.
  - `truffle test --rinkeby` para la red de pruebas rinkeby.

### Lea los documentos completos [orfeed.org/docs](https://www.orfeed.org/docs)

Los proveedores de datos predeterminados comunes cuando los parámetros del lugar se dejan en blanco son Kyber, Uniswap, Chainlink y Synthetix.

Los datos privados / premium futuros se pueden proporcionar de la siguiente manera (aunque tenemos sugerencias y le damos la bienvenida a unirse a OrFeed DAO, donde votaremos sobre futuras decisiones de gobierno):

![How it all fits together](https://www.orfeed.org/images/diagram.png)

### Demostraciones en Testnets

Estos a menudo pueden caer desactualizados a medida que tomamos un enfoque de MainNet primero, ya que la mayoría de las funcionalidades de OrFeed no requieren gas, ya que OrFeed sirve como un proxy para muchos otros contratos.
**Kovan**: [0x31a29958301c407d4b4bf0d53dac1f2d154d9d8d](https://kovan.etherscan.io/address/0x31a29958301c407d4b4bf0d53dac1f2d154d9d8d)  
**Rinkeby**: [0x97875355ef55ae35613029df8b1c8cf8f89c9066](https://rinkeby.etherscan.io/address/0x97875355ef55ae35613029df8b1c8cf8f89c9066) 


### Obras Proporcionadas Como Inspiración Del Tensamiento a Través Del Desarrollo:

[William George, Clément Lesaege: Smart Contract Oracle for Approximating Real-World, Real Number Values](http://drops.dagstuhl.de/opus/volltexte/2019/11396/pdf/OASIcs-Tokenomics-2019-6.pdf)

[Aragon Network Whitepaper](https://github.com/aragon/whitepaper)

[Vitalik Buterin: Minimal Anti-Collusion Infrastructure ](https://ethresear.ch/t/minimal-anti-collusion-infrastructure/5413)


## Contribuyendo

El código fuente de OrFeed está licenciado bajo la licencia Apache 2.0, y agradecemos las contribuciones.

La rama preferida de las solicitudes de extracción es la rama de desarrollo. Además, con frecuencia estamos agregando pequeñas recompensas en Gitcoin para iniciativas de misión crítica.

Gracias por ser increíble!
