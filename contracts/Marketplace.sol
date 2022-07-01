// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./Collectible.sol";

contract Marketplace is Collectible {
    using SafeMath for uint256;

    struct Listing {
        uint256 price;
        address owner;
    }

    mapping(uint256 => Listing) public tokenIdToListing;
    mapping(uint256 => bool) public hasBeenListed;
    mapping(uint256 => address) public cancelableByAccount;

    event ItemListed(uint256 tokenId, uint256 price, address seller);
    event ListingCancelled(uint256 tokenId, uint256 price, address seller);
    event ItemBought(uint256 tokenId, uint256 price, address buyer);

    modifier onlyTokenOwner(uint256 tokenId) {
        require(
            msg.sender == ownerOf(tokenId),
            "Only the owner of the token id can call this function"
        );
        _;
    }

    modifier onlyListingAccount(uint256 tokenId) {
        require(
            msg.sender == cancelableByAccount[tokenId],
            "Only the address that has listed the token can cancel the listing"
        );
        _;
    }

    function listItem(uint256 tokenId, uint256 price)
        public
        onlyTokenOwner(tokenId)
    {
        require(!hasBeenListed[tokenId], "The token can only be listed onece");
        _transfer(msg.sender, address(this), tokenId);
        cancelableByAccount[tokenId] = msg.sender;
        tokenIdToListing[tokenId] = Listing(price, msg.sender);
        hasBeenListed[tokenId] = true;

        emit ItemListed(tokenId, price, msg.sender);
    }

    function cancelListing(uint256 tokenId) public onlyListingAccount(tokenId) {
        _transfer(address(this), msg.sender, tokenId);
        uint256 price = tokenIdToListing[tokenId].price;
        delete cancelableByAccount[tokenId];
        delete tokenIdToListing[tokenId];
        delete hasBeenListed[tokenId];

        emit ListingCancelled(tokenId, price, msg.sender);
    }

    function buyItem(uint256 tokenId) public payable {
        require(
            hasBeenListed[tokenId],
            "The token needs to be listed in order to be bought."
        );
        require(
            tokenIdToListing[tokenId].price == msg.value,
            "You need to pay the correct price."
        );

        //split up the price between owner and creator
        uint256 royaltyForCreator = tokenIdToItem[tokenId]
            .royalty
            .mul(msg.value)
            .div(100);
        uint256 remainder = msg.value.sub(royaltyForCreator);
        //send to creator
        (bool isRoyaltySent, ) = tokenIdToItem[tokenId].creator.call{
            value: royaltyForCreator
        }("");
        require(isRoyaltySent, "Failed to send AVAX");
        //send to owner
        (bool isRemainderSent, ) = tokenIdToItem[tokenId].owner.call{
            value: remainder
        }("");
        require(isRemainderSent, "Failed to send AVAX");

        //transfer the token from the smart contract back to the buyer
        _transfer(address(this), msg.sender, tokenId);

        //Modify the owner property of the item to be the buyer
        Item storage item = tokenIdToItem[tokenId];
        item.owner = msg.sender;

        //clean up
        delete tokenIdToListing[tokenId];
        delete cancelableByAccount[tokenId];
        delete hasBeenListed[tokenId];
        emit ItemBought(tokenId, msg.value, msg.sender);
    }
}
