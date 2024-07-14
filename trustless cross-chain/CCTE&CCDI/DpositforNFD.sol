pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Deposit is Ownable {
    struct DepositInfo {
        uint256 amount;
        uint256 withdrawalUnlockTime;
    }

    mapping(address => mapping(address => DepositInfo)) public deposits;

    function deposit(address tokenAddress, uint256 amount, uint256 lockDuration) external {
        IERC20 token = IERC20(tokenAddress);
        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        DepositInfo storage userDeposit = deposits[msg.sender][tokenAddress];
        userDeposit.amount += amount;
        userDeposit.withdrawalUnlockTime = block.number + lockDuration;
    }

    function withdraw(address tokenAddress) external {
        DepositInfo storage userDeposit = deposits[msg.sender][tokenAddress];
        uint256 amount = userDeposit.amount;
        uint256 withdrawalUnlockTime = userDeposit.withdrawalUnlockTime;

        require(block.number >= withdrawalUnlockTime, "Withdrawal is not allowed yet");
        require(amount > 0, "No deposited amount available");

        userDeposit.amount = 0;
        userDeposit.withdrawalUnlockTime = 0;

        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, amount);
    }

    function getDepositedCoinBalance(address user, address tokenAddress) external view returns (uint256) {
        return deposits[user][tokenAddress].amount;
    }

    function getWithdrawalUnlockTime(address user, address tokenAddress) external view returns (uint256) {
        return deposits[user][tokenAddress].withdrawalUnlockTime;
    }
}
