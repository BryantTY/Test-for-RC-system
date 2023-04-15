// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleDAI.sol";
import "./metazerocoin.sol";

contract SimpleAMM1 {
    SimpleDAI public daiContract;
    MyToken public metazeroContract;
    uint256 public constant k = 10000;

    uint256 public MTZBalance;
    uint256 public daiBalance;

    mapping(address => uint256) public MTZContributed;
    mapping(address => uint256) public daiContributed;

    event Swap(address indexed user, uint256 MTZAmount, uint256 daiAmount);

    constructor(address _daiContract, address _metazeroContract) {
        daiContract = SimpleDAI(_daiContract);
        metazeroContract = MyToken(_metazeroContract);
    }

    function addLiquidity(uint256 daiAmount, uint256 MTZAmount) external {
        uint256 calculatedDaiAmount = k / MTZAmount;

        require(daiAmount == calculatedDaiAmount, "Invalid DAI amount for provided MTZ amount");

        MTZBalance += MTZAmount;
        daiContract.transferFrom(msg.sender, address(this), daiAmount);
        daiBalance += daiAmount;

        // Transfer the MTZ tokens from the user to the contract
        metazeroContract.transferFrom(msg.sender, address(this), MTZAmount);

        // Update user's MTZ and DAI contribution
        MTZContributed[msg.sender] += MTZAmount;
        daiContributed[msg.sender] += daiAmount;

        // No remaining MTZ to return since it should follow x * y = k
    }

    function getExchangeRate() public view returns (uint256) {
        if (MTZBalance == 0 || daiBalance == 0) {
            return 0;
        }
        return (MTZBalance) / daiBalance;
    }

    /*function swapEtherToDai() external payable {
        require(msg.value > 0, "Must provide Ether");

        uint256 etherAmount = msg.value;
        uint256 daiAmount =  etherAmount / getExchangeRate();

        require(daiBalance >= daiAmount, "Not enough DAI in the pool");

        etherBalance += etherAmount;
        daiBalance -= daiAmount;

        daiContract.transfer(msg.sender, daiAmount);

        emit Swap(msg.sender, etherAmount, daiAmount);
    }

    function swapDaiToEther(uint256 daiAmount) external {
        require(daiAmount > 0, "Must provide DAI");

        uint256 etherAmount = daiAmount * getExchangeRate();

        require(etherBalance >= etherAmount, "Not enough Ether in the pool");

        etherBalance -= etherAmount;
        daiBalance += daiAmount;

        daiContract.transferFrom(msg.sender, address(this), daiAmount);
        payable(msg.sender).transfer(etherAmount);

        emit Swap(msg.sender, etherAmount, daiAmount);
    }*/
}