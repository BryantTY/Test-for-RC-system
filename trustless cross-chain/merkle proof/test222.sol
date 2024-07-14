pragma solidity ^0.8.0;

contract SimpleNFT {
    struct NFT {
        uint256 attack;
        uint256 defense;
        uint256 experience;
        uint256 luck;
        string city;
        string country;
        string name;
        string extraField1;
        string extraField2;
    }

    mapping(address => NFT) public nftData;

    function createNFT(
        uint256 attack,
        uint256 defense,
        uint256 experience,
        uint256 luck,
        string memory city,
        string memory country,
        string memory name,
        string memory extraField1,
        string memory extraField2
    ) public {
        NFT memory newNFT = NFT({
            attack: attack,
            defense: defense,
            experience: experience,
            luck: luck,
            city: city,
            country: country,
            name: name,
            extraField1: extraField1,
            extraField2: extraField2
        });

        nftData[msg.sender] = newNFT;
    }
    function getNFT(address owner) public view returns (NFT memory) {
        return nftData[owner];
    }
}
