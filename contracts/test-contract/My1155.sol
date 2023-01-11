// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract My1155 is ERC1155 {
    constructor() ERC1155("") {
        _mint(msg.sender, 0, 1, ""); // mint 1 on deploy
    }

    function mint() public {
        _mint(msg.sender, 0, 1, "");
    }
}
