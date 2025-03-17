import { ethers, network } from "hardhat";
import { VoiceVault, VoiceVault__factory } from "../typechain-types";
const addresses = require("./address.json");

async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);
  console.log("Owner address = ",owner.address);
  
  const VoiceVault:VoiceVault__factory = await ethers.getContractFactory("VoiceVault");
  const voiceVault:VoiceVault = await VoiceVault.attach(addresses[network.name].voiceVault);

  console.log("VoiceVault Address: ", voiceVault.address);

  const tx = await voiceVault.mint();
  console.log("Transaction Hash: ", tx.hash);
  await tx.wait();
  console.log("Token minted successfully");
 
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
