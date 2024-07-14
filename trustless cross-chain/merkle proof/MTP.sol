pragma solidity ^0.8.0;

contract MerkleProof {
    function getMerkleProof(bytes32[] memory leaves, uint256 index) public pure returns (bytes32[] memory) {
        require(leaves.length > 0 && (leaves.length & (leaves.length - 1)) == 0, "Invalid number of leaves");

        uint256 nodes = leaves.length * 2 - 1;
        bytes32[] memory proof = new bytes32[](nodes - leaves.length);

        uint256 path = index + leaves.length - 1;
        for (uint256 i = 0; i < proof.length; i++) {
            if (path % 2 == 0) {
                proof[i] = leaves[path - 1];
            } else {
                proof[i] = leaves[path + 1];
            }
            path = (path - 1) / 2;
        }

        return proof;
    }
}
