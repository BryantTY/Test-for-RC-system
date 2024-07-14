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

contract SCc is Ownable {
    IERC721 public gameItemContract;
    mapping(bytes32 => bool) public storedNFTs;

    event NFTStored(address indexed owner, uint256 indexed tokenId);

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

        storeNFT(tokenId);
    }

    function storeNFT(uint256 tokenId) internal {
        require(gameItemContract.ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");
        bytes32 storageId = keccak256(abi.encodePacked(msg.sender, tokenId));
        require(!storedNFTs[storageId], "NFT already stored");

        storedNFTs[storageId] = true;
        gameItemContract.transferFrom(msg.sender, address(this), tokenId);

        emit NFTStored(msg.sender, tokenId);
    }

    function getStoredStatus(uint256 tokenId) external view returns (bool) {
        bytes32 storageId = keccak256(abi.encodePacked(msg.sender, tokenId));
        return storedNFTs[storageId];
    }
}
