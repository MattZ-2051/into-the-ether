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

contract EVMStorageSingleSlot {
    // EVM storage
    // 2**256 slots, each slot can store up to 32 bytes
    // Slots are assigned in the order the state variables are declared
    // Data < 32 bytes are packed into a slot (right to left)

    // Single variable stored in one slot
    // slot 0
    uint256 public s_x;
    // slot 1
    uint256 public s_y;
    // slot 2
    bytes32 public s_z;

    function test_sstore() public {
        // sstore(k, v) = store v to slot k
        assembly {
            // this is the same as writing s_x = 1234; in sol
            sstore(0, 1234)
            sstore(1, 456)
            sstore(2, 0xababab)
        }
    }

    function test_sstore_again() public {
        // we can access the slot of the state var by using (var_name).slot
        assembly {
            sstore(s_x.slot, 456)
            sstore(s_y.slot, 123)
            sstore(s_z.slot, 0xbbbbb)
        }
    }

    function test_sload()
        public
        view
        returns (uint256 x, uint256 y, bytes32 z)
    {
        // sload(k) = load 32 bytes from slot k
        assembly {
            x := sload(0)
            y := sload(1)
            z := sload(2)
        }

        return (x, y, z);
    }

    function test_sload_again()
        public
        view
        returns (uint256 x, uint256 y, bytes32 z)
    {
        assembly {
            x := sload(s_x.slot)
            y := sload(s_y.slot)
            z := sload(s_z.slot)
        }

        return (x, y, z);
    }
}
