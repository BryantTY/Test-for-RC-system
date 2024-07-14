pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract SCMPV {
    using SafeERC20 for IERC20;

    mapping(bytes32 => bool) public storedMerkleProofs;
    address public sctContract;
    address public tokenDepositContract;

    uint256 public instructionsTimestamp;
    uint256 public deadline;

    bytes32[] public proofHashes;

    event MerkleProofVerified(bytes32 indexed leaf, bytes32 indexed root, bool indexed success);
    event Complete(string message);
    event ConfiscatedAndWithdrawn(address indexed from, address indexed to, uint256 amount);
    event DebugEvent(string message);

    constructor() {}

    function setSCTContract(address _sctContract) external {
        sctContract = _sctContract;
    }

    function setTokenDepositContract(address _tokenDepositContract) external {
        tokenDepositContract = _tokenDepositContract;
    }

    function setTimestamps() external {
        SCT sct = SCT(sctContract);
        instructionsTimestamp = sct.instructionsTimestamp();
        deadline = sct.deadline();
    }

    function verifyMerkleProof(
        bytes32[] memory proof,
        bytes32 leaf,
        bytes32 root
    ) public returns (bool) {
        require(block.number > instructionsTimestamp, "Proof received too early");
        require(block.number < deadline, "Proof received too late");

        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash < proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        bool success = computedHash == root;
        if (success) {
            storedMerkleProofs[computedHash] = true;
            proofHashes.push(computedHash);
            if (countStoredProofs() >= 2) {
                emit Complete("the CCTE process completes");
            }
        }
        emit MerkleProofVerified(leaf, root, success);
        return success;
    }


    function triggerFallback() external {
        require(block.number > deadline, "Deadline not reached yet");
        require(countStoredProofs() < 2, "Two proofs already stored");

        emit DebugEvent("Entered triggerFallback");

        SCT sct = SCT(sctContract);
        address sender1 = sct.sctSender1();
        address sender2 = sct.sctSender2();

        emit DebugEvent("Fetched senders from SCT");

        SCT.Instruction memory instruction1 = sct.instructions(sender1);
        SCT.Instruction memory instruction2 = sct.instructions(sender2);

        require(instruction1.sender != address(0), "Invalid sender1 address");
        require(instruction2.sender != address(0), "Invalid sender2 address");

        emit DebugEvent("Fetched instructions from SCT");

        if (!storedMerkleProofs[instruction1.proofHash]) {
            confiscateAndWithdraw(instruction1.sender, instruction2.sender, instruction1.depositId, instruction1.token);
        }
        if (!storedMerkleProofs[instruction2.proofHash]) {
            confiscateAndWithdraw(instruction2.sender, instruction1.sender, instruction2.depositId, instruction2.token);
        }

        emit DebugEvent("Completed triggerFallback execution");
    }

    function confiscateAndWithdraw(
        address from,
        address to,
        bytes32 depositId,
        address token
    ) internal {
        TokenDeposit tokenDeposit = TokenDeposit(tokenDepositContract);
        tokenDeposit.confiscateAndWithdraw(depositId, token, to);
        emit ConfiscatedAndWithdrawn(from, to, 0); // Amount should be fetched from TokenDeposit contract
    }

    function countStoredProofs() internal view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < proofHashes.length; i++) {
            if (storedMerkleProofs[proofHashes[i]]) {
                count++;
            }
        }
        return count;
    }
}

interface SCT {
    function instructions(address user) external view returns (Instruction memory);
    function instructionsTimestamp() external view returns (uint256);
    function deadline() external view returns (uint256);
    function sctSender1() external view returns (address);
    function sctSender2() external view returns (address);

    struct Instruction {
        address sender;
        address receiver;
        uint256 transferAmount;
        address location;
        bytes32 proofHash;
        bytes32 depositId;
        address token;
    }
}

interface TokenDeposit {
    function confiscateAndWithdraw(bytes32 depositId, address token, address to) external;
}