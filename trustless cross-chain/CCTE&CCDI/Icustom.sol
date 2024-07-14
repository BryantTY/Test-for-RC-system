pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


interface ICustomERC721 is IERC721 {
    function mintNewNFD(address to) external returns (uint256);
    function burn(uint256 tokenId) external;
}


contract NFDTokens is ERC721, Ownable, ICustomERC721 {
    uint256 private nextTokenId = 1;
    address public settlementAddress;

    constructor(address _settlementAddress) ERC721("Non-Fungible Deposit Tokens", "NFD") {
        settlementAddress = _settlementAddress;
    }

    modifier onlySettlement() {
        require(msg.sender == settlementAddress, "Caller is not the Settlement contract");
        _;
    }

    function mintNewNFD(address to) public onlySettlement returns (uint256) {
        uint256 newNfdId = nextTokenId;
        _safeMint(to, newNfdId);
        nextTokenId = nextTokenId + 1;
        return newNfdId;
    }

    function burn(uint256 tokenId) external override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not owner nor approved");
        _burn(tokenId);
    }
}
