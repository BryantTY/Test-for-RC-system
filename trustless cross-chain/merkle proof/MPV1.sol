pragma solidity ^0.8.0;

contract MerkleProofVerification {
    mapping(bytes32 => bytes32[]) public storedMerkleProofs;

    function verifyMerkleProof(
        bytes32[] memory proof,
        bytes32 leaf,
        bytes32 root
    ) public returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash < proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        if (computedHash == root) {
            storedMerkleProofs[root] = proof;
            return true;
        } else {
            return false;
        }
    }

    function getStoredMerkleProof(bytes32 root) external view returns (bytes32[] memory) {
        return storedMerkleProofs[root];
    }
}
