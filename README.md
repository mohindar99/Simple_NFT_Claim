# Simple NFT Claiming :

The main agenda of this project is to build a smart contract where a single person can send multiple tokens to multiple people as a same time .
This is mainly divided into 2 types :
 1. simple transfer
 2. complex and secure transfer
 
 ## Simple Transfer :
  This is just a basic type where we use arrays for the looping of different address and tokens directly from the owners account to receivers account with ease .
 
 ## Complex and secure Transfer:
  This is a type of transfer where the NFT lies in the contract and the receiver should claim the NFT externally where the owner can reclaim the NFT if had some multiple opinion on the transfer . But should be done till the receiver tries to claim the NFT . Incase of the owner tries to claim the NFT after the receivers claimed it .Then we would not get his NFT back .
  
 ## Requirements :
 
1. Hardhat config
2. Solidity
3. NFTs

## Basic Hardhat commands :

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```
