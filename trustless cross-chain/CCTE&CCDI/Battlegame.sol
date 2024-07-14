pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BattleGame is Ownable {

    IERC721 public nft;
    address public trustedNFTManagement;
    uint256 private constant RANDOM_MIN = 80;
    uint256 private constant RANDOM_MAX = 100;

    struct PlayerData {
        string name;
        uint256 attack;
        uint256 defense;
        uint256 experience;
    }

    mapping(uint256 => PlayerData) public playerData;

    constructor(address _nftAddress) {
        nft = IERC721(_nftAddress);
    }
    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp))) % (RANDOM_MAX - RANDOM_MIN + 1) + RANDOM_MIN;
    }

    function playerVersusPlayer(uint256 tokenId1, uint256 tokenId2) public {
        //require(nft.ownerOf(tokenId1) == msg.sender || nft.ownerOf(tokenId2) == msg.sender, "You must own one of the tokens");

        PlayerData storage player1 = playerData[tokenId1];
        PlayerData storage player2 = playerData[tokenId2];
        uint256 r1 = random();
        uint256 r2 = random();

        int256 s = int256((player1.attack + player1.defense + player1.experience) * r1) - int256((player2.attack + player2.defense + player2.experience) * r2);

        if (s > 0) {
            player1.attack += 10;
            player1.defense += 10;
            player1.experience += 100;

            player2.attack += 1;
            player2.defense += 1;
            player2.experience += 50;
        } else {
            player1.attack += 1;
            player1.defense += 1;
            player1.experience += 50;

            player2.attack += 10;
            player2.defense += 10;
            player2.experience += 100;
        }
    }

    function playerVersusNPC(uint256[] memory tokenIds, uint256 npcAttack, uint256 npcDefense) public {
        uint256 p = tokenIds.length;
        uint256 r1 = random();
        uint256 r2 = random();

        int256 s = 0;
        for (uint256 i = 0; i < p; i++) {
            PlayerData storage player = playerData[tokenIds[i]];
            s += int256((player.attack + player.defense + player.experience) * r1);
        }
        s -= int256((npcAttack + npcDefense) * r2);

        for (uint256 i = 0; i < p; i++) {
            PlayerData storage player = playerData[tokenIds[i]];
            if (s > 0) {
                player.attack += 100;
                player.defense += 100;
                player.experience += 1000;
            } else {
                player.attack += 50;
                player.defense += 50;
                player.experience += 500;
            }
        }
    }
     function getNFTData(uint256 tokenId) external view returns (PlayerData memory) {
        require(nft.ownerOf(tokenId) != address(0), "NFT does not exist");
        return playerData[tokenId];
    }
    function deletePlayerData(uint256 tokenId) external {
        require(msg.sender == trustedNFTManagement, "Only the trusted NFTManagement contract can call this function");
        delete playerData[tokenId];
    }

    // Other functions remain the same ...

    function setTrustedNFTManagement(address _trustedNFTManagement) external onlyOwner {
        trustedNFTManagement = _trustedNFTManagement;
    }
    function getplayerData(uint256 tokenId) public view returns (PlayerData memory) {
    return playerData[tokenId];
}

}
