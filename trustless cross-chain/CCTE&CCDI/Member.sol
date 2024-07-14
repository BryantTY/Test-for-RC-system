pragma solidity ^0.8.0;

import "./DpositforNFD.sol";

contract Member {
    struct MemberInfo {
        address PK_mi;
        address PK_mj;
        address PK_mEthereum;
        uint256 x_mj;
        uint256 E_ij;
        uint256 x_mEthereum;
        uint256 k;
        uint256 lastUpdateBlock;
    }

    mapping(address => MemberInfo) public members;
    Deposit public depositContract;
    uint256 public L;
    
    // Add an array to store registered member addresses
    address[] public registeredMemberAddresses;

    constructor(address _depositContract, uint256 _L) {
        depositContract = Deposit(_depositContract);
        L = _L;
    }

    // ...

    function registerMember(
        address PK_mi,
        address PK_mj,
        address PK_mEthereum,
        uint256 x_mj,
        uint256 E_ij,
        uint256 x_mEthereum,
        uint256 k
    ) external {
        require(members[msg.sender].PK_mEthereum == address(0), "Member already registered");

        //uint256 depositedAmount = depositContract.getDepositedCoinBalance(msg.sender, PK_mEthereum);
        //uint256 withdrawalUnlockTime = depositContract.getWithdrawalUnlockTime(msg.sender, PK_mEthereum);


        //require(depositedAmount == x_mEthereum && withdrawalUnlockTime == k, "Deposit info mismatch");

        // ...
        members[msg.sender] = MemberInfo({
            PK_mi: PK_mi,
            PK_mj: PK_mj,
            PK_mEthereum: PK_mEthereum,
            x_mj: x_mj,
            E_ij: E_ij,
            x_mEthereum: x_mEthereum,
            k: k,
            lastUpdateBlock: block.number
        });

        // Add the address to the registeredMemberAddresses array
        registeredMemberAddresses.push(msg.sender);
    }

// ...


    function updateMemberInfo(
        uint256 x_mj,
        uint256 E_ij,
        uint256 x_mEthereum,
        uint256 k
    ) external {
        require(members[msg.sender].PK_mEthereum != address(0), "Member not registered");
        require(block.number >= members[msg.sender].lastUpdateBlock + L, "Update not allowed yet");

        uint256 x_mEthereum = depositContract.getDepositedCoinBalance(msg.sender, members[msg.sender].PK_mEthereum);
        uint256 k = depositContract.getWithdrawalUnlockTime(msg.sender, members[msg.sender].PK_mEthereum);
        require(x_mEthereum == x_mEthereum && k == k, "Deposit info mismatch");


        members[msg.sender].x_mj = x_mj;
        members[msg.sender].E_ij = E_ij;
        members[msg.sender].x_mEthereum = x_mEthereum;
        members[msg.sender].k = k;
        members[msg.sender].lastUpdateBlock = block.number;
    }

    function getmembers(address userAddress) public view returns (MemberInfo memory) {
        return members[userAddress];
    }

    // Modify the getMembersWithMinimumBalance function to use registeredMemberAddresses for iteration
    function getMembersWithMinimumBalance(uint256 minBalance) public view returns (address[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < registeredMemberAddresses.length; i++) {
            if (members[registeredMemberAddresses[i]].x_mEthereum >= minBalance) {
                count++;
            }
        }

        address[] memory eligibleMembers = new address[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < registeredMemberAddresses.length; i++) {
            if (members[registeredMemberAddresses[i]].x_mEthereum >= minBalance) {
                eligibleMembers[index] = members[registeredMemberAddresses[i]].PK_mEthereum;
                index++;
            }
        }

        return eligibleMembers;
    }

    // Add a function to get the total number of registered members
    function getNumberOfRegisteredMembers() public view returns (uint256) {
        return registeredMemberAddresses.length;
    }
}