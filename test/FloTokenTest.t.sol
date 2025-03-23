// 1. License
// SPDX-License-Identifier: MIT

//2. Solidity version
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/FloToken.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

//3. Contract

contract FloTokenTest is Test {
    FloToken floToken;
    string name_ = "Flo Coin";
    string symbol_ = "FLO";
    address user1 = vm.addr(1);

    function setUp() public {
        floToken = new FloToken(name_, symbol_);
    }

    // Unit tests

    function testMint() public {
        uint256 amount_ = 10 ether;
        vm.startPrank(user1);
        uint256 balanceBefore_ = IERC20(address(floToken)).balanceOf(user1);
        floToken.mint(amount_);
        uint256 balanceAfter_ = IERC20(address(floToken)).balanceOf(user1);
        assert(amount_ == balanceAfter_ - balanceBefore_);
        vm.stopPrank();
    }
}
