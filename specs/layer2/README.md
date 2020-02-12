# OrFeed And Layer2

My proposal to help reduce gas fees for OrFeed would be to use the [SKALE](https://skale.network/docs/) layer 2 solution.

The reason for choosing is the following

- SKALE is allows users to deploy mini "sidechains" that have full EVM compatibility meaning the current contracts can be deployed to them and will work as intended.
- It is also super fast and can process over 2000 transactions per second without any lags unlike the ethereum network.
- It supports the current ethereum developer tooling so getting it to work wouldn't be an issue so long as one knows solidity, truffle, web3.js, remix e.t.c
- It is also very secure, since each SKALE chain is deployed as a private instance which connects to the ethereum network to enable consensus on a batch of off-chain transactions after a certain period of time i.e. for every 1000 transactions created off-chain, the private SKALE chain will connect to the ethereum network for the transactions to be validated and for them added to the blockchain upon confirmation

## How it would work

Getting this to work, would be as easy as 1 2 3 as shown below.

1. OrFeed would create a SKALE chain and move the OrFeed Oracle Registry contract to the SKALE chain, like [this](https://skale.network/docs/developers/getting-started/beginner).
2. Data providers would then register their custom oracle contracts, in the SKALE chain, via the above OrFeed Oracle Registry contract.
3. Finally the data providers would now easily update their data about stocks/ETF's e.t.c via the SKALE chain, with not only __zero-fee transactions__ but also high __transaction volumes__ meaning they can literally update their data to ther blockchain every second without any lags and at no cost at all.




