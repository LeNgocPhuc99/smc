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
  }
  //0.000000025 AVAX
  //0.00000001 BNB
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
  },
};
