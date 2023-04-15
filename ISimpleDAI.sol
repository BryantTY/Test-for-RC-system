// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ISimpleDAI is IERC20 {
function mintWithoutCollateral(address to, uint256 amount) external;
function setPreBurnPreMintContract(address _preBurnPreMint) external;
}