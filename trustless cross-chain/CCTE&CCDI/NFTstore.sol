// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTStorage is Ownable {
    IERC721 public gameItemContract;
    mapping(bytes32 => bool) public storedNFTs;

    event NFTStored(address indexed owner, uint256 indexed tokenId);

    constructor(address _gameItemContract) {
        gameItemContract = IERC721(_gameItemContract);
    }

    function storeNFT(uint256 tokenId) external {
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