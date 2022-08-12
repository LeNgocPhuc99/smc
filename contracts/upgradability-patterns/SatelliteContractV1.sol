// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/ILogic.sol";

contract SatelliteContractV1 is ILogic {
    ILogic.User logic;

    function getFirstname() external view override(ILogic) returns (bytes32) {
        return logic.firstname;
    }

    function getLastname() external view override(ILogic) returns (bytes32) {
        return logic.lastname;
    }

    function setFirtname(bytes32 _firstname) external override(ILogic) {
        logic.firstname = _firstname;
    }

    function setLastname(bytes32 _lastname) external override(ILogic) {
        logic.lastname = _lastname;
    }
}
