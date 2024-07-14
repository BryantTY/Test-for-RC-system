pragma solidity ^0.8.0;

import "./Deposit.sol";

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

    constructor(address _depositContract, uint256 _L) {
        depositContract = Deposit(_depositContract);
        L = _L;
    }

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

        Deposit.DepositInfo memory depositInfo = depositContract.getDepositInfo(PK_mEthereum);
        require(depositInfo.amount == x_mEthereum && depositInfo.unlockBlock == k, "Deposit info mismatch");

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
    }

    function updateMemberInfo(
        uint256 x_mj,
        uint256 E_ij,
        uint256 x_mEthereum,
        uint256 k
    ) external {
        require(members[msg.sender].PK_mEthereum != address(0), "Member not registered");
        require(block.number >= members[msg.sender].lastUpdateBlock + L, "Update not allowed yet");

        Deposit.DepositInfo memory depositInfo = depositContract.getDepositInfo(members[msg.sender].PK_mEthereum);
        require(depositInfo.amount == x_mEthereum && depositInfo.unlockBlock == k, "Deposit info mismatch");

        members[msg.sender].x_mj = x_mj;
        members[msg.sender].E_ij = E_ij;
        members[msg.sender].x_mEthereum = x_mEthereum;
        members[msg.sender].k = k;
        members[msg.sender].lastUpdateBlock = block.number;
    }
    function getmembers(address userAddress) public view returns (MemberInfo memory) {
        return members[userAddress];
    }
    // In the Member contract
    function getMembersWithMinimumBalance(uint256 minBalance) public view returns (address[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < members.length; i++) {
            if (members[i].x_mEthereum >= minBalance) {
                count++;
            }
        }

        address[] memory eligibleMembers = new address[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < members.length; i++) {
            if (members[i].x_mEthereum >= minBalance) {
                eligibleMembers[index] = members[i].PK_mEthereum;
                index++;
            }
        }

        return eligibleMembers;
    }


}
