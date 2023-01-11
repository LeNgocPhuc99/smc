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
  {
    title: "Deploy contract Store",
    description: "Deploy contract Store",
    value: "deploy_contract_store",
  },
  {
    title: "Deploy My1155 contract",
    description: "Deploy My1155 contract",
    value: "deploy_contract_my_er1155"
  },
  {
    title: "Deploy ASUToken contract",
    description: "Deploy ASUToken contract",
    value: "deploy_contract_asu_token"
  }
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
    task("deploy_contract_asu_token", "Deploy contract ASUToken")
      .addParam("gui", "Enabled GUI", true, types.boolean, true)
      .setAction(async (taskArgs, hre, runSuper) => {
        if (taskArgs.gui === true) {
        }
        let constructorArguments = [];
        await deploy("ASUToken", constructorArguments);
      });
    task("deploy_contract_token_faucet", "Deploy contract TokenFaucet")
      .addParam("gui", "Enabled GUI", true, types.boolean, true)
      .setAction(async (taskArgs, hre, runSuper) => {
        if (taskArgs.gui === true) {
        }
        let constructorArguments = [];
        await deploy("TokenFaucet", constructorArguments);
      });
    task("deploy_contract_merkle_test", "Deploy contract MerkleTest")
      .addParam("gui", "Enabled GUI", true, types.boolean, true)
      .setAction(async (taskArgs, hre, runSuper) => {
        if (taskArgs.gui === true) {
        }
        let constructorArguments = [];
        await deploy("MerkleTest", constructorArguments).catch((e) => console.log(e));
      });

    task("deploy_contract_store", "Deploy contract Store")
      .addParam("gui", "Enabled GUI", true, types.boolean, true)
      .setAction(async (taskArgs, hre, runSuper) => {
        if (taskArgs.gui === true) {
        }
        let _storeName = "Decentralized Store";
        let _storeOwner =
          "0x107D213c2955719a59140f1E9e90Be77480D6Cd5".toLowerCase();
        let _feePercent = 10;
        let constructorArguments = [_storeName, _storeOwner, _feePercent];
        await deploy("Store", constructorArguments);
      });
    task("deploy_contract_my_er1155", "Deploy contract My1155")
      .addParam("gui", "Enabled GUI", true, types.boolean, true)
      .setAction(async (taskArgs, hre, runSuper) => {
        if (taskArgs.gui === true) {
        }
        let constructorArguments = [];
        await deploy("My1155", constructorArguments);
      });
  },
};
