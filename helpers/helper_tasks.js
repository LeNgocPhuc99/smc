const prompts = require("prompts");
const { NomicLabsHardhatPluginError } = require("hardhat/internal/core/errors");

async function deploy(contractName, constructorArguments) {
  const hre = require("hardhat");

  const contractHistory = require("./contract_history");
  const networkName = hre.network.name;
  console.log(`Deploying contract ${contractName} to network ${networkName}`);

  let confirmDeploy = true;
  const prev = contractHistory.getDeployedContract(contractName);
  if (!!prev && !!prev.address) {
    const response = await prompts({
      type: "confirm",
      name: "value",
      message: `Previous version of ${contractName} have been deployed at address ${prev.address}.
  Do you want to deploy contract ${contractName}?`,
      initial: false,
    });
    confirmDeploy = !!response.value;
  }

  let isNew = false;
  constructorArguments = constructorArguments || [];
  const contractFactory = await hre.ethers.getContractFactory(contractName);
  let contract = null;
  if (!contractFactory) {
    console.log(
      `Contract ${contractName} no factory found! please run "npx hardhat compile"`
    );
  } else if (!confirmDeploy && !!prev && !!prev.address) {
    console.log(`Skipped deploy contract ${contractName}`);
    // attach
    contract = contractFactory.attach(prev.address);
    await contract.deployed();
  } else if (confirmDeploy) {
    contract = await contractFactory.deploy.apply(
      contractFactory,
      constructorArguments
    );
    await contract.deployed();
    isNew = true;
    console.log(
      `Contract ${contractName} deployed to ${networkName} address ${contract.address}`
    );
    contractHistory.updateDeployedContract(
      contractName,
      contract.address,
      constructorArguments,
      true
    );
  }

  // verify contract
  if (!!contract) {
    let contractAddress = "";
    if (isNew && confirmDeploy) {
      contractAddress = contract.address;
    } else if (!!prev && !prev.verified) {
      contractAddress = prev.address;
    }

    if (!!contractAddress) {
      const response = await prompts({
        type: "confirm",
        name: "value",
        message: `Previous version of ${contractName} have been deployed at address ${contractAddress} not verified yet.
Do you want to verify it?`,
        initial: false,
      });
      if (response.value === true) {
        await verify(contractName, contractAddress, constructorArguments)
          .then((verified) =>
            contractHistory.updateDeployedContractVerify(
              contractName,
              verified,
              true
            )
          )
          .catch((e) => {});
      }
    }
  }
}

function verify(contractName, contractAddress, constructorArguments) {
  const hre = require("hardhat");
  const networkname = hre.network.name;
  if (networkname === "hardhat") {
    return console.log(
      `Skip verify contract due to network not supported (${networkname})`
    );
  }
  console.log(`Verifying ${contractName} contract to ${contractAddress}`);

  return new Promise(async (resolve, reject) => {
    let _verified = true;
    let _error = null;
    await hre
      .run("verify:verify", {
        address: contractAddress,
        constructorArguments: constructorArguments || [],
      })
      .catch((e) => {
        if (e.message.indexOf("Already Verified") !== -1) {
          // skip
          _verified = true;
          console.log("Already Verified");
        } else {
          _verified = false;
          _error = e;
          console.error(
            `RUN THE COMMAND MANUALLY: npx hardhat verify --network ${networkname} ${contractAddress}`,
            e
          );
        }
      });
    if (!!_error) return reject(_error);
    resolve(_verified);
  });
}

module.exports = {
  deploy,
  verify,
};
