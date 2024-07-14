pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ICustomERC721 is IERC721 {
    function mintNewNFD(address to) external returns (uint256);
    function burn(uint256 tokenId) external;
}

contract LockAndBurnToMint {
    ICustomERC721 public nfd;
    IERC20 public coin;
    Settlement public settlement;

    constructor(address _nfd, address _coin, address _settlement) {
        nfd = ICustomERC721(_nfd);
        coin = IERC20(_coin);
        settlement = Settlement(_settlement);
    }

    function lockAndBurn(
        uint256 nfdId,
        uint256 nfdPrice,
        address userAddress,
        address memberAddress,
        uint256 _timePointT
    ) external {
        require(nfd.ownerOf(nfdId) == userAddress, "User does not own NFD");
        // Additional checks for up-to-date NFD and correct price
        nfd.transferFrom(userAddress, address(this), nfdId);
        //settlement.processNFD(nfdId, nfdPrice, userAddress, memberAddress, _timePointT);
    }
}


contract Settlement {
    ICustomERC721 public nfd;
    IERC20 public coin;
    uint256 public deltaT;

    event Failure(uint256 indexed nfdId, address indexed userAddress);

    constructor(address _nfd, address _coin, uint256 _deltaT) {
        nfd = ICustomERC721(_nfd);
        coin = IERC20(_coin);
        deltaT = _deltaT;
    }


    function processNFD(
        uint256 nfdId,
        uint256 nfdPrice,
        address userAddress,
        address memberAddress,
        uint256 timePointT
    ) external {
        // Situation 1: No valid Trans_(m,i) is received
        if (block.number > timePointT + deltaT) {
            emit Failure(nfdId, userAddress);
            // Continue to lock NFD and wait for the next message
        } else {
            // Situation 2: Valid Trans_(m,i) is received
            require(coin.balanceOf(memberAddress) >= nfdPrice, "Member does not have sufficient Coin");
            burnToMint(nfdId, nfdPrice, userAddress, memberAddress);
        }
    }

    function burnToMint(
        uint256 nfdId,
        uint256 nfdPrice,
        address userAddress,
        address memberAddress
    ) internal {
        // First burn to mint operation
        coin.transferFrom(memberAddress, address(0), nfdPrice); // Burn coins
        // Generate NFD_(j,i)^new and transfer it to userAddress
        uint256 newNfdId = nfd.mintNewNFD(userAddress);
        // Second burn to mint operation
        nfd.burn(nfdId); // Burn NFD
        coin.transfer(memberAddress, nfdPrice); // Mint coins
    }
}
