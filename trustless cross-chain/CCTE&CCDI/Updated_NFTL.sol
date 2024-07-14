pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTLock is Ownable {
    struct LockInfo {
        uint256 tokenId;
        uint256 unlockTime;
        bool isLocked;
    }

    mapping(address => mapping(uint256 => LockInfo)) public lockedNFTs;
    address public nftManagement;

    constructor(address _nftManagement) {
        nftManagement = _nftManagement;
    }

    function lockNFT(address nftAddress, uint256 tokenId, uint256 lockDuration) external {
        IERC721 nft = IERC721(nftAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "You must own the NFT to lock it");
        nft.transferFrom(msg.sender, address(this), tokenId);

        uint256 unlockTime = block.number + lockDuration;
        lockedNFTs[nftAddress][tokenId] = LockInfo({
            tokenId: tokenId,
            unlockTime: unlockTime,
            isLocked: true
        });
    }

    function unlockNFT(address nftAddress, uint256 tokenId) external {
        LockInfo storage lockInfo = lockedNFTs[nftAddress][tokenId];
        require(lockInfo.isLocked, "NFT is not locked");
        require(block.number >= lockInfo.unlockTime, "Lock period has not ended yet");
        require(msg.sender == nftManagement, "Only the NFTManagement contract can unlock the NFT");

        lockInfo.isLocked = false;
    }

    function setNftManagement(address _nftManagement) external onlyOwner {
        nftManagement = _nftManagement;
    }
}
