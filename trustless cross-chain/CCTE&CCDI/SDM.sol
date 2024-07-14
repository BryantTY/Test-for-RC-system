// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./creatBGNFT.sol";
import "./Claim.sol";

contract StateDataMigration {
    //bytes32 public rootHash;  // Merkle root
    PlayerNFT public playerNFT;
    MyToken public myToken;

    event FunctionOneExecuted(address to, uint256 tokenId);
    event FunctionTwoExecuted(address to, uint256 amount);

    constructor(/*bytes32 _rootHash, */address _playerNFT, address _myToken) {
        //rootHash = _rootHash;
        playerNFT = PlayerNFT(_playerNFT);
        myToken = MyToken(_myToken);
    }

    function functionOne(bytes32[] memory proof, uint256 tokenId, address to) public {
        bytes32 leaf = keccak256(abi.encodePacked(tokenId));
        //require(MerkleProof.verify(proof, rootHash, leaf), "Invalid Merkle Proof");
        
        PlayerNFT.PlayerData memory data = playerNFT.getPlayerData(tokenId);
        playerNFT.createPlayer(to, data.name, data.attack, data.defense, data.experience);
        
        emit FunctionOneExecuted(to, tokenId);
    }

    function functionTwo(/*bytes32[] memory proof,*/ uint256 amount, address to) public {
        bytes32 leaf = keccak256(abi.encodePacked(amount));
        //require(MerkleProof.verify(proof, rootHash, leaf), "Invalid Merkle Proof");
        
        myToken.mint(to, amount);

        emit FunctionTwoExecuted(to, amount);
    }
}
