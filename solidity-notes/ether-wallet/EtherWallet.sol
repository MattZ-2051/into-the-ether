// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw(uint256 _amount) external {
        require(msg.sender == owner, "Only owner can withdraw");
        owner.transfer(_amount);
    }

    function getBalance(uint256 balance) external view returns (uint256) {
        return address(this).balance;
    }
}
