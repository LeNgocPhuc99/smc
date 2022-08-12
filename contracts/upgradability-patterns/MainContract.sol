// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/ILogic.sol";

contract MainContract {
    address owner;
    ILogic satelliteContract; // contract store data

    constructor() {
        owner = msg.sender;
    }

    // when upgrade --> can't access data in origin satelliteContract
    function upgradeTo(address _newImplementation) public {
        require(msg.sender == owner, "Only onwer can upgrade contract");
        satelliteContract = ILogic(_newImplementation);
    }

    function getFirstname() external returns (bytes32) {
        return satelliteContract.getFirstname();
    }

    function getLastname() external returns (bytes32) {
        return satelliteContract.getLastname();
    }

    function setFirstname(bytes32 _firstname) external {
        satelliteContract.setFirtname(_firstname);
    }

    function setLastname(bytes32 _lastname) external {
        satelliteContract.setLastname(_lastname);
    }
}
