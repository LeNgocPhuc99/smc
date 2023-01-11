// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// A standard ERC20 token with maxSupply of 1 million
contract AvaxToken is ERC20 {
    uint256 public MAX_SUPPLY = 1000000 ether;

    // maxSupply is sent to the creator of the token
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, MAX_SUPPLY);
    }
}
