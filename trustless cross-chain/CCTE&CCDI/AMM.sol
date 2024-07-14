pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleBalancerAMM {
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public poolTokenA;
    uint256 public poolTokenB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than 0");
        
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);
        
        poolTokenA += amountA;
        poolTokenB += amountB;
    }

    function getExchangeRate() external view returns (uint256) {
        require(poolTokenA > 0 && poolTokenB > 0, "Pool must have liquidity");

        return (poolTokenA * 1e18) / poolTokenB;
    }
}
