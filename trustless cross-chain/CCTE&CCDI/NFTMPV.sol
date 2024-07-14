pragma solidity ^0.8.0;

import "./Battlegame.sol";

contract MerkleProofVerification {
    mapping(address => MerkleNFT) public storedMerkleData;
    
    IERC721 public nft;
    BattleGame public battleGame;

    struct MerkleNFT {
        //bytes32 merkleRoot;
        uint256 tokenId;
        uint256 merkleProofType;
    }

    constructor(address _battleGameAddress) {
        battleGame = BattleGame(_battleGameAddress);
    }


    function verifyMerkleProof(
        //bytes32[] memory proof,
        //bytes32 leaf,
       // bytes32 root,
        uint256 tokenId,
        uint256 merkleProofType
    ) public returns (bool) {
        require(merkleProofType == 1 || merkleProofType == 2, "Invalid merkleProofType");
        storedMerkleData[msg.sender] = MerkleNFT(tokenId, merkleProofType);
        //bytes32 computedHash = leaf;

        /*for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash < proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        if (computedHash == root) {
            storedMerkleData[msg.sender] = MerkleNFT(root, tokenId, merkleProofType);
            return true;
        } else {
            return false;
        }*/
    }
    function getstoredMerkleData(address userAddress) public view returns (MerkleNFT memory) {
        return storedMerkleData[userAddress];
    }

}
