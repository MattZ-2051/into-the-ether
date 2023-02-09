// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract TestCall {
    string public message;
    uint256 public x;

    event Log(string message);

    fallback() external payable {
        emit Log("fallback was called");
    }

    function foo(string memory _message, uint256 _x)
        external
        payable
        returns (bool, uint256)
    {
        message = _message;
        x = _x;
        return (true, 999);
    }
}

contract Call {
    function callFoo(address _test) external {
        _test.call(abi.encodeWithSignature("foo(string.uint256)"));
    }
}
