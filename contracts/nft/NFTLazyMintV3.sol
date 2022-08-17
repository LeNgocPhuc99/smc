// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";

// Lazy mint with Signature Checker
contract NFTLazyMintV3 is ERC721, EIP712, AccessControl {
    bytes32 constant public MINT_ROLE = "MINT_ROLE";

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
        address signer,
        uint256 tokenId,
        bytes calldata signature
    ) external {
        require(
            _verify(signer, _hash(account, tokenId), signature),
            "Invalid signature or signer"
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
                        keccak256("NFT(uint256 tokenId, address account)"),
                        tokenId,
                        account
                    )
                )
            );
    }

    function _verify(
        address signer,
        bytes32 digest,
        bytes memory signature
    ) internal view returns (bool) {
        return
            hasRole(MINT_ROLE, ECDSA.recover(digest, signature)) &&
            SignatureChecker.isValidSignatureNow(signer, digest, signature);
    }
}
