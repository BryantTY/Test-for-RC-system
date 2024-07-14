pragma solidity ^0.8.0;

contract Deposit {
    struct DepositInfo {
        uint256 amount;
        uint256 unlockBlock;
    }

    mapping(address => DepositInfo) public deposits;
    address public validationContract;

    constructor(address _validationContract) {
        validationContract = _validationContract;
    }

    function deposit(uint256 k) external payable {
        require(msg.value > 0, "Must send ether to deposit");
        require(deposits[msg.sender].amount == 0, "Existing deposit not withdrawn");

        deposits[msg.sender] = DepositInfo({
            amount: msg.value,
            unlockBlock: block.number + k
        });
    }

    function withdraw() external {
        require(deposits[msg.sender].amount > 0, "No deposit found");
        require(block.number >= deposits[msg.sender].unlockBlock, "Withdrawal is locked");

        uint256 amount = deposits[msg.sender].amount;
        deposits[msg.sender].amount = 0;
        payable(msg.sender).transfer(amount);
    }

    function confiscate(address user) external {
        require(msg.sender == validationContract, "Only validation contract can confiscate");

        deposits[user].amount = 0;
    }
}
