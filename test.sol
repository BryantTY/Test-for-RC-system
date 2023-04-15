// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./SimpleDAI.sol";
import "./SimpleAMM.sol";
import "./simpleAMM1.sol";
import "./metazerocoin.sol";

contract Retailer {
    struct RetailerInfo {
        address intermediary1;
        string tokenId1;
        uint256 amount1;
        string blockchainId1;
        address intermediary2;
        /*string tokenId2;
        uint256 amount2;
        string blockchainId2;*/
    }

    mapping(address => RetailerInfo) public retailers;
    address[] public retailerAddresses;
// Add the SimpleAMM contract instance
    SimpleAMM public simpleAMM;
    SimpleAMM1 public simpleAMM1;

    constructor(address _simpleAMMAddress,address _simpleAMMAddress1) {
        simpleAMM = SimpleAMM(_simpleAMMAddress);
        simpleAMM1 = SimpleAMM1(_simpleAMMAddress1);
    }

    function retailerCapacity(
        address account,
        address intermediary1,
        string memory tokenId1,
        uint256 _amount1,
        string memory blockchainId1,
        address intermediary2/*,
        string memory tokenId2,
        uint256 _amount2,
        string memory blockchainId2*/
    ) public {
        require(account == msg.sender, "Only the account owner can update the retailer capacity");
        
        RetailerInfo memory newRetailer = RetailerInfo(
            intermediary1,
            tokenId1,
            _amount1,
            blockchainId1,
            intermediary2
            /*tokenId2,
            _amount2,
            blockchainId2*/
        );

        retailers[account] = newRetailer;
        retailerAddresses.push(account);
    }

   function retailerCapacity1(
        address account,
        address intermediary1,
        string memory tokenId1,
        uint256 _amount1,
        string memory blockchainId1,
        address intermediary2/*,
        string memory tokenId2,
        uint256 _amount2,
        string memory blockchainId2*/
    ) public {
        require(account == msg.sender, "Only the account owner can update the retailer capacity");
        
        RetailerInfo memory newRetailer = RetailerInfo(
            intermediary1,
            tokenId1,
            _amount1,
            blockchainId1,
            intermediary2
            /*tokenId2,
            _amount2,
            blockchainId2*/
        );

        retailers[account] = newRetailer;
        retailerAddresses.push(account);
    }
    /*function updateRetailerCapacity(
        address account,
        address intermediary1,
        string memory tokenId1,
        uint256 _amount1,
        string memory blockchainId1,
        address intermediary2,
        string memory tokenId2,
        uint256 _amount2,
        string memory blockchainId2
    ) public {
        require(account == msg.sender, "Only the account owner can update the retailer capacity");

        RetailerInfo memory updatedRetailer = RetailerInfo(
            intermediary1,
            tokenId1,
            _amount1,
            blockchainId1,
            intermediary2,
            tokenId2,
            _amount2,
            blockchainId2
        );

        retailers[account] = updatedRetailer;
    }*/

     function getTradingPair1(
        address requestor,
        address receiver,
        string memory tokenId1,
        uint256 amount1,
        string memory blockchainId1
    ) public returns (address, address, string memory, uint256, string memory) {
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % retailerAddresses.length;
        address selectedRetailer = retailerAddresses[randomIndex];

        RetailerInfo memory retailerInfo = retailers[selectedRetailer];

        uint256 exchangeRate = simpleAMM.getExchangeRate();
        uint256 EtherBalance = simpleAMM.etherBalance();
        uint256 requiredDAI = EtherBalance / exchangeRate; // Update this to calculate the required DAI value based on token prices

        require(
            keccak256(abi.encodePacked(tokenId1)) == keccak256(abi.encodePacked(retailerInfo.tokenId1)) &&
            amount1 <= retailerInfo.amount1 &&
            EtherBalance / exchangeRate >= requiredDAI,
            "Selected retailer does not meet the requirement"
        );

        return (
            retailerInfo.intermediary1, receiver, tokenId1, amount1, blockchainId1
        );
    }

    /*function getTradingPair2(
        address requestor,
        address receiver,
        string memory tokenId2,
        uint256 amount2,
        string memory blockchainId2
    ) public returns (address, address, string memory, uint256, string memory) {
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % retailerAddresses.length;
        address selectedRetailer = retailerAddresses[randomIndex];

        RetailerInfo memory retailerInfo = retailers[selectedRetailer];

        uint256 exchangeRate = simpleAMM1.getExchangeRate();
        uint256 MTZBalance = simpleAMM1.MTZBalance();
        uint256 requiredDAI = amount2; // Update this to calculate the required DAI value based on token prices

        require(
            MTZBalance / exchangeRate >= requiredDAI,
            "Selected retailer does not meet the requirement"
        );

        return (
            requestor, retailerInfo.intermediary2, tokenId2, amount2, blockchainId2
        );
    }*/
}




