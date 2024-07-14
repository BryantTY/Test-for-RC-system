pragma solidity ^0.8.0;

import "./test222.sol";

contract NFTStorage {
    SimpleNFT public simpleNFTContract;
    mapping(address => SimpleNFT.NFT) public storedNFTs;

    constructor(address _simpleNFTAddress) {
        simpleNFTContract = SimpleNFT(_simpleNFTAddress);
    }

    function storeNFT(address _nftOwner) public {
        SimpleNFT.NFT memory nftToStore = simpleNFTContract.getNFT(_nftOwner);
        storedNFTs[_nftOwner] = nftToStore;
    }
}
