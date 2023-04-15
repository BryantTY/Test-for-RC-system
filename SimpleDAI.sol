// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./IPreBurnPreMint.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleDAI is IERC20, Ownable {
    string public constant name = "SimpleDAI";
    string public constant symbol = "sDAI";
    uint8 public constant decimals = 18;
    IPreBurnPreMint public preBurnPreMintContract;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint256 public constant COLLATERAL_RATIO = 150; // 150% collateral ratio

    event Mint(address indexed account, uint256 amount);
    event Burn(address indexed account, uint256 amount);

    function mintDAI(uint256 daiAmount) external payable {
        require(msg.value > 0, "Must provide collateral (ETH)");
        uint256 collateralRequired = (daiAmount * COLLATERAL_RATIO) / 100;
        require(msg.value >= collateralRequired, "Insufficient collateral");

        _mint(msg.sender, daiAmount);
        emit Mint(msg.sender, daiAmount);
    }

    function burnDAI(uint256 daiAmount) external {
        _burn(msg.sender, daiAmount);

        uint256 collateralToReturn = (daiAmount * address(this).balance) / _totalSupply;
        (bool success, ) = msg.sender.call{value: collateralToReturn}("");
        require(success, "Transfer of collateral failed");

        emit Burn(msg.sender, daiAmount);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] -= amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] -= amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

     function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }
    function mintWithoutCollateral(address to, uint256 amount) external {
        require(msg.sender == address(preBurnPreMintContract), "Only PreBurnPreMint contract can mint without collateral");
        _mint(to, amount);
    }
    // Add onlyOwner modifier to the setPreBurnPreMintContract function
    function setPreBurnPreMintContract(address _preBurnPreMint) external onlyOwner {
        require(_preBurnPreMint != address(0), "Invalid address");
        preBurnPreMintContract = IPreBurnPreMint(_preBurnPreMint);
    }
}
