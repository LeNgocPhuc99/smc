// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LogicV1.sol";

// if LogicV2 does not inherit the LogicV1 ==> the age variable would modify the 1st storage slot in the proxy contract
// ==> collision between the implementation variable and the age variable.
contract LogicV2 is LogicV1 {
    uint256 internal age;

    function getAge() external view returns (uint256) {
        return age;
    }

    function setAge(uint256 _age) external {
        age = _age;
    }
}
