pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenDeposit {
    using SafeERC20 for IERC20;

    address public validationContract;

    struct Deposit {
        address depositor;
        string symbol;
        uint256 amount;
        uint256 blockNumber;
        bool withdrawn;
    }

    mapping(bytes32 => Deposit) public deposits;
    mapping(address => bytes32[]) public depositsByAddress;

    event DepositLocked(bytes32 depositId, address indexed depositor, string symbol, uint256 amount, uint256 blockNumber);
    event Withdrawn(bytes32 depositId);

    constructor(address _validationContract) {
        validationContract = _validationContract;
    }

    function deposit(address token, string memory symbol, uint256 amount, uint256 blockNumber, bool triggerEvent) public {
        require(amount > 0, "Amount must be greater than zero.");

        // Ensure the depositor has enough balance
        require(IERC20(token).balanceOf(msg.sender) >= amount, "Insufficient token balance");

        // Ensure the contract is allowed to transfer the specified amount
        require(IERC20(token).allowance(msg.sender, address(this)) >= amount, "Allowance is not enough");

        // Transfer tokens from depositor to this contract
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        // Generate a unique deposit ID
        bytes32 depositId = keccak256(abi.encodePacked(msg.sender, symbol, amount, blockNumber));
        deposits[depositId] = Deposit(msg.sender, symbol, amount, blockNumber, false);
        depositsByAddress[msg.sender].push(depositId);

        emit DepositLocked(depositId, msg.sender, symbol, amount, blockNumber);
    }

    function withdraw(bytes32 depositId, address token) public {
        Deposit storage deposit = deposits[depositId];

        require(!deposit.withdrawn, "Deposit already withdrawn.");
        require(deposit.depositor == msg.sender, "Only the depositor can withdraw the deposit.");
        require(block.number >= deposit.blockNumber, "Conditions for withdrawal not met.");

        deposit.withdrawn = true;
        IERC20(token).safeTransfer(msg.sender, deposit.amount);

        emit Withdrawn(depositId);
    }

    function confiscateAndWithdraw(bytes32 depositId, address token, address to) external {
        require(msg.sender == validationContract, "Only validation contract can confiscate");

        Deposit storage deposit = deposits[depositId];
        uint256 amount = deposit.amount;

        require(amount > 0, "No funds to confiscate");
        
        deposit.amount = 0;
        IERC20(token).safeTransfer(to, amount);
    }

    // 新增函数，用于获取存款信息
    function getDepositInfo(address depositor) public view returns (Deposit[] memory) {
        bytes32[] memory depositIds = depositsByAddress[depositor];
        Deposit[] memory depositorDeposits = new Deposit[](depositIds.length);

        for (uint256 i = 0; i < depositIds.length; i++) {
            depositorDeposits[i] = deposits[depositIds[i]];
        }

        return depositorDeposits;
    }
}