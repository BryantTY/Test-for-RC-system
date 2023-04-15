pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BurnToMint is ERC721 {
    address public blackholeAddress;

    constructor(address _blackholeAddress) ERC721("BurnToMint", "BTM") {
        blackholeAddress = _blackholeAddress;
    }

    function burnToMint(address _to, uint256 _daiAmount) public {
        IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        dai.transferFrom(msg.sender, blackholeAddress, _daiAmount);
        uint256 tokenId = totalSupply() + 1;
        _safeMint(_to, tokenId);
        emit BurnToMintEvent(_daiAmount, tokenId, block.number, msg.sender);
    }

    event BurnToMintEvent(uint256 daiAmount, uint256 tokenId, uint256 blockNumber, address sender);
}