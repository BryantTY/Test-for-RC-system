pragma solidity ^0.8.0;

import "./NFTMPV.sol";
import "./Battlegame.sol";
import "./Member.sol";
import "./creatBGNFT.sol";

contract NFTManagement {
    MerkleProofVerification public merkleProofVerification;
    BattleGame public battleGame;
    Member public memberContract;
    PlayerNFT public nft;

    constructor(
        address _merkleProofVerification,
        address _battleGame,
        address _memberContract,
        address _nft
    ) {
        merkleProofVerification = MerkleProofVerification(_merkleProofVerification);
        battleGame = BattleGame(_battleGame);
        memberContract = Member(_memberContract);
        nft = PlayerNFT(_nft);
    }
    function getRandomMemberWithMinBalance(uint256 minBalance) private view returns (address) {
        address[] memory eligibleMembers = memberContract.getMembersWithMinimumBalance(minBalance);
        require(eligibleMembers.length > 0, "No eligible members found");

        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % eligibleMembers.length;
        return eligibleMembers[randomIndex];
    }
    function processNFT(address userAddress, 
        address player,
        string memory name,
        uint256 attack,
        uint256 defense,
        uint256 experience) external {
        MerkleProofVerification.MerkleNFT memory merkleData = merkleProofVerification.getstoredMerkleData(userAddress);
        //require(merkleData.merkleRoot != bytes32(0), "Merkle data not found");

        BattleGame.PlayerData memory playerData = battleGame.getplayerData(merkleData.tokenId);
        require(playerData.experience != 0, "Player data not found");

        if (merkleData.merkleProofType == 1) {
            // Delete tokenId from BattleGame contract
            battleGame.deletePlayerData(merkleData.tokenId);
        } else if (merkleData.merkleProofType == 2) {
            // Generate NFTidentifier and transfer to userAddress
            nft.createPlayer(player, name, attack, defense, experience);
        } else {
            address randomMember = getRandomMemberWithMinBalance(100);
            Member.MemberInfo memory memberInfo = memberContract.getmembers(randomMember);
            require(memberInfo.PK_mEthereum != address(0), "Member not found");
            // Process member info (depends on your use case)
            // ...
        }
    }
}
