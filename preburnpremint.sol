// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./ISimpleDAI.sol";

contract PreBurnPreMint {
    IERC721 public nft;
    ISimpleDAI public dai;
    address public burnToMintAddress;
    uint256 public lockPeriod = 20;

    struct LockInfo {
        uint256 nftId;
        uint256 unlockBlock;
        address owner;
        uint256 daiAmount;
        bool settled;
    }

    mapping(uint256 => LockInfo) public lockedNfts;
    uint256 public lockIndex;

    event PreBurnLocked(uint256 indexed lockId, uint256 indexed nftId, uint256 unlockBlock, address indexed owner);
    event PreMint(uint256 indexed lockId, uint256 indexed nftId, uint256 daiAmount);
    event PreBurnSettled(uint256 indexed lockId, uint256 indexed nftId, address indexed to);
    event PreMintSettled(uint256 indexed lockId, uint256 daiAmount, address indexed to);

    constructor(IERC721 _nft, ISimpleDAI _dai) {
        nft = _nft;
        dai = _dai;
    }

    function preBurn(uint256 nftId, uint256 unlockBlock, address to) external {
        require(unlockBlock > block.number, "Unlock block must be in the future");
        nft.transferFrom(msg.sender, address(this), nftId);

        lockedNfts[lockIndex] = LockInfo(nftId, unlockBlock, msg.sender, 0, false);
        emit PreBurnLocked(lockIndex, nftId, unlockBlock, msg.sender);

        lockIndex++;
    }

    function preMint(uint256 lockId, uint256 daiAmount) external {
        require(!lockedNfts[lockId].settled, "Pre-burn already settled");
        require(lockedNfts[lockId].owner != address(0), "Invalid lock ID");

        lockedNfts[lockId].daiAmount = daiAmount;
        emit PreMint(lockId, lockedNfts[lockId].nftId, daiAmount);
    }

    function settlePreBurn(uint256 lockId, uint256 nftId, address to, uint256 currentBlockNumber) external {
        require(!lockedNfts[lockId].settled, "Pre-burn already settled");
        require(currentBlockNumber >= lockedNfts[lockId].unlockBlock, "Unlock block not reached");
        require(lockedNfts[lockId].owner == msg.sender || to == msg.sender, "Invalid msg.sender");

        nft.transferFrom(address(this), to, nftId);
        lockedNfts[lockId].settled = true;
        emit PreBurnSettled(lockId, nftId, to);
    }

    function settlePreMint(uint256 lockId, address to) external {
        require(lockedNfts[lockId].settled, "Pre-burn not settled");
        require(lockedNfts[lockId].owner == msg.sender || lockedNfts[lockId].owner == to, "Invalid recipient");

        uint256 daiAmount = lockedNfts[lockId].daiAmount;
        dai.mintWithoutCollateral(to, daiAmount);

        emit PreMintSettled(lockId, daiAmount, to);
    }

    function setBurnToMintAddress(address _burnToMintAddress) external {
        burnToMintAddress =_burnToMintAddress;
    }

    function setLockPeriod(uint256 _lockPeriod) external {
        lockPeriod = _lockPeriod;
    }
}