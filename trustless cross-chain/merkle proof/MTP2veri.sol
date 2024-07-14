pragma solidity ^0.8.0;

contract MPveri {
    function verifyProof(bytes32 root, bytes32 leaf, uint256 index, bytes32[] calldata proof) public pure returns (bool) {
    bytes32 hash = leaf;
    uint256 len = proof.length;

    for (uint256 i = 0; i < len; i++) {
        bytes32 proofElement = proof[i];

        if (index % 2 == 0) {
            hash = keccak256(abi.encodePacked(hash, proofElement));
        } else {
            hash = keccak256(abi.encodePacked(proofElement, hash));
        }

        index = index / 2;
    }

    return hash == root;
    }

}
