pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenDeposit {
    using SafeERC20 for IERC20;

    struct Deposit {
        address depositor;
        string symbol;
        uint256 amount;
        uint256 blockNumber;
        bool withdrawn;
        bool eventOccurred;
    }

    mapping(bytes32 => Deposit) public deposits;

    event DepositLocked(bytes32 depositId, address indexed depositor, string symbol, uint256 amount, uint256 blockNumber);
    event Withdrawn(bytes32 depositId);
    event EventOccurred(bytes32 depositId);

    function deposit(address token, string memory symbol, uint256 amount, uint256 blockNumber) public {
        require(amount > 0, "Amount must be greater than zero.");
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        bytes32 depositId = keccak256(abi.encodePacked(msg.sender, symbol, amount, blockNumber));
        deposits[depositId] = Deposit(msg.sender, symbol, amount, blockNumber, false, false);

        emit DepositLocked(depositId, msg.sender, symbol, amount, blockNumber);
    }

    function withdraw(bytes32 depositId, address token) public {
        Deposit storage deposit = deposits[depositId];

        require(!deposit.withdrawn, "Deposit already withdrawn.");
        require(deposit.depositor == msg.sender, "Only the depositor can withdraw the deposit.");
        require(deposit.eventOccurred || block.number >= deposit.blockNumber, "Conditions for withdrawal not met.");

        deposit.withdrawn = true;
        IERC20(token).safeTransfer(msg.sender, deposit.amount);

        emit Withdrawn(depositId);
    }

    function triggerEvent(bytes32 depositId) public {
        // Check the validity of the Merkle proof here and set isValid to true or false accordingly
        bool isValid = false;

        if (!isValid) {
            Deposit storage deposit = deposits[depositId];
            require(!deposit.eventOccurred, "Event already occurred.");

            deposit.eventOccurred = true;

            emit EventOccurred(depositId);
        }
    }
}
