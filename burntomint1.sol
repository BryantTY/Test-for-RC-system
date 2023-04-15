// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./SimpleDAI.sol";

contract BurnToMint {
    SimpleDAI public dai;
    address public blackholeAddress;
    address public nftAddress;

    event BurnToMintEvent(uint256 indexed daiAmount, address indexed to, uint256 indexed nftId);

    constructor(SimpleDAI _dai, address _blackholeAddress, address _nftAddress) {
        dai = _dai;
        blackholeAddress = _blackholeAddress;
        nftAddress = _nftAddress;
    }

    function burnToMint(uint256 daiAmount, uint256 nftId) external {
        dai.transferFrom(msg.sender, blackholeAddress, daiAmount);

        IERC721 nft = IERC721(nftAddress);
        nft.safeTransferFrom(address(this), msg.sender, nftId);

        emit BurnToMintEvent(daiAmount, msg.sender, nftId);
    }

    function setBlackholeAddress(address _blackholeAddress) external {
        blackholeAddress = _blackholeAddress;
    }

    function setNftAddress(address _nftAddress) external {
        nftAddress = _nftAddress;
    }
}