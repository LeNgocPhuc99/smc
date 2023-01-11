// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Bridge is Ownable, ReentrancyGuard {
    using Address for address;
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    using ECDSA for bytes32;

    modifier noContractAllowed() {
        require(!(address(msg.sender).isContract()), "Contact not allow");
        _;
    }

    uint256 public dailyTokenWithdrawLimitPerAccount = 10_000e18;
    uint256 public constant CHAIN_ID = 1;
    uint256 public constant ONE_DAY = 24 hours;

    address public TRUSTED_TOKEN_ADDRESS = address(0);
    address public verifyAddress = address(0);

    event Deposit(
        address indexed account,
        uint256 indexed amount,
        uint256 blocknumber,
        uint256 timestamp,
        uint256 id
    );
    event Withdraw(address indexed account, uint256 indexed amount, uint256 id);

    mapping(address => uint256) public lastUpdatedTokenWithdrawTimesatmp;
    mapping(address => uint256) public lastUpdatedTokenWithdrawAmount;

    // deposit index OF OTHER CHAIN => withdrawal in current chain ???
    mapping(uint256 => bool) public claimedWithdrawalsByOtherChainDepositId;

    uint256 public lastDepositIndex;

    // setter
    function setVerifyAddress(address newVerifyAddress)
        external
        onlyOwner
        noContractAllowed
    {
        verifyAddress = newVerifyAddress;
    }

    function setDailyTokenWithdrawLimit(uint256 newLimit)
        external
        onlyOwner
        noContractAllowed
    {
        dailyTokenWithdrawLimitPerAccount = newLimit;
    }

    function setTokenAddress(address newAddress) external onlyOwner noContractAllowed {
        TRUSTED_TOKEN_ADDRESS = newAddress;
    }

    function deposit(uint256 amount) external noContractAllowed nonReentrant {
        
    }

    // verify signature
    function _verify(
        address account,
        uint256 amount,
        uint256 chainId,
        uint256 id,
        bytes calldata signature
    ) internal view returns (bool) {
        bytes32 _ethSignedMessageHash = keccak256(
            abi.encode(account, amount, chainId, id, address(this))
        ).toEthSignedMessageHash();

        return _ethSignedMessageHash.recover(signature) == verifyAddress;
    }
}
