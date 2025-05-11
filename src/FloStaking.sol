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

    /**
     * @notice Initializes the staking contract with parameters and ownership
     * @param floToken_ Address of the FLO token contract
     * @param owner_ Address to be set as the owner of the contract
     * @param stakingPeriod_ Duration (in seconds) for which tokens must be staked
     * @param fixedStakingAmount_ Fixed amount of tokens each user must stake
     * @param rewardPerPeriod_ ETH amount to be rewarded per staking period
     */
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

    /**
     * @notice Allows a user to deposit a fixed amount of FLO tokens into the staking contract
     * @param tokenAmount_ The amount of FLO tokens to deposit (must equal fixedStakingAmount)
     */
    function deposit(uint256 tokenAmount_) external {
        require(tokenAmount_ == fixedStakingAmount, "Incorrect Amount");
        require(userBalance[msg.sender] == 0, "Maximum deposit reached");
        userBalance[msg.sender] += tokenAmount_;
        rewardTime[msg.sender] = block.timestamp;

        IERC20(floToken).transferFrom(msg.sender, address(this), tokenAmount_);

        emit Deposit(msg.sender, tokenAmount_);
    }

    /**
     * @notice Allows a user to withdraw their staked FLO tokens
     */
    function withdraw() external {
        uint256 userBalance_ = userBalance[msg.sender];
        require(userBalance[msg.sender] > 0, "No amount to withdraw");
        userBalance[msg.sender] = 0;
        IERC20(floToken).transfer(msg.sender, userBalance_);

        emit Withdraw(msg.sender, userBalance_);
    }

    /**
     * @notice Allows a user to claim their ETH rewards after the staking period
     */
    function claimRewards() external {
        require(userBalance[msg.sender] == fixedStakingAmount, "Balance is zero");
        uint256 elapsePeriod = block.timestamp - rewardTime[msg.sender];
        require(elapsePeriod >= stakingPeriod, "wait for staking period");

        rewardTime[msg.sender] = block.timestamp;

        (bool success,) = msg.sender.call{value: rewardPerPeriod}("");
        require(success, "Claim failed");
        emit ClaimRewards(msg.sender, rewardPerPeriod);
    }

    /**
     * @notice Allows the contract to receive ETH to fund future rewards
     */
    receive() external payable onlyOwner {
        emit EtherSent(msg.value);
    }

    /**
     * @notice Allows the contract owner to change the staking period
     * @param newStakingPeriod_ New staking duration in seconds
     */
    function changeStakingPeriod(uint256 newStakingPeriod_) external onlyOwner {
        stakingPeriod = newStakingPeriod_;
    }
}
