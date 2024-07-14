pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./creatBGNFT.sol";

contract NFTLock is Ownable {
    PlayerNFT public playerNFT;
    IERC20 public coin;
    uint256 public nftPrice;
    uint256 public lockBlockSeriesNumber;
    address public settlementAddress;

    struct LockedNFT {
        bool isLocked;
        uint256 unlockBlockSeriesNumber;
    }

    mapping(uint256 => LockedNFT) public lockedNFTs;

    constructor(address _playerNFTAddress, address _coinAddress) {
        playerNFT = PlayerNFT(_playerNFTAddress);
        coin = IERC20(_coinAddress);
    }

    function setSettlementAddress(address _settlementAddress) external onlyOwner {
        settlementAddress = _settlementAddress;
    }

    function lockNFT(
        uint256 nftId,
        uint256 _nftPrice,
        address userAddress,
        address memberAddress,
        uint256 _blockSeriesNumber
    ) external onlyOwner {
        require(playerNFT.ownerOf(nftId) != address(0), "NFT does not exist");

        LockedNFT storage lockedNFT = lockedNFTs[nftId];
        require(!lockedNFT.isLocked, "NFT has already been locked");

        //nftPrice = 10 wei;

        if (block.number < _blockSeriesNumber) {
            lockedNFT.isLocked = true;
            lockedNFT.unlockBlockSeriesNumber = _blockSeriesNumber;
        } else {
            revert("Current block series number is greater than or equal to the provided block series number");
        }
    }


    function isNFTLocked(uint256 nftId) external view returns (bool) {
        return lockedNFTs[nftId].isLocked;
    }
    
    function burnToMint(
        uint256 nftId,
        uint256 nftPrice,
        address userAddress,
        address memberAddress,
        string calldata name,
        uint256 attack,
        uint256 defense,
        uint256 experience
    ) external { 

        require(msg.sender == settlementAddress, "Only the Settlement contract can call this function");
        
        // First burn to mint operation
        coin.transferFrom(memberAddress, address(0), nftPrice); // Burn coins
        // Generate NFD_(j,i)^new and transfer it to userAddress
        uint256 newNfdId = playerNFT.createPlayer(userAddress, name, attack, defense, experience);
        // Second burn to mint operation
        playerNFT.burn(nftId); // Burn NFT
        coin.transfer(memberAddress, nftPrice); // Mint coins
    }


    function getCurrentBlockNumber() external view returns (uint256) {
        return block.number;
    }
}
