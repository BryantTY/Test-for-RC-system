pragma solidity ^0.8.0;

contract MerkleProof {
    function getProof(bytes32[] memory leaves, uint index) public pure returns (bytes32[] memory) {
        require(index < leaves.length, "Invalid index");

        bytes32[] memory proof = new bytes32[](leaves.length - 1);
        uint remaining = leaves.length;
        uint offset = 0;

        while (remaining > 1) {
            uint parentIndex = offset + index / 2;
            bytes32 leftChild = leaves[offset + index];
            bytes32 rightChild;

            if (index % 2 == 0) {
                rightChild = leaves[offset + index + 1];
            } else {
                rightChild = leaves[offset + index - 1];
            }

            bytes32 parent = keccak256(abi.encodePacked(leftChild, rightChild));
            proof[parentIndex] = parent;

            index /= 2;
            remaining /= 2;
            offset += remaining;
        }

        return proof;
    }
}
