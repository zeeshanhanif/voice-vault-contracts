import { ethers, network } from "hardhat";
import { VoiceVault, VoiceVault__factory } from "../typechain-types";
async function main() {

  const [owner, addr1] = await ethers.getSigners();
  console.log("Network = ",network.name);
  console.log("Owner address = ",owner.address);
  
  const VoiceVault:VoiceVault__factory = await ethers.getContractFactory("VoiceVault");
  //const voiceVault:VoiceVault = await VoiceVault.deploy(owner.address, "Trump","TrumpVoice","TRUMP", "url");
  const voiceVault:VoiceVault = await VoiceVault.deploy("0x429b697b0Bc1491F298C997140B62760ad2B0E17", "bafybeihdwdcefgh4dqkjv67uzcmw7ojee6xedzdetojuzjevtenxquvyku","Adam","ADAM", "https://green-vicarious-wildcat-394.mypinata.cloud/ipfs/bafkreih52un25x5afl4mbxp3nxpnglatrjdzyoufg7szugwfmi66zf5lau");
  await voiceVault.deployed();
  console.log("VoiceVault deployed to: ", voiceVault.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
