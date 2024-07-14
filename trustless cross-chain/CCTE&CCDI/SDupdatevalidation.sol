// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

library MerkleProof {
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a, b)) : keccak256(abi.encodePacked(b, a));
    }
}

contract SCv is Ownable {
    IERC721 public gameItemContract;
    mapping(bytes32 => bool) public storedProofs;

    event ProofStored(address indexed owner, bytes32[] proof);

    constructor(address _gameItemContract) {
        gameItemContract = IERC721(_gameItemContract);
    }

    function verifyAndStore(
        uint256 tokenId,
        uint256 blockNumber,
        bytes32[] calldata proof,
        bytes32 root,
        bytes32 leaf
    ) external {
        require(block.number > blockNumber, "Current block number is not greater than the provided block number");
        require(MerkleProof.verify(proof, root, leaf), "Invalid Merkle proof");

        storeProof(proof);
    }

    function storeProof(bytes32[] calldata proof) internal {
        bytes32 proofHash = keccak256(abi.encodePacked(proof));
        require(!storedProofs[proofHash], "Proof already stored");

        storedProofs[proofHash] = true;

        emit ProofStored(msg.sender, proof);
    }

    function getStoredStatus(bytes32[] calldata proof) external view returns (bool) {
        bytes32 proofHash = keccak256(abi.encodePacked(proof));
        return storedProofs[proofHash];
    }
}