// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EternalStorage.sol";

library EternalLogicLibrary {
    function getUserAge(address _storageAddress) public view returns(uint256) {
        return EternalStorage(_storageAddress).getUint("age");
    }

    function getUsername(address _storageAddress) public view returns(string memory) {
        return EternalStorage(_storageAddress).getString("name");
    }

    function getOwner(address _storageAddress) public view returns(address) {
        return EternalStorage(_storageAddress).getAddress("owner");
    }

    function setUserAge(address _storageAddress, uint256 _age) public {
        EternalStorage(_storageAddress).setUint("age", _age);
    }

    function setUserName(address _storageAddress, string calldata _name) public {
        EternalStorage(_storageAddress).setString("name", _name);
    }
}