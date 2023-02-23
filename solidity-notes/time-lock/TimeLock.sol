// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.10;

// transactions will be queued first and then executed after the time lock
// The purpose is to delay a tx so the user has time to see it before executed

contract TimeLock {
    address public owner;
    mapping(bytes32 => bool) public queued;
    uint public constant MIN_DELAY = 10 seconds;
    uint public constant MAX_DELAY = 1000 seconds;

    error AlreadyQueError(bytes32 txId);
    error NotOwnerError();
    error TimeStampNotInRangeError(uint blockTimeStamp, uint timestamp);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwnerError();
        }

        _;
    }

    function getTxId(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) public pure returns (bytes32 txId) {
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }

    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external onlyOwner {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        if (queued[txId]) {
            revert AlreadyQueError(txId);
        }

        if (
            _timestamp < block.timestamp + MIN_DELAY ||
            _timestamp > block.timestamp + MAX_DELAY
        ) {
            revert TimeStampNotInRangeError(block.timestamp, _timestamp);
        }

        queued[txId] = true;
    }

    function execute() external {}
}

contract TestTimeLock {
    address public timeLock;

    constructor(address _timeLock) {
        timeLock = _timeLock;
    }

    function test() external {
        require(msg.sender == timeLock, "time lock");
    }
}
