pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./LockNFTBtM.sol";

contract Settlement is Ownable {
    NFTLock public nftLock;

    event NewNFTUpdateFailed(uint256 nftId);

    constructor(address _nftLockAddress) {
        nftLock = NFTLock(_nftLockAddress);
    }

    function processLockedNFT(
    uint256 nftId,
    uint256 nftPrice,
    address userAddress,
    address memberAddress,
    string calldata name,
    uint256 attack,
    uint256 defense,
    uint256 experience
) external {
        // In Settlement contract
        if (nftLock.isNFTLocked(nftId)) {
            nftLock.burnToMint(nftId, nftPrice, userAddress, memberAddress, name, attack, defense, experience);
        } else {
            emit NewNFTUpdateFailed(nftId);
        }
    }
}
