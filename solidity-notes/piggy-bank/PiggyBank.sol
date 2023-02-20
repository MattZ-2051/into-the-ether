// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract PiggyBank {
    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);

    address owner = msg.sender;

    receive() external payable {
        emit Deposit(msg.value);
    }

    function withdraw() external {
        require(owner == msg.sender, "Not Owner");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
}
