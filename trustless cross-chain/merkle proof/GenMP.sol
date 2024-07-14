// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

pragma solidity ^0.8.0;

contract MerkleTree {
    
    function generateMerkleProof(bytes32[] memory leaves, uint256 index) public pure returns (bytes32[] memory) {
        require(index < leaves.length, "Invalid leaf index");

        uint256 proofLength = 0;
        for (uint256 i = leaves.length; i > 1; i = (i + 1) / 2) {
            proofLength++;
        }

        bytes32[] memory proof = new bytes32[](proofLength);
        bytes32[] memory nodes = leaves;

        uint256 proofIndex = 0;
        while (nodes.length > 1) {
            uint256 pairIndex = index % 2 == 0 ? index + 1 : index - 1;
            if (pairIndex < nodes.length) {
                proof[proofIndex] = nodes[pairIndex];
                proofIndex++;
            }

            bytes32[] memory nextLevelNodes = new bytes32[]((nodes.length + 1) / 2);
            for (uint256 i = 0; i < nodes.length; i += 2) {
                nextLevelNodes[i / 2] = keccak256(abi.encode(nodes[i], nodes[i + 1]));
            }
            nodes = nextLevelNodes;
            index /= 2;
        }

        return proof;
    }











    function generateMerkleRoot(bytes32[] memory leaves) public pure returns (bytes32) {
        uint256 n = leaves.length;

        if (n == 0) {
            return bytes32(0);
        }

        while (n > 1) {
            uint256 m = (n + 1) / 2;
            for (uint256 i = 0; i < m; i++) {
                if (i * 2 + 1 < n) {
                    leaves[i] = keccak256(abi.encodePacked(leaves[i * 2], leaves[i * 2 + 1]));
                } else {
                    leaves[i] = leaves[i * 2];
                }
            }
            n = m;
        }

        return leaves[0];
    }



    function verifyMerkleProof(bytes32[] memory merkleProof, bytes32 leafNode, bytes32 rootHash) public pure returns (bool) {
        bytes32 computedHash = leafNode;
        uint256 index = 0;
        for (uint256 i = 0; i < merkleProof.length; i++) {
            bytes32 sibling = merkleProof[i];

            if (index % 2 == 0) {
                computedHash = keccak256(abi.encodePacked(computedHash, sibling));
            } else {
                computedHash = keccak256(abi.encodePacked(sibling, computedHash));
            }
            index = index / 2;
        }

        return computedHash == rootHash;
    }







    function testExampleFunction(uint256 index) public pure returns (bool) {
        (bytes32[] memory merkleProof, bytes32 leafNode, bytes32 rootHash) = example(index);

        bool isValid = verifyMerkleProof(merkleProof, leafNode, rootHash);

        return isValid;
    }


    function example(uint256 index) public pure returns (bytes32[] memory, bytes32, bytes32) {
        bytes32 leaf1 = keccak256(abi.encodePacked(uint256(1)));
        bytes32 leaf2 = keccak256(abi.encodePacked(uint256(2)));
        bytes32 leaf3 = keccak256(abi.encodePacked(uint256(3)));
        bytes32 leaf4 = keccak256(abi.encodePacked(uint256(4)));

        bytes32[] memory leaves = new bytes32[](4);
        leaves[0] = leaf1;
        leaves[1] = leaf2;
        leaves[2] = leaf3;
        leaves[3] = leaf4;

        bytes32[] memory merkleProof = generateMerkleProof(leaves, index);
        bytes32 leafNode = leaves[index];
        bytes32 rootHash = generateMerkleRoot(leaves);

        return (merkleProof, leafNode, rootHash);
    }
}
