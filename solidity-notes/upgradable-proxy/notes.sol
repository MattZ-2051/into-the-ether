// Notes on how to create and upgradable proxy contract
// Also includes how NOT to create one, see BuggyProxy

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract CounterV1 {
  uint public count;

  function inc() external {
    count += 1;
  }
}

contract CounterV2 {
  uint public count;

  function inc() external {
    count += 1;
  }

  function dev() external {
    count -= 1;
  }
}


// this will be an example of how not to do a proxy contract
contract BuggyProxy {

}
