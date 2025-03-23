// 1. License
// SPDX-License-Identifier: MIT

//2. Solidity version
pragma solidity 0.8.28;

//3. Contract

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract FloStaking is Ownable {
    // Variable definitions
    address public floToken;
    uint256 public stakingPeriod;
    uint256 public rewardPerPeriod;
    uint256 public fixedStakingAmount;
    mapping(address => uint256) public userBalance;
    mapping(address => uint256) public rewardTime;

    //Events
    event ChangeStakingPeriod(uint256 newStakingPeriod_);
    event Deposit(address userAddress_, uint256 amount_);
    event Withdraw(address userAddress_, uint256 amount_);
    event ClaimRewards(address userAdress_, uint256 amount_);
    event EtherSent(uint256 amount_);
    //Constructor

    constructor(
        address floToken_,
        address owner_,
        uint256 stakingPeriod_,
        uint256 fixedStakingAmount_,
        uint256 rewardPerPeriod_
    ) Ownable(owner_) {
        floToken = floToken_;
        stakingPeriod = stakingPeriod_;
        fixedStakingAmount = fixedStakingAmount_;
        rewardPerPeriod = rewardPerPeriod_;
    }

    //Functions
    // Deposit FloToken

    function deposit(uint256 tokenAmount_) external {
        require(tokenAmount_ == fixedStakingAmount, "Incorrect Amount");
        require(userBalance[msg.sender] == 0, "Maximum deposit reached");
        userBalance[msg.sender] += tokenAmount_;
        rewardTime[msg.sender] = block.timestamp;

        IERC20(floToken).transferFrom(msg.sender, address(this), tokenAmount_);

        emit Deposit(msg.sender, tokenAmount_);
    }
    // Withdraw FloToken

    function withdraw() external {
        uint256 userBalance_ = userBalance[msg.sender];
        require(userBalance[msg.sender] > 0, "No amount to withdraw");
        userBalance[msg.sender] = 0;
        IERC20(floToken).transfer(msg.sender, userBalance_);

        emit Withdraw(msg.sender, userBalance_);
    }

    // Claim rewards

    function claimRewards() external {
        require(userBalance[msg.sender] == fixedStakingAmount, "Balance is zero");
        uint256 elapsePeriod = block.timestamp - rewardTime[msg.sender];
        require(elapsePeriod >= stakingPeriod, "wait for staking period");

        rewardTime[msg.sender] = block.timestamp;

        (bool success,) = msg.sender.call{value: rewardPerPeriod}("");
        require(success, "Claim failed");
        emit ClaimRewards(msg.sender, rewardPerPeriod);
    }

    // Feed Contract

    receive() external payable onlyOwner {
        emit EtherSent(msg.value);
    }

    // Change staking period
    function changeStakingPeriod(uint256 newStakingPeriod_) external onlyOwner {
        stakingPeriod = newStakingPeriod_;
    }
}
