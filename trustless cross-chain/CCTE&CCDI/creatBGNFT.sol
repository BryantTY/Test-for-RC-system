pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PlayerNFT is ERC721, Ownable {
    uint256 private _currentTokenId = 0;

    struct PlayerData {
        string name;
        uint256 attack;
        uint256 defense;
        uint256 experience;
    }

    mapping(uint256 => PlayerData) public playerData;

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
