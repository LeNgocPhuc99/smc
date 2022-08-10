// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract ASUToken is Context, ERC20Burnable {
    constructor() ERC20("Asura Token", "ASU") {
        _mint(msg.sender, 100000000 * 10**18);
    }
}