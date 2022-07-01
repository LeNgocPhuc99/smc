const prompts = require('prompts');

const { HardhatContext } = require("hardhat/internal/context");
const { createProvider } = require("hardhat/internal/core/providers/construction");
const { Tasks, defineTasks } = require('../scripts/_tasks');
defineTasks();

async function selectNetwork() {
    await prompts({
        type: 'select',
        name: 'network',
        message: 'Select network?',
        choices: [
            { title: 'Default', description: '', value: 'default' },
            // bsc
            { title: 'BSC (Mainnet)', description: '', value: 'bsc' },
            { title: 'BSC (Testnet)', description: '', value: 'bscTestnet' },
            // polygon
            { title: 'Polygon (Mainnet)', description: '', value: 'polygon' },
            { title: 'Polygon Mumbai (Testnet)', description: '', value: 'polygonMumbai' },
            // etherium
            { title: 'Etherium (Mainnet)', description: '', value: 'mainnet' },
            { title: 'Etherium (Ropsten)', description: '', value: 'ropsten' },
            { title: 'Etherium (Rinkeby)', description: '', value: 'rinkeby' },
            { title: 'Etherium (Goerli)', description: '', value: 'goerli' },
            { title: 'Etherium (Kovan)', description: '', value: 'kovan' },
            // avalanche
            { title: 'Avalanche (Mainnet)', description: '', value: 'avalanche' },
            { title: 'Avalanche (FujiTestnet)', description: '', value: 'avalancheFujiTestnet' },

        ],
    }, {
        onCancel: () => {
            process.exit(1);
        },
        onSubmit: (prompt, networkName) => {
            console.log(`Hardhat: selected network ${networkName}`);

            if (networkName === 'default') {
                return;
            }

            // console.log(`current network`, hre.network.provider);
            // console.log(`Hardhat: configure network ${networkName}`);
            const networkConfig = config.networks[networkName];

            const ctx = HardhatContext.getHardhatContext();

            if (!networkConfig) {
                console.error(`No config found for network ${networkName}`);
                process.exit(1);
            }

            const provider = createProvider(
                networkName,
                networkConfig,
                hre.config.paths,
                hre.artifacts,
                ctx.experimentalHardhatNetworkMessageTraceHooks.map(
                    (hook) => (trace, isCallMessageTrace) => hook(this, trace, isCallMessageTrace)
                )
            );

            const network = {
                name: networkName,
                config: hre.config.networks[networkName],
                provider,
            };

            // console.log(`update network`, network);
            // console.log(`update network`, provider);

            hre.network = network;
        }
    });
}

task("deploy", "Select network and listing contracts GUI").setAction(async (taskArgs, hre, runSuper) => {
    // network selection menu
    if (hre.network.name === 'hardhat') {
        await selectNetwork();
    }
    await prompts({
        type: 'multiselect',
        name: 'tasks',
        message: 'Select tasks?',
        choices: Tasks,
    }, {
        onSubmit: async (prompt, tasks) => {
            for (let i = 0; i < tasks.length; i++) {
                await hre.run(tasks[i], { gui: true });
            }
        }
    });
});