// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {


  const Contract = await hre.ethers.getContractFactory("MoonbeamReceiver");
  const contract = await Contract.deploy("0x4F4495243837681061C4743b74B3eEdf548D56A5","0x2d5d7d31F671F86C782533cc367F14109a082712" );

  await contract.deployed();
  console.log(
    `Contract deployed to ${contract.address}`
  );

  await contract.setLetterboxV3Address("0x75dE2972bdA5a25dF2d64E4B2897Ad142b47EeC5");

  console.log("Confirming LetterboxV3 contract address set to: ", await contract.letterboxV3Addr());



}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
