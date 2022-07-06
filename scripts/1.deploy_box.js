const hre = require("hardhat");
const { upgrades, ethers } = require("hardhat");

async function main() {
  const networkname = hre.network.name;
  // We get the contract to deploy
  const Box = await hre.ethers.getContractFactory("Box");
  const box = await upgrades.deployProxy(Box, [42], { initializer: "store" });
  await box.deployed();

  console.log(box.address, " box(proxy) address");
  console.log(
    await upgrades.erc1967.getImplementationAddress(box.address),
    " getImplementationAddress"
  );
  console.log(
    await upgrades.erc1967.getAdminAddress(box.address),
    " getAdminAddress"
  );

  console.log(
    `Box deployed to ${networkname} address=${box.address}`
  );

  // @seemore: https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#using-programmatically
  console.log(`Verifying Box contract to ${box.address}`);
  await hre
    .run("verify:verify", {
      address: box.address,
      constructorArguments: [],
    })
    .catch((e) => {
      console.error(e);
      console.log(
        `RUN THE COMMAND MANUALLY: npx hardhat verify --network ${networkname} ${box.address}`
      );
    });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// proxy: 0xFfd1A928e3cbE3f0F7AF3e37eA429cce39D0cfE7
// implementation: 0x5CAB3dd5e469F5C657ec14175526E1A088FA0f15
// proxy admin: 0x30FCC90221Fc3222cF70D2Ef794d6D055D58E00C
