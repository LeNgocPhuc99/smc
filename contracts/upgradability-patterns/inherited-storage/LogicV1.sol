// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CommonStorage.sol";

contract LogicV1 is CommonStorage {
    function getFirstname() external view returns(string memory) {
        return firstname;
    }

    function getLastname() external view returns(string memory) {
        return lastname;
    }

    function setFirstname(string calldata _firstname) external {
        firstname = _firstname;
    }

    function setLastname(string calldata _lastname) external {
        lastname = _lastname;
    }
}