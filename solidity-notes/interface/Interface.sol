pragma solidity ^0.8.3;

// Interfaces are used to call contracts where you dont have the code

interface ICounter {
    function count() external view returns (uint256);

    function inc() external;
}

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
    uint256 public count;

    function examples(address _counter) external {
        ICounter(_counter).inc();
        count = ICounter(_counter).count();
    }
}
