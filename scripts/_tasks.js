const prompts = require("prompts");
const types = require("hardhat/internal/core/params/argumentTypes");
const { deploy } = require("../helpers/helper_tasks");

const Tasks = [
  {
    title: "Deploy contract Collectible",
    description: "ERC721 Collectible",
    value: "deploy_contract_collectible",
  },
  {
    title: "Deploy contract Marketplace",
    description: "ERC721 Marketplace",
    value: "deploy_contract_marketplace",
  },
  {
    title: "Deploy contract MerkleTest",
    description: "Deploy contract MerkleTest",
    value: "deploy_contract_merkle_test",
  },
];

module.exports = {
  Tasks,
  defineTasks: () => {
    task("deploy_contract_collectible", "Deploy contract Collectible")
      .addParam("gui", "Enabled GUI", true, types.boolean, true)
      .setAction(async (taskArgs, hre, runSuper) => {
        if (taskArgs.gui === true) {
        }
        let constructorArguments = [];
        await deploy("Collectible", constructorArguments);
      });

    task("deploy_contract_marketplace", "Deploy contract Marketplace")
      .addParam("gui", "Enabled GUI", true, types.boolean, true)
      .setAction(async (taskArgs, hre, runSuper) => {
        if (taskArgs.gui === true) {
        }
        let constructorArguments = [];
        await deploy("Marketplace", constructorArguments);
      });

    task("deploy_contract_merkle_test", "Deploy contract MerkleTest")
      .addParam("gui", "Enabled GUI", true, types.boolean, true)
      .setAction(async (taskArgs, hre, runSuper) => {
        if (taskArgs.gui === true) {
        }
        let constructorArguments = [];
        await deploy("MerkleTest", constructorArguments);
      });
  },
};
