// 1. License
// SPDX-License-Identifier: MIT

//2. Solidity version
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/FloToken.sol";
import "../src/FloStaking.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

//3. Contract

contract FloStakingTest is Test {
    FloToken floToken;
    FloStaking floStaking;
    //FloToken constructor parameters
    string name_ = "Flo Coin";
    string symbol_ = "FLO";
    //FloStaking constructor parameters
    address owner = vm.addr(1);
    address user1 = vm.addr(2);
    uint256 stakingPeriod = 30 days;
    uint256 fixedStakingAmount = 10 ether;
    uint256 rewardPerPeriod = 1 ether;

    function setUp() external {
        floToken = new FloToken(name_, symbol_);
        floStaking = new FloStaking(address(floToken), owner, stakingPeriod, fixedStakingAmount, rewardPerPeriod);
    }

    // Test contracts deployments

    function testDeployStakingContract() external view {
        assert(address(floStaking) != address(0));
    }

    function testDeployTokenContract() external view {
        assert(address(floToken) != address(0));
    }

    // Test change staking period

    function testChangeStakingPeriodNotOwner() external {
        uint256 newStakingPeriod_ = 1 days;
        vm.expectRevert();
        floStaking.changeStakingPeriod(newStakingPeriod_);
    }

    function testChangeStakingPeriodOwner() external {
        uint256 newStakingPeriod_ = 1 days;
        vm.startPrank(owner);
        uint256 stakingPeriodBefore = floStaking.stakingPeriod();
        floStaking.changeStakingPeriod(newStakingPeriod_);
        uint256 stakingPeriodAfter = floStaking.stakingPeriod();

        assert(stakingPeriodBefore != stakingPeriodAfter);
        assert(stakingPeriodAfter == newStakingPeriod_);
        vm.stopPrank();
    }

    // Test Fund
    function testFundContract() external {
        vm.startPrank(owner);
        vm.deal(owner, 1 ether);
        uint256 etherValue = 1 ether;
        uint256 balanceBefore = address(floStaking).balance;
        (bool success,) = address(floStaking).call{value: etherValue}("");
        uint256 balanceAfter = address(floStaking).balance;

        require(success, "Transaction failed");

        assert(balanceAfter - balanceBefore == etherValue);
        vm.stopPrank();
    }

    // Test Deposit

    function testIncorrectAmountDeposit() external {
        uint256 depositAmount_ = 1 ether;
        vm.startPrank(user1);
        vm.expectRevert();
        floStaking.deposit(depositAmount_);
        vm.stopPrank();
    }

    function testAmountDeposit() external {
        uint256 depositAmount_ = floStaking.fixedStakingAmount();
        vm.startPrank(user1);
        floToken.mint(depositAmount_);
        uint256 userBalanceBefore = floStaking.userBalance(user1);
        uint256 rewardTimeBefore = floStaking.rewardTime(user1);
        //Approve tx
        IERC20(floToken).approve(address(floStaking), depositAmount_);
        floStaking.deposit(depositAmount_);
        uint256 userBalanceAfter = floStaking.userBalance(user1);
        uint256 rewardTimeAfter = floStaking.rewardTime(user1);

        assert(userBalanceAfter - userBalanceBefore == depositAmount_);
        assert(rewardTimeBefore == 0);
        assert(rewardTimeAfter == block.timestamp);

        vm.stopPrank();
    }

    function testDepositExceeded() external {
        uint256 depositAmount_ = floStaking.fixedStakingAmount();
        vm.startPrank(user1);
        floToken.mint(depositAmount_);
        uint256 userBalanceBefore = floStaking.userBalance(user1);
        uint256 rewardTimeBefore = floStaking.rewardTime(user1);
        //Approve tx
        IERC20(floToken).approve(address(floStaking), depositAmount_);
        floStaking.deposit(depositAmount_);
        uint256 userBalanceAfter = floStaking.userBalance(user1);
        uint256 rewardTimeAfter = floStaking.rewardTime(user1);
        assert(userBalanceAfter - userBalanceBefore == depositAmount_);
        assert(rewardTimeBefore == 0);
        assert(rewardTimeAfter == block.timestamp);
        floToken.mint(depositAmount_);
        IERC20(floToken).approve(address(floStaking), depositAmount_);
        vm.expectRevert("Maximum deposit reached");
        floStaking.deposit(depositAmount_);

        vm.stopPrank();
    }

    // test withdraw

    function testWithdrawNoBalance() external {
        vm.startPrank(user1);
        vm.expectRevert("No amount to withdraw");
        floStaking.withdraw();
        vm.stopPrank();
    }

    function testWithdraw() external {
        uint256 depositAmount_ = floStaking.fixedStakingAmount();
        vm.startPrank(user1);
        floToken.mint(depositAmount_);
        uint256 userBalanceBefore = floStaking.userBalance(user1);
        uint256 rewardTimeBefore = floStaking.rewardTime(user1);
        //Approve tx
        IERC20(floToken).approve(address(floStaking), depositAmount_);
        floStaking.deposit(depositAmount_);
        uint256 userBalanceAfter = floStaking.userBalance(user1);
        uint256 rewardTimeAfter = floStaking.rewardTime(user1);

        assert(userBalanceAfter - userBalanceBefore == depositAmount_);
        assert(rewardTimeBefore == 0);
        assert(rewardTimeAfter == block.timestamp);

        uint256 userBalanceBeforeWithdraw = floStaking.userBalance(user1);
        uint256 userTokens = IERC20(floToken).balanceOf(user1);
        console.log(userBalanceBeforeWithdraw);
        console.log(userTokens);
        floStaking.withdraw();
        uint256 userBalanceAfterWithdraw = floStaking.userBalance(user1);
        uint256 userTokensAfterWithdraw = IERC20(floToken).balanceOf(user1);
        console.log(userBalanceAfterWithdraw);

        assert(userBalanceAfterWithdraw == 0);
        assert(userTokensAfterWithdraw == userTokens + userBalanceBeforeWithdraw);

        vm.stopPrank();
    }

    // Claim tests

    function testClaimWhenNotStaking() external {
        vm.startPrank(user1);
        vm.expectRevert("Balance is zero");
        floStaking.claimRewards();
        vm.stopPrank();
    }

    function testClaimStakingPeriod() external {
        uint256 depositAmount_ = floStaking.fixedStakingAmount();
        vm.startPrank(user1);
        floToken.mint(depositAmount_);
        uint256 userBalanceBefore = floStaking.userBalance(user1);
        uint256 rewardTimeBefore = floStaking.rewardTime(user1);
        //Approve tx
        IERC20(floToken).approve(address(floStaking), depositAmount_);
        floStaking.deposit(depositAmount_);
        uint256 userBalanceAfter = floStaking.userBalance(user1);
        uint256 rewardTimeAfter = floStaking.rewardTime(user1);

        assert(userBalanceAfter - userBalanceBefore == depositAmount_);
        assert(rewardTimeBefore == 0);
        assert(rewardTimeAfter == block.timestamp);
        vm.expectRevert("wait for staking period");
        floStaking.claimRewards();
        vm.stopPrank();
    }

    function testClaimNoBalance() external {
        uint256 depositAmount_ = floStaking.fixedStakingAmount();
        vm.startPrank(user1);
        floToken.mint(depositAmount_);
        uint256 userBalanceBefore = floStaking.userBalance(user1);
        uint256 rewardTimeBefore = floStaking.rewardTime(user1);
        //Approve tx
        IERC20(floToken).approve(address(floStaking), depositAmount_);
        floStaking.deposit(depositAmount_);
        uint256 userBalanceAfter = floStaking.userBalance(user1);
        uint256 rewardTimeAfter = floStaking.rewardTime(user1);

        assert(userBalanceAfter - userBalanceBefore == depositAmount_);
        assert(rewardTimeBefore == 0);
        assert(rewardTimeAfter == block.timestamp);
        vm.warp(block.timestamp + stakingPeriod);
        vm.expectRevert("Claim failed");
        floStaking.claimRewards();
        vm.stopPrank();
    }

    function testClaim() external {
        uint256 depositAmount_ = floStaking.fixedStakingAmount();
        vm.startPrank(user1);
        floToken.mint(depositAmount_);
        uint256 userBalanceBefore = floStaking.userBalance(user1);
        uint256 rewardTimeBefore = floStaking.rewardTime(user1);
        //Approve tx
        IERC20(floToken).approve(address(floStaking), depositAmount_);
        floStaking.deposit(depositAmount_);
        uint256 userBalanceAfter = floStaking.userBalance(user1);
        uint256 rewardTimeAfter = floStaking.rewardTime(user1);

        assert(userBalanceAfter - userBalanceBefore == depositAmount_);
        assert(rewardTimeBefore == 0);
        assert(rewardTimeAfter == block.timestamp);
        vm.stopPrank();
        vm.startPrank(owner);
        uint256 etherToFund = 100 ether;
        vm.deal(owner, etherToFund);
        (bool success,) = address(floStaking).call{value: etherToFund}("");
        require(success, "Fund failed");
        vm.stopPrank();
        vm.startPrank(user1);
        vm.warp(block.timestamp + stakingPeriod);
        uint256 userEtherBalanceBefore = address(user1).balance;
        floStaking.claimRewards();
        uint256 userEtherBalanceAfter = address(user1).balance;
        uint256 rewardTimeUser = floStaking.rewardTime(user1);
        assert(userEtherBalanceAfter - userEtherBalanceBefore == rewardPerPeriod);
        assert(rewardTimeUser == block.timestamp);
        vm.stopPrank();
    }

    function testMultipleClaims() public {
        uint256 depositAmount_ = floStaking.fixedStakingAmount();
        vm.startPrank(user1);
        floToken.mint(depositAmount_);
        IERC20(floToken).approve(address(floStaking), depositAmount_);
        floStaking.deposit(depositAmount_);
        vm.stopPrank();

        vm.startPrank(owner);
        vm.deal(owner, 100 ether);
        (bool success,) = address(floStaking).call{value: 100 ether}("");
        require(success, "Fund failed");
        vm.stopPrank();

        vm.startPrank(user1);
        vm.warp(block.timestamp + stakingPeriod);
        floStaking.claimRewards();
        uint256 balanceAfterFirstClaim = address(user1).balance;

        vm.warp(block.timestamp + stakingPeriod);
        floStaking.claimRewards();
        uint256 balanceAfterSecondClaim = address(user1).balance;

        assert(balanceAfterSecondClaim - balanceAfterFirstClaim == rewardPerPeriod);
        vm.stopPrank();
    }

    // Fuzz testing

    function testFuzzInvalidDeposit(uint256 amount_) public {
        vm.assume(amount_ != floStaking.fixedStakingAmount());
        vm.startPrank(user1);
        vm.expectRevert("Incorrect Amount");
        floStaking.deposit(amount_);
        vm.stopPrank();
    }
}
