
const hre = require("hardhat");

async function main() {

  const ChatDApp = await hre.ethers.getContractFactory("ChatDApp");
  const chatDApp = await ChatDApp.deploy();

  await chatDApp.deployed();

  console.log(
    `Contract address: ${chatDApp.address}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

