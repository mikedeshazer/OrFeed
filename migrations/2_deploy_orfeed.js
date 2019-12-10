const orfeed = artifacts.require("orfeed")

module.exports = function(deployer) {
  process.env.NETWORK = deployer.network; 

  if (process.env.NETWORK === 'mainnet') {
    // DO NOT DEPLOY ANYTHING HERE!
  } else {
    deployer.deploy(orfeed);
  }
};
