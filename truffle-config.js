const HDWalletProvider = require("truffle-hdwallet-provider");
// the mnemonic phrase to an account with some ETH in the respective network
const mnemonic = process.env.MNEMONIC;

// the infura project id's
const infuraProjectID = process.env.INFURA_PROJECT_ID;

console.log(mnemonic);
console.log(infuraProjectID);

module.exports = {
  networks : {
    mainnet: {
      provider: function () {
        return new HDWalletProvider(mnemonic, `https://mainnet.infura.io/${infuraProjectID}`);
      },
      gasPrice: 10000000000,
      gas: 4465030,
      network_id: 1
    },
    kovan: {
      provider: function () {
        return new HDWalletProvider(mnemonic, `https://kovan.infura.io/${infuraProjectID}`);
      },
      gasPrice: 10000000000,
      gas: 4465030,
      network_id: 42
    },
    rinkeby: {
      provider: function () {
        return new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/${infuraProjectID}`);
      },
      gasPrice: 10000000000,
      gas: 4465030,
      network_id: 4
    }

  },
  compilers : {
    solc: {
      version: '0.4.26'
    }
  }

};