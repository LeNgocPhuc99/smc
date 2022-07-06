const hre = require("hardhat");
const { upgrades } = require("hardhat");

const proxyAddress = "0xFfd1A928e3cbE3f0F7AF3e37eA429cce39D0cfE7";

async function main() {
  const networkname = hre.network.name;
  console.log(proxyAddress, "original Box(proxy) address");

  const BoxV4 = await hre.ethers.getContractFactory("BoxV4");

  console.log("Preparing upgrade to BoxV4...");
  const boxV4Address = await upgrades.prepareUpgrade(proxyAddress, BoxV4);
  console.log(boxV4Address, " BoxV4 implementation contract address");

  // @seemore: https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#using-programmatically
  console.log(`Verifying BoxV4 contract to ${boxV4Address}`);
  await hre
    .run("verify:verify", {
      address: boxV4Address,
      constructorArguments: [],
    })
    .catch((e) => {
      console.error(e);
      console.log(
        `RUN THE COMMAND MANUALLY: npx hardhat verify --network ${networkname} ${boxV4Address}`
      );
    });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// implementation (BoxV4): 0x917689D24a41876990EbFa11b29FF0121eC6050f
