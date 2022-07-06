const hre = require("hardhat");
const { upgrades } = require("hardhat");

const proxyAddress = "0xFfd1A928e3cbE3f0F7AF3e37eA429cce39D0cfE7";

async function main() {
  const networkname = hre.network.name;
  console.log(proxyAddress, "original Box(proxy) address");

  const BoxV3 = await hre.ethers.getContractFactory("BoxV3");
  console.log("upgrade to BoxV3...");

  const boxV3 = await upgrades.upgradeProxy(proxyAddress, BoxV3);
  console.log(boxV3.address, " BoxV3 address(should be the same)");

  console.log(
    await upgrades.erc1967.getImplementationAddress(boxV3.address),
    " getImplementationAddress"
  );
  console.log(
    await upgrades.erc1967.getAdminAddress(boxV3.address),
    " getAdminAddress"
  );

  // @seemore: https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#using-programmatically
  console.log(`Verifying BoxV3 contract to ${boxV3.address}`);
  await hre
    .run("verify:verify", {
      address: boxV3.address,
      constructorArguments: [],
    })
    .catch((e) => {
      console.error(e);
      console.log(
        `RUN THE COMMAND MANUALLY: npx hardhat verify --network ${networkname} ${boxV3.address}`
      );
    });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// implementation (BoxV3): 0x0b966438D72182B719A8156bA1bF3787bE1E3c2f