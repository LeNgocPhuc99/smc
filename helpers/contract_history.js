const fs = require('fs');
const path = require('path');
const hre = require("hardhat");

let history = require('./history.json');
const networkName = hre.network.name;

function flush() {
    let _content = JSON.stringify(history, null, 2) + '\n';
    fs.writeFileSync(path.resolve(__dirname, "history.json"), _content, { encoding: 'utf8', flag: 'w+' });
}

function updateDeployedContract(name, address, args, flushCache) {
    history = history || {};
    history[networkName] = history[networkName] || {};
    history[networkName][name] = history[networkName][name] || {};
    history[networkName][name].address = address;
    history[networkName][name].verified = false;
    history[networkName][name].args = args || [];
    history[networkName][name].date = new Date().toISOString();

    if (flushCache === true) flush();
}

function updateDeployedContractVerify(name, verified, flushCache) {
    history = history || {};
    history[networkName] = history[networkName] || {};
    history[networkName][name] = history[networkName][name] || {};
    history[networkName][name].verified = !!verified;
    if (flushCache === true) flush();
}

function getDeployedContract(name) {
    history = history || {};
    history[networkName] = history[networkName] || {};
    history[networkName][name] = history[networkName][name] || {};
    return history[networkName][name];
}

module.exports = {
    updateDeployedContract,
    updateDeployedContractVerify,
    getDeployedContract,
    flush
};