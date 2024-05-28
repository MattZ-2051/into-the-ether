pragma solidity ^0.8.24;


// Yul Storage
// EVM Storage
contract YuulIntro {

    function test_yul_var() public pure returns (uint256) {
        uint256 s = 0;

        assembly {
            let x := 0
            x := 0
            s := 2
        }

        return s;
    }
}
