pragma solidity ^0.8.0;

//import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./LockNFTBtM.sol";
import "./DpositforNFD.sol";

contract CheckingContract is Ownable {
    NFTLock public nftLock;
    Deposit public deposit;

    struct Check {
        //bytes32 root;
        address userAddress_i;
        address memberAddress_i;
        address userAddress_RC;
        address memberAddress_RC;
        uint256 nfdPrice_i;
        uint256 coinlockingTime;
    }

    mapping(bytes32 => Check) public checks;

    constructor(address _nftLockAddress, address _depositAddress) {
        nftLock = NFTLock(_nftLockAddress);
        deposit = Deposit(_depositAddress);
    }

    function checkAndRecord(
        //bytes32[] memory proof,
        //bytes32 leaf,
       //bytes32 root,
        address userAddress_i,
        address memberAddress_i,
        address userAddress_RC,
        address memberAddress_RC,
        uint256 nfdPrice_i,
        uint256 coinlockingTime
    ) external {
        // 1) Check Merkle proof
        //require(MerkleProof.verify(proof, root, leaf), "Invalid Merkle proof");

        // 2) Check nfdPrice_i
        //require(nfdPrice_i == 10 wei, "nfdPrice_i must be equal to 10 wei");

        // 3) Check deposits
        uint256 userDeposit = deposit.getDepositedCoinBalance(userAddress_RC, address(this));
        uint256 memberDeposit = deposit.getDepositedCoinBalance(memberAddress_RC, address(this));
        //require(userDeposit >= 10 wei && memberDeposit >= 10 wei, "Deposits must be larger than 10 wei");

        // 4) Check coinlockingTime
        uint256 userWithdrawalUnlockTime = deposit.getWithdrawalUnlockTime(userAddress_RC, address(this));
        uint256 memberWithdrawalUnlockTime = deposit.getWithdrawalUnlockTime(memberAddress_RC, address(this));
        uint256 nftLockTime = nftLock.lockBlockSeriesNumber() * 2;
        require(userWithdrawalUnlockTime >= nftLockTime && memberWithdrawalUnlockTime >= nftLockTime, "coinlockingTime must be later than 2 times of the NFT locking time");

        // 5) Record the inputs in the smart contract
        bytes32 checkId = keccak256(abi.encodePacked(/*proof, leaf, root, */userAddress_i, memberAddress_i, userAddress_RC, memberAddress_RC, nfdPrice_i, coinlockingTime));
        checks[checkId] = Check({
            //root: root,
            userAddress_i: userAddress_i,
            memberAddress_i: memberAddress_i,
            userAddress_RC: userAddress_RC,
            memberAddress_RC: memberAddress_RC,
            nfdPrice_i: nfdPrice_i,
            coinlockingTime: coinlockingTime
        });
    }
}
