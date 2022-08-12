// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// minimize the storage copying requirements
contract EternalStorage {
    mapping(bytes32 => address) internal _addressStorage;
    mapping(bytes32 => uint256) internal _uintStorage;
    mapping(bytes32 => string) internal _stringStorage;

    function getAddress(bytes32 _key) public view returns (address) {
        return _addressStorage[_key];
    }

    function getUint(bytes32 _key) public view returns (uint256) {
        return _uintStorage[_key];
    }

    function getString(bytes32 _key) public view returns (string memory) {
        return _stringStorage[_key];
    }

    function setAddress(bytes32 _key, address _value) public {
        _addressStorage[_key] = _value;
    }

    function setUint(bytes32 _key, uint256 _value) public {
        _uintStorage[_key] = _value;
    }

    function setString(bytes32 _key, string calldata _value) public {
        _stringStorage[_key] = _value;
    }
}
