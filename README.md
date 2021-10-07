# IKMToken [BEP20]
This repository contains a smart contract for the IkmToken based on the BEP-20 Interface.
It has been created following the article: https://itnext.io/building-a-decentralized-application-with-bep-20-contract-in-solidity-d2c066447aa6

## Technology stack
The smart contract has been writted and tested with the following technologies:
- Solidity v0.8.9
- Truffle v5.4.13
- npm v6.14.15
- chai v4.3.4
- truffle-assertions v0.9.2
- Ganache v2.5.4

## Testing
In order to test the smart contract on a test Ethereum blockchain, follow these steps:

1) Install Truffle.
   ```
   npm install -g truffle
   ```

2) Install truffle-assertions & chai (for testing purposes).
   ```
   npm install truffle-assertions
   npm install chai
   ```   

3) Install Ganache.
   ```
   https://www.trufflesuite.com/ganache
   ```  

4) Compile & Run the tests.
   ```
   truffle test
   ```  

5) Deploy the Smart Contract.
   ```
   truffle migrate
   ``` 