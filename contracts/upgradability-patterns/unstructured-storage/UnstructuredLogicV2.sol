// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// maintains the order of the state variable
contract UnstructuredLogicV2 {
    uint256 val; // avoiding accidental overriding of storage variable.
    uint256 newVal;

    function getVal() external view returns (uint256) {
        return newVal;
    }

    function setVal(uint256 _newVal) external {
        newVal = _newVal;
    }
}