// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPreBurnPreMint {
function preBurn(uint256 tokenId, uint256 unlockBlock, address to) external;
}