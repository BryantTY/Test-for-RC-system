pragma solidity ^0.8.0;

contract SimpleDAI {
    mapping(address => uint256) public daiBalance;
    mapping(address => uint256) public collateralBalance;
    uint256 public constant COLLATERAL_RATIO = 150; // 150% collateral ratio

    function mintDAI(uint256 daiAmount) external payable {
        require(msg.value > 0, "Must provide collateral (ETH)");
        uint256 collateralRequired = (daiAmount * COLLATERAL_RATIO) / 100;
        require(msg.value >= collateralRequired, "Insufficient collateral");

                                                                     
    }

    function burnDAI(uint256 daiAmount) external {
        require(daiBalance[msg.sender] >= daiAmount, "Insufficient DAI balance");

        uint256 collateralToReturn = (daiAmount * collateralBalance[msg.sender]) / daiBalance[msg.sender];
        daiBalance[msg.sender] -= daiAmount;
        collateralBalance[msg.sender] -= collateralToReturn;

        (bool success, ) = msg.sender.call{value: collateralToReturn}("");
        require(success, "Transfer of collateral failed");
    }
}

/*pragma solidity ^0.8.0;

contract Caller {
    function callAnotherContract(address targetContract, bytes memory data) public payable returns (bool success, bytes memory returnData) {
        (success, returnData) = targetContract.call{value: msg.value}(data);
    }
}*/

