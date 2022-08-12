// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILogic {
    struct User {
        bytes32 firstname;
        bytes32 lastname;
    }

    function getFirstname() external returns (bytes32);

    function getLastname() external returns (bytes32);

    function setFirtname(bytes32 _firstname) external;

    function setLastname(bytes32 _lastname) external;
}
