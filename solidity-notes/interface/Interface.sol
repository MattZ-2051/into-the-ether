pragma solidity ^0.8.3;

contract Counter {
    uint256 public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}

contract CallInterface {
    function examples(address _counter) external {
        Counter(_counter).inc();
    }
}
