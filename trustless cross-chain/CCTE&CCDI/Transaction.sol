pragma solidity ^0.8.0;

import "./TokenDeposit.sol";
import "./SimpleBalancerAMM.sol";

contract Transaction {
    TokenDeposit public depositContract;
    SimpleBalancerAMM public ammContract;
    uint256 public deadline;
    uint256 public instructionsTimestamp;

    mapping(address => Instruction) public instructions;

    struct Instruction {
        address sender;
        address receiver;
        uint256 transferAmount;
        address location;
    }

    struct Rates {
        uint256 eIJ;
        uint256 eKJ;
        uint256 xI;
        uint256 xK;
    }

    event TransactionCompleted(Instruction Sender1Instruction, Instruction Sender2Instruction);

    constructor(address _depositContract, address _ammContract) {
        depositContract = TokenDeposit(_depositContract);
        ammContract = SimpleBalancerAMM(_ammContract);
    }

    function executeTransaction(
        address[7] memory participants,
        address[3] memory tokens,
        uint256 xJ
    ) external {
        Rates memory rates = calculateRates(tokens, xJ);

        (uint256 sender1TotalDeposit, bool sender1DepositLocked) = getDepositInfo(participants[0]);
        (uint256 sender2TotalDeposit, bool sender2DepositLocked) = getDepositInfo(participants[1]);

        validateDeposits(sender1TotalDeposit, sender2TotalDeposit, rates.xK, sender1DepositLocked, sender2DepositLocked);

        Instruction memory sender1Instruction = Instruction({
            sender: participants[0],
            receiver: participants[2],
            transferAmount: rates.xI,
            location: participants[5]
        });

        Instruction memory sender2Instruction = Instruction({
            sender: participants[1],
            receiver: participants[3],
            transferAmount: xJ,
            location: participants[6]
        });

        // Store the instructions in the mapping
        instructions[msg.sender] = sender1Instruction;
        instructions[participants[4]] = sender2Instruction;

        // Record the timestamp of instruction generation
        instructionsTimestamp = block.timestamp;

        // Set the deadline to the current block number plus 100 blocks
        deadline = block.number + 100;

        emit TransactionCompleted(sender1Instruction, sender2Instruction);
    }

    function calculateRates(
        address[3] memory tokens,
        uint256 xJ
    ) internal view returns (Rates memory rates) {
        rates.eIJ = ammContract.getExchangeRate(tokens[0], tokens[1]);
        rates.eKJ = ammContract.getExchangeRate(tokens[2], tokens[1]);
        rates.xI = (xJ * 1e18) / rates.eIJ;
        rates.xK = (rates.eKJ * xJ) / 1e18;
    }

    function getDepositInfo(address depositor) internal view returns (uint256 totalDeposit, bool depositLocked) {
        TokenDeposit.Deposit[] memory deposits = depositContract.getDepositInfo(depositor);
        totalDeposit = 0;
        depositLocked = false;
        uint256 currentBlock = block.number;

        for (uint256 i = 0; i < deposits.length; i++) {
            if (!deposits[i].withdrawn) {
                totalDeposit += deposits[i].amount;
                if (deposits[i].blockNumber > currentBlock) {
                    depositLocked = true;
                }
            }
        }
    }

    function validateDeposits(
        uint256 sender1TotalDeposit,
        uint256 sender2TotalDeposit,
        uint256 requiredDeposit,
        bool sender1DepositLocked,
        bool sender2DepositLocked
    ) internal pure {
        require(sender1TotalDeposit >= requiredDeposit, "Sender1's deposit is insufficient");
        require(sender2TotalDeposit >= requiredDeposit, "Sender2's deposit is insufficient");
        require(sender1DepositLocked, "Sender1's withdrawal time has passed");
        require(sender2DepositLocked, "Sender2's withdrawal time has passed");
    }
}