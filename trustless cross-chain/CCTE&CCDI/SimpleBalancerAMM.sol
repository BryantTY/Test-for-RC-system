// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleBalancerAMM {
    IERC20 public token1;
    IERC20 public token2;
    IERC20 public token3;
    
    uint256 public poolToken1;
    uint256 public poolToken2;
    uint256 public poolToken3;

    uint256 public weight1;
    uint256 public weight2;
    uint256 public weight3;

    constructor(
        address _token1,
        address _token2,
        address _token3,
        uint256 _weight1,
        uint256 _weight2,
        uint256 _weight3
    ) {
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
        token3 = IERC20(_token3);
        weight1 = _weight1;
        weight2 = _weight2;
        weight3 = _weight3;
        require(weight1 + weight2 + weight3 == 100, "The sum of the weights must be equal to 100");
    }

    event LogAddLiquidity(address indexed user, uint256 amount1, uint256 amount2, uint256 amount3);
    event LogTokenTransfer(address indexed user, address indexed token, uint256 amount);

    function addLiquidity(
        address from1,
        address from2,
        address from3,
        uint256 amount1,
        uint256 amount2,
        uint256 amount3
    ) external {
        require(amount1 > 0 && amount2 > 0 && amount3 > 0, "Amounts must be greater than 0");

        uint256 allowance1 = token1.allowance(from1, address(this));
        uint256 allowance2 = token2.allowance(from2, address(this));
        uint256 allowance3 = token3.allowance(from3, address(this));
        
        require(allowance1 >= amount1, "Token 1 allowance is not enough");
        require(allowance2 >= amount2, "Token 2 allowance is not enough");
        require(allowance3 >= amount3, "Token 3 allowance is not enough");
        
        bool success1 = token1.transferFrom(from1, address(this), amount1);
        bool success2 = token2.transferFrom(from2, address(this), amount2);
        bool success3 = token3.transferFrom(from3, address(this), amount3);

        require(success1, "Token 1 transfer failed");
        require(success2, "Token 2 transfer failed");
        require(success3, "Token 3 transfer failed");

        poolToken1 += amount1;
        poolToken2 += amount2;
        poolToken3 += amount3;
        
        emit LogAddLiquidity(msg.sender, amount1, amount2, amount3);
    }

    function getExchangeRate(address fromToken, address toToken) external view returns (uint256) {
        require(poolToken1 > 0 && poolToken2 > 0 && poolToken3 > 0, "Pool must have liquidity");

        uint256 fromWeight;
        uint256 fromBalance;
        uint256 toWeight;
        uint256 toBalance;

        if (fromToken == address(token1)) {
            fromWeight = weight1;
            fromBalance = poolToken1;
        } else if (fromToken == address(token2)) {
            fromWeight = weight2;
            fromBalance = poolToken2;
        } else if (fromToken == address(token3)) {
            fromWeight = weight3;
            fromBalance = poolToken3;
        } else {
            revert("Invalid fromToken");
        }

        if (toToken == address(token1)) {
            toWeight = weight1;
            toBalance = poolToken1;
        } else if (toToken == address(token2)) {
            toWeight = weight2;
            toBalance = poolToken2;
        } else if (toToken == address(token3)) {
            toWeight = weight3;
            toBalance = poolToken3;
        } else {
            revert("Invalid toToken");
        }

        uint256 rate = (fromBalance * toWeight * 1e18) / (fromWeight * toBalance);
        return rate;
    }
}