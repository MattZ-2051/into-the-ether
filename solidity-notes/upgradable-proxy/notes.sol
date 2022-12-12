// Notes on how to create and upgradable proxy contract
// Also includes how NOT to create one, see BuggyProxy

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CounterV1 {
    uint256 public count;

    function inc() external {
        count += 1;
    }
}

contract CounterV2 {
    uint256 public count;

    function inc() external {
        count += 1;
    }

    function dev() external {
        count -= 1;
    }
}

// this will be an example of how not to do a proxy contract
contract BuggyProxy {
    address public implementation;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function _delegate() private {
        (bool ok, bytes memory res) = implementation.delegatecall(msg.data);
        require(ok, "delegatecall failed");
    }

    fallback() external payable {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }

    function upgradeTo(address _implementation) external {
        require(msg.sender == admin, "Not Authorized");
        implementation = _implementation;
    }
}
