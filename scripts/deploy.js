const hre = require("hardhat");

async function main() {
  const SubscriptionPlatform = await hre.ethers.getContractFactory("SubscriptionPlatform");
  const subscriptionPlatform = await SubscriptionPlatform.deploy();

  await subscriptionPlatform.deployed();
  console.log(`Contract deployed to: ${subscriptionPlatform.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
