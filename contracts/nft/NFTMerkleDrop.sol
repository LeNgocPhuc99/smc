// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

//
contract NFTMerkleDrop is ERC721 {
    bytes32 public immutable root;

    constructor(
        string memory _name,
        string memory _symbol,
        bytes32 _merkleRoot
    ) ERC721(_name, _symbol) {
        root = _merkleRoot;
    }

    function redeem(
        address account,
        uint256 tokenId,
        bytes32[] calldata proof
    ) external {
        require(
            _verify(_leaf(account, tokenId), proof),
            "Invalid merkle proof"
        );
        _safeMint(account, tokenId);
    }

    function _leaf(address account, uint256 tokenId)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(tokenId, account));
    }

    function _verify(bytes32 leaf, bytes32[] memory proof)
        internal
        view
        returns (bool)
    {
        return MerkleProof.verify(proof, root, leaf);
    }
}
