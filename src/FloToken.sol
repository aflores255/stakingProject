// 1. License
// SPDX-License-Identifier: MIT

//2. Solidity version
pragma solidity 0.8.28;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
//3. Contract

contract FloToken is ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    //External function

    function mint(uint256 amount_) external {
        _mint(msg.sender, amount_);
    }
}
