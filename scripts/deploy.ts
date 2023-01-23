const hre = require("hardhat");

async function main() {
  
  const Claim_NFT = await hre.ethers.getContractFactory("SimpleNFTClaim");
  const val = 100;
  const claim_nft = await Claim_NFT.deploy(val);

  await claim_nft.deployed();

  console.log(`The address of the contract is ${claim_nft.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
