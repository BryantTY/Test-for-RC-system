// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingContract is Ownable {
    IERC721 public gameItemContract;
    address public blackholeAddress;
    uint256 public deltaK;
    uint256 public deltaB;
    uint256 public deltaD;

    struct StakeInfo {
        address owner;
        uint256 tokenId;
        uint256 lockTime;
        uint256 deadline;
    }

    mapping(bytes32 => StakeInfo) public stakes;

    event StakeLocked(bytes32 stakeId, address owner, uint256 tokenId, uint256 deadline);
    event Burned(uint256 oldTokenId);

    constructor(
        address _gameItemContract,
        address _blackholeAddress,
        uint256 _deltaK,
        uint256 _deltaB,
        uint256 _deltaD
    ) {
        gameItemContract = IERC721(_gameItemContract);
        blackholeAddress = _blackholeAddress;
        deltaK = _deltaK;
        deltaB = _deltaB;
        deltaD = _deltaD;
    }

    function lock(uint256 tokenId) external {
        require(gameItemContract.ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");

        bytes32 stakeId = keccak256(abi.encodePacked(tokenId, msg.sender, block.timestamp));
        uint256 lockTime = block.timestamp;
        uint256 deadline = lockTime + deltaK + deltaB + deltaD;

        stakes[stakeId] = StakeInfo(msg.sender, tokenId, lockTime, deadline);

        gameItemContract.transferFrom(msg.sender, address(this), tokenId);

        emit StakeLocked(stakeId, msg.sender, tokenId, deadline);
    }

    function burn(bytes32 stakeId) external onlyOwner {
        StakeInfo storage stake = stakes[stakeId];
        require(stake.deadline <= block.timestamp, "Deadline not reached");
        require(stake.owner != address(0), "Invalid stake");

        gameItemContract.transferFrom(address(this), blackholeAddress, stake.tokenId);

        delete stakes[stakeId];

        emit Burned(stake.tokenId);
    }

    function getStakeInfo(bytes32 stakeId) external view returns (StakeInfo memory) {
        return stakes[stakeId];
    }
}