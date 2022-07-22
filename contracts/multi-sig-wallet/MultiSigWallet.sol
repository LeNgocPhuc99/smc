// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    /**
     * Events
     */

    event Confirmation(address indexed sender, uint256 indexed transactionId);
    event Revocation(address indexed sender, uint256 indexed transactionId);
    event Submission(uint256 indexed transactionId);
    event Execution(uint256 indexed transactionId);
    event ExecutionFailure(uint256 indexed transactionId);
    event Deposit(address indexed sender, uint256 value);
    event OwnerAddition(address indexed owner);
    event OwnerRemoval(address indexed owner);
    event RequirementChange(uint256 required);
    /**
     constants
     */
    uint256 public constant MAX_OWNER_COUNT = 50;

    /**
     * Storage
     */
    // mapping from transaction's id to Transaction
    mapping(uint256 => Transaction) public transactions;
    //
    mapping(uint256 => mapping(address => bool)) public confirmations;
    //
    mapping(address => bool) public isOwner;

    address[] public owners;
    uint256 public required;
    uint256 public transactionCount;

    struct Transaction {
        address destination;
        uint256 value;
        bytes data;
        bool executed;
    }

    /**
     * Modifiers
     */

    modifier onlyWallet() {
        require(
            msg.sender == address(this),
            "MultiSigWallet: sender isn't the wallet"
        );
        _;
    }

    modifier ownerDoesNotExist(address owner) {
        require(!isOwner[owner], "MultiSigWallet: owner is exists");
        _;
    }

    modifier ownerExists(address owner) {
        require(isOwner[owner], "MultiSigWallet: owner isn't exists");
        _;
    }

    modifier transactionExists(uint256 transactionId) {
        require(
            transactions[transactionId].destination != address(0),
            "MultiSigWallet: tx isn't exists"
        );
        _;
    }

    modifier confirmed(uint256 transactionId, address owner) {
        require(
            confirmations[transactionId][owner],
            "MultiSigWallet: tx isn't confirmed"
        );
        _;
    }

    modifier notConfirmed(uint256 transactionId, address owner) {
        require(
            !confirmations[transactionId][owner],
            "MultiSigWallet: tx is confirmed"
        );
        _;
    }

    modifier notExecuted(uint256 transactionId) {
        require(
            !transactions[transactionId].executed,
            "MultiSigWallet: tx is executed"
        );
        _;
    }

    modifier notNull(address _address) {
        require(_address != address(0));
        _;
    }

    modifier validRequirement(uint256 ownerCount, uint256 _required) {
        require(
            ownerCount <= MAX_OWNER_COUNT &&
                _required <= ownerCount &&
                _required != 0 &&
                ownerCount != 0
        );
        _;
    }

    /**
     * @dev contructor
     * @param _owners - list of initial owners
     * @param _required - number of required confirmations
     */
    constructor(address[] memory _owners, uint256 _required)
        validRequirement(_owners.length, _required)
    {
        owners = _owners;
        required = _required;
    }

    /**
     * Public functions
     */

    /**
     * @dev allows to add a new owner, transaction had to sent by wallet
     * @param _owner - new owner
     */
    function addOwner(address _owner)
        public
        onlyWallet
        ownerDoesNotExist(_owner)
        notNull(_owner)
        validRequirement(owners.length + 1, required)
    {
        isOwner[_owner] = true;
        owners.push(_owner);
        emit OwnerAddition(_owner);
    }

    /**
     * @dev allows to remove a owner, transaction had to sent by wallet
     * @param _owner - address of owner
     */
    function removeOwner(address _owner) public onlyWallet ownerExists(_owner) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == _owner) {
                owners[i] = owners[owners.length];
                break;
            }
        }
        // remove the last item
        owners.pop();
        if (required > owners.length) changeRequirement(owners.length);

        emit OwnerRemoval(_owner);
    }

    /**
     * @dev
     * @param _newOwner - address of new owner
     * @param _oldOwner - address of owner to be repalace
     */
    function replaceOwner(address _newOwner, address _oldOwner)
        public
        onlyWallet
        ownerExists(_oldOwner)
        ownerDoesNotExist(_newOwner)
    {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == _oldOwner) {
                owners[i] = _newOwner;
                break;
            }
        }

        isOwner[_oldOwner] = false;
        isOwner[_newOwner] = true;

        emit OwnerAddition(_newOwner);
        emit OwnerRemoval(_oldOwner);
    }

    /**
     * @dev allows to change the number of required confirmations.
     * @param _required - number of required confirmations
     */
    function changeRequirement(uint256 _required)
        public
        onlyWallet
        validRequirement(owners.length, _required)
    {
        required = _required;
        emit RequirementChange(_required);
    }

    /**
     * @dev allows an owner to submit and confirm a transaction
     * @param _destination - transaction target address
     * @param _value - transaction ether value
     * @param _data - transaction data payload
     * @return transactionId - transaction id
     */

    function submitTransaction(
        address _destination,
        uint256 _value,
        bytes memory _data
    ) public returns (uint256 transactionId) {
        transactionId = addTransaction(_destination, _value, _data);
    }

    function confimTransaction(uint256 _transactionId)
        public
        ownerExists(msg.sender)
        transactionExists(_transactionId)
        notConfirmed(_transactionId, msg.sender)
    {
        confirmations[_transactionId][msg.sender] = true;
        emit Confirmation(msg.sender, _transactionId);
    }

    /**
     * Internal function
     */

    /**
     * @dev add a new transaction to transaction mapping
     * @param _destination - transaction target address
     * @param _value - transaction ether value
     * @param _data - transaction data payload
     * @return transactionId - transaction id
     */
    function addTransaction(
        address _destination,
        uint256 _value,
        bytes memory _data
    ) internal notNull(_destination) returns (uint256 transactionId) {
        transactionId = transactionCount;
        transactions[transactionId] = Transaction(
            _destination,
            _value,
            _data,
            false
        );
        transactionCount += 1;
        emit Submission(transactionId);
    }

    function executeTransaction(uint256 _transactionId)
        public
        ownerExists(msg.sender)
        confirmed(_transactionId, msg.sender)
        notExecuted(_transactionId)
    {}

    /**
     * @dev Fallback function allow deposit ether
     */
    fallback() external payable {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }
}
