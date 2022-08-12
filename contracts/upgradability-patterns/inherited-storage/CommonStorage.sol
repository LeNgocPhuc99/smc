// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// copy cost
contract CommonStorage {
    address internal implementation;
    address internal owner;
    string internal firstname;
    string internal lastname;

    function getImplementationAddress() public view returns (address) {
        return implementation;
    }
}
