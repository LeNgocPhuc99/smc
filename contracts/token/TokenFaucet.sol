// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenFaucet is Ownable {
    using SafeERC20 for IERC20;

    uint256 public amountAllowed = 5000 * 10**18;
    address public tokenContract;
    string[] public userEmail;
    mapping(address => bool) public requestedAddress;
    mapping(string => bool) public emailExists;

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    event SendToken(address indexed receiver, string indexed email, uint256 indexed amount);

    function requestTokens(string calldata email) external {
        require(
            requestedAddress[_msgSender()] == false,
            "Can't Request Multiple Times!"
        );
        IERC20 token = IERC20(tokenContract);
        require(
            token.balanceOf(address(this)) >= amountAllowed,
            "Faucet Empty!"
        );
        requestedAddress[_msgSender()] = true;

        if (!emailExists[email]) {
            userEmail.push(email);
        }

        token.transfer(_msgSender(), amountAllowed);
        emit SendToken(_msgSender(), email, amountAllowed);
    }

    function setAmount(uint256 _amount) external onlyOwner {
        amountAllowed = _amount;
    }

    function governanceRecover(
        address _token,
        address _to,
        uint256 _amount
    ) external onlyOwner {
        if (_token == address(0)) {
            Address.sendValue(payable(_to), _amount);
        } else {
            SafeERC20.safeTransfer(IERC20(_token), _to, _amount);
        }
    }
}
