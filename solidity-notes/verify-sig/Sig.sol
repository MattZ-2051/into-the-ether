// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// notes on verifying signatures

contract Sig {
    function verify(
        address _signer,
        string memory _message,
        bytes memory _sig
    ) external pure returns (bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 signedMessageHash = getSignedMessageHash(messageHash);
        recover(signedMessageHash, _sig) == _signer;
        return true;
    }

    function getMessageHash(
        string memory _message
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    function getSignedMessageHash(
        string memory _message
    ) public pure returns (bytes) {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _message)
            );
    }

    function recover(
        bytes32 _signedMessageHash,
        bytes memory _sig
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        return ecrecover(_signedMessageHash, v, r, s);
    }

    function _split(
        bytes memory _sig
    ) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }
}
