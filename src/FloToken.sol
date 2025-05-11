// 1. License
// SPDX-License-Identifier: MIT

//2. Solidity version
pragma solidity 0.8.28;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
//3. Contract

contract FloToken is ERC20 {
    /**
     * @notice Constructor that initializes the ERC-20 token with a name and symbol
     * @param name_ The name of the token (e.g., "Flo Token")
     * @param symbol_ The token symbol (e.g., "FLO")
     */
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    /**
     * @notice Mints new tokens to the caller's address
     * @param amount_ The number of tokens to mint (denominated in the smallest unit)
     */
    function mint(uint256 amount_) external {
        _mint(msg.sender, amount_);
    }
}
