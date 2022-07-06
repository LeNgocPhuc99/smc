const hre = require("hardhat");
const { upgrades, ethers } = require("hardhat");

const proxyAddress = "0xFfd1A928e3cbE3f0F7AF3e37eA429cce39D0cfE7";

async function main() {
  const networkname = hre.network.name;
  console.log(proxyAddress, "original Box(proxy) address");

  const BoxV2 = await hre.ethers.getContractFactory("BoxV2");
  console.log("upgrade to BoxV2...");

  const boxV2 = await upgrades.upgradeProxy(proxyAddress, BoxV2);
  console.log(boxV2.address, " BoxV2 address(should be the same)");

  console.log(
    await upgrades.erc1967.getImplementationAddress(boxV2.address),
    " getImplementationAddress"
  );
  console.log(
    await upgrades.erc1967.getAdminAddress(boxV2.address),
    " getAdminAddress"
  );

  // @seemore: https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#using-programmatically
  console.log(`Verifying BoxV2 contract to ${boxV2.address}`);
  await hre
    .run("verify:verify", {
      address: boxV2.address,
      constructorArguments: [],
    })
    .catch((e) => {
      console.error(e);
      console.log(
        `RUN THE COMMAND MANUALLY: npx hardhat verify --network ${networkname} ${boxV2.address}`
      );
    });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// implementation (BoxV2): 0x741B07d8b9AE4147493Bb2bB869364c05dFA5b14