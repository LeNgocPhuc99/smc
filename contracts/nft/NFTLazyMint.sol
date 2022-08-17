// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract NFTLazyMint is ERC721, AccessControl {
    bytes32 constant public MINT_ROLE = keccak256("MINT_ROLE");

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function redeem(
        address account,
        uint256 tokenId,
        bytes calldata signature
    ) external {
        require(
            _verify(_hash(account, tokenId), signature),
            "Invalid Signature"
        );
        _safeMint(account, tokenId);
    }

    function _hash(address account, uint256 tokenId)
        internal
        pure
        returns (bytes32)
    {
        return
            ECDSA.toEthSignedMessageHash(
                keccak256(abi.encodePacked(account, tokenId))
            );
    }

    function _verify(bytes32 digest, bytes memory signature)
        internal
        view
        returns (bool)
    {
        return hasRole(MINT_ROLE, ECDSA.recover(digest, signature));
    }
}
