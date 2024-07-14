pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract PlayerNFT is ERC721, Ownable {
    uint256 private _currentTokenId = 0;

    struct PlayerData {
        string name;
        uint256 attack;
        uint256 defense;
        uint256 experience;
    }

    mapping(uint256 => PlayerData) public playerData;

    struct LockedInfo {
        PlayerData data;
        address destination;
        uint256 blockchainId;
    }

    mapping(address => LockedInfo) public lockedInfo;

    constructor() ERC721("PlayerNFT", "PNFT") {}

    function createPlayer(
        address player,
        string memory name,
        uint256 attack,
        uint256 defense,
        uint256 experience
    ) public returns (uint256) {
        _currentTokenId += 1;
        uint256 tokenId = _currentTokenId;

        playerData[tokenId] = PlayerData({
            name: name,
            attack: attack,
            defense: defense,
            experience: experience
        });

        _mint(player, tokenId);
        return tokenId;
    }

    function lockPlayer(
        uint256 tokenId,
        address destination,
        uint256 blockchainId
    ) public {
        require(ownerOf(tokenId) == msg.sender, "You must own the token to lock it");
        PlayerData memory data = playerData[tokenId];
        lockedInfo[msg.sender] = LockedInfo({
            data: data,
            destination: destination,
            blockchainId: blockchainId
        });
    }

    /*function updatePlayerData(
        uint256 tokenId,
        string memory name,
        uint256 attack,
        uint256 defense,
        uint256 experience
        //bytes32[] memory proof,
        //bytes32 leaf,
        //bytes32 root
    ) public {
        //require(ownerOf(tokenId) == msg.sender, "You must own the token to update it");
        LockedInfo storage info = lockedInfo[msg.sender];

        require(
            block.number <= info.lockBlockNumber + info.lockDuration,
            "Lock duration has expired"
        );

        //bool isValidProof = MerkleProof.verify(proof, root, leaf);
        //require(isValidProof, "Invalid Merkle proof");

        delete lockedInfo[msg.sender];

        playerData[tokenId] = PlayerData({
            name: name,
            attack: attack,
            defense: defense,
            experience: experience
        });
    }*/

    function getPlayerData(uint256 tokenId) public view returns (PlayerData memory) {
        require(_exists(tokenId), "Token ID does not exist");
        return playerData[tokenId];
    }

    function burn(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You must own the token to burn it");
        _burn(tokenId);
        delete playerData[tokenId];
    }
}
