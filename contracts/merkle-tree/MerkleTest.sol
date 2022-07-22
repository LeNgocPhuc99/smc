// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleTest {
    // Our rootHash
    bytes32 public root = 0xa2bdf16f1f4dd3b06e1ba28c015b96d965d7850b6334666599fb9494122ebbba; 

    function checkValidity(bytes32[] calldata _merkleProof, address _sender) public view returns (bool){
        bytes32 leaf = keccak256(abi.encodePacked(_sender));
        require(MerkleProof.verify(_merkleProof, root, leaf), "Incorrect proof");
        return true;
    }

}