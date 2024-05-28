pragma solidity ^0.8.24;

contract BitMasking {
    function test_mask() public pure returns (bytes32 mask) {
        assembly {
            // |       256 bits        |
            // 000 ... 000 | 111 ... 111
            //             | 16 bits
            // 0x000000000000000000000000000000000000000000000000000000000000ffff
            mask := sub(shl(16, 1), 1)
        }
    }

    function test_shift_mask() public pure returns (bytes32 mask) {
        assembly {
            // |               256 bits                |
            // 000 ... 000 | 111 ... 111 | 000 ... 000 |
            //             | 16 bits     | 32 bits
            // 0x0000000000000000000000000000000000000000000000000000ffff00000000
            mask := shl(32, sub(shl(16, 1), 1))
        }
    }

    function test_not_mask() public pure returns (bytes32 mask) {
        assembly {
            // |               256 bits                |
            // 111 ... 111 | 000 ... 000 | 111 ... 111 |
            //             | 16 bits     | 32 bits
            // 0xffffffffffffffffffffffffffffffffffffffffffffffffffff0000ffffffff
            mask := not(shl(32, sub(shl(16, 1), 1)))
        }
    }
}
