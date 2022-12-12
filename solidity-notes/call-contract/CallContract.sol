// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract CallContract {
    function setX(address _test, uint256 _x) external {
        TestContract(_test).setX(_x);
    }

    function getX(address _test) external view returns (uint256) {
        uint256 x = TestContract(_test).getX();
        return x;
    }

    function getXAndValue(address _test)
        external
        view
        returns (uint256, uint256)
    {
        (uint256 x, uint256 value) = TestContract(_test).getXAndValue();
        return (x, value);
    }

    function setXAndSendEther(address _test, uint256 _x) external payable {
        // to send ether when calling another contract send value in {} braces
        TestContract(_test).setXAndReceiveEther{value: msg.value}(_x);
    }
    // or you can pass in contract as type
    // function setX(TestContract _test, uint256 _x) external {
    //     _test.setX(_x);
    // }
}

contract TestContract {
    uint256 public x;
    uint256 public value = 123;

    function setX(uint256 _x) external {
        x = _x;
    }

    function getX() external view returns (uint256) {
        return x;
    }

    function setXAndReceiveEther(uint256 _x) external payable {
        x = _x;
        value = msg.value;
    }

    function getXAndValue() external view returns (uint256, uint256) {
        return (x, value);
    }
}
