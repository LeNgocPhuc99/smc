// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";

// lazy mint with EIP712
contract NFTLazyMintV2 is ERC721, AccessControl, EIP712 {
    bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
        EIP712(_name, "1.0.0")
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
            "Invalid signature"
        );
        _safeMint(account, tokenId);
    }

    function _hash(address account, uint256 tokenId)
        internal
        view
        returns (bytes32)
    {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        keccak256("NFT(uint256 tokenId,address account)"),
                        tokenId,
                        account
                    )
                )
            );
    }

    function _verify(bytes32 disget, bytes memory signature)
        internal
        view
        returns (bool)
    {
        return hasRole(MINT_ROLE, ECDSA.recover(disget, signature));
    }
}
