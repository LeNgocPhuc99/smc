require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-web3");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("./helpers/hardhat_tasks");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

task("balance", "Prints an account's balance")
  .addParam("account", "The account's address")
  .setAction(async (taskArgs) => {
    const account = web3.utils.toChecksumAddress(taskArgs.account);
    const balance = await web3.eth.getBalance(account);
    console.log(web3.utils.fromWei(balance, "ether"), "ETH");
  });

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
  solidity: "0.8.4",
  //defaultNetwork: 'bscTestnet',
  networks: {
    avalancheFujiTestnet: {
      url: process.env.AVAX_TESTNET_URL || "",
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    bscTestnet: {
      url: process.env.BSC_TESTNET_URL || "",
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    rinkeby: {
      url: process.env.RINKEBY_URL || "",
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    }
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    // https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html
    apiKey: {
      // etherium
      mainnet: "",
      ropsten: "",
      rinkeby: process.env.RINKEBY_API_KEY,
      goerli: "",
      kovan: "",
      // binance smart chain
      bsc: "",
      bscTestnet: process.env.BSC_TESTNET_API_KEY,

      // huobi eco chain
      heco: "",
      hecoTestnet: "",
      // fantom mainnet
      opera: "",
      ftmTestnet: "",
      // optimism
      optimisticEthereum: "",
      optimisticKovan: "",
      // polygon
      polygon: "",
      polygonMumbai: "",
      // arbitrum
      arbitrumOne: "",
      arbitrumTestnet: "",
      // avalanche
      avalanche: "",
      avalancheFujiTestnet: process.env.AVAX_TESTNET_API_KEY,
      // moonbeam
      moonbeam: "",
      moonriver: "",
      moonbaseAlpha: "",
      // harmony
      harmony: "",
      harmonyTest: "",
      // xdai and sokol don't need an API key, but you still need
      // to specify one; any string placeholder will work
      xdai: "",
      sokol: "",
      aurora: "",
      auroraTestnet: "",
    },
  },
};
