const hre = require("hardhat");

async function main() {
  const networkName = hre.network.name;
  // We get the contract to deploy
  const Test = await hre.ethers.getContractFactory("Test");
  const contract = await Test.deploy();

  await contract.deployed();

  console.log(
    `Box deployed to ${networkName} address=${contract.address}`
  );

  console.log(`Verifying Test contract to ${contract.address}`);
  await hre
    .run("verify:verify", {
      address: contract.address,
      constructorArguments: [],
    })
    .catch((e) => {
      console.error(e);
      console.log(
        `RUN THE COMMAND MANUALLY: npx hardhat verify --network ${networkName} ${contract.address}`
      );
    });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

