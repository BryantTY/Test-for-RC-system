// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    //address public trustedMinter;

    constructor(uint256 initialSupply, address owner/*, address _trustedMinter*/) ERC20("My Token", "MYT") {
        require(owner != address(0), "Owner address cannot be the zero address");
        _mint(owner, initialSupply);
        //trustedMinter = _trustedMinter;
    }

    function mint(address to, uint256 amount) public {
        //require(msg.sender == trustedMinter, "Only trusted minter can mint tokens");
        _mint(to, amount);
    }
}

