// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleDAI.sol";

contract SimpleAMM {
    SimpleDAI public daiContract;
    uint256 public constant k = 10000000000;

    uint256 public etherBalance;
    uint256 public daiBalance;

    mapping(address => uint256) public etherContributed;
    mapping(address => uint256) public daiContributed;

    event Swap(address indexed user, uint256 etherAmount, uint256 daiAmount);

    constructor(address _daiContract) {
        daiContract = SimpleDAI(_daiContract);
    }

    function addLiquidity(uint256 daiAmount) external payable {
        uint256 etherAmount = msg.value;
        uint256 calculatedDaiAmount = k / etherAmount;

        require(daiAmount == calculatedDaiAmount, "Invalid DAI amount for provided Ether amount");

        etherBalance += etherAmount;
        daiContract.transferFrom(msg.sender, address(this), daiAmount);
        daiBalance += daiAmount;

        // Update user's Ether and DAI contribution
        etherContributed[msg.sender] += etherAmount;
        daiContributed[msg.sender] += daiAmount;

        // No remaining Ether to return since it should follow x * y = k
    }

    function getExchangeRate() public view returns (uint256) {
        if (etherBalance == 0 || daiBalance == 0) {
            return 0;
        }
        return (etherBalance) / daiBalance;
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