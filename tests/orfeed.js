const OrFeed = artifacts.require('./orfeed.sol')
import assert, { equal } from 'assert'

contract('OrFeed', async accounts => {

    let NETWORK = process.env.NETWORK;

    before(async () => {
      if (NETWORK === 'mainnet') {
        contractInstance = await Orfeed.at("0x8316b082621cfedab95bf4a44a1d4b64a6ffc336")
      } else {
        contractInstance = await OrFeed.deployed()
      }
    })
    
    it('should return a JPY/USD exchange rate that is greater than zero', async () => {
      const price = await contractInstance.getExchangeRate("JPY", "USD", "DEFAULT", 100000);
      assert.isAbove(price, 0, 'The JPY/USD rate returned is greater than zero')
    })

    it('should return an ETH/USDC kyber swap, exchange rate that is greater than zero', async () => {
      const price = await contractInstance.getExchangeRate("ETH", "USDC", "BUY-KYBER-EXCHANGE", 100000000000000);
      assert.isAbove(price, 0, 'The ETH/USDC rate returned is greater than zero')
    })

    it('should return a BTC/DAI uniswap-swap, exchange rate that is greater than zero', async () => {
      const price = await contractInstance.getExchangeRate("BTC", "DAI", "SELL-UNISWAP-EXCHANGE", 100);
      assert.isAbove(price, 0, 'The BTC/DAI rate returned is greater than zero')
    })

    it('should return a MKR/EUR exchange rate that is greater than zero', async () => {
      const price = await contractInstance.getExchangeRate("MKR", "EUR", "", 100000000000000);
      assert.isAbove(price, 0, 'The MKR/EUR rate returned is greater than zero')
    })

    it('should return an AAPL/USD exchange rate that is greater than zero', async () => {
      const price = await contractInstance.getExchangeRate("AAPL", "USD", "PROVIDER1", 1);
      assert.isAbove(price, 0, 'The AAPL/USD rate returned is greater than zero')
    })

})