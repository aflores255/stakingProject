# 🌟 Flo Staking Smart Contract

## 📌 **Description**
The **Flo Staking** smart contract allows users to stake **Flo Tokens (FLO)** to earn rewards over time. Users can deposit a fixed amount of tokens, claim rewards after the staking period, and withdraw their tokens when desired. 

This contract was developed and tested using **Foundry**, ensuring security and efficiency in staking operations.

---

## 🚀 **Features**
| **Feature** | **Description** |
|------------|---------------|
| 💰 **Deposit** | Users can stake a fixed amount of Flo Tokens. |
| 💸 **Withdraw** | Users can withdraw their staked tokens at any time. |
| 🎁 **Claim Rewards** | Users can claim rewards in Ether after the staking period. |
| ⏳ **Fixed Staking Period** | Users must wait a set duration before claiming rewards. |
| 🔒 **Admin Controls** | The owner can update the staking period and manage funds. |

---

## 📝 **Contract Details**

### 🔑 **Modifiers**
| **Modifier** | **Description** |
|-------------|----------------|
| **`onlyOwner`** | Restricts access to contract management functions. |

### 💽 **Events**
| **Event** | **Description** |
|-----------|----------------|
| **`ChangeStakingPeriod`** | Emitted when the owner updates the staking period. |
| **`Deposit`** | Emitted when a user stakes tokens. |
| **`Withdraw`** | Emitted when a user withdraws tokens. |
| **`ClaimRewards`** | Emitted when a user claims rewards. |
| **`EtherSent`** | Emitted when the contract receives Ether. |

### 🔧 **Contract Functions**

| **Function** | **Description** |
|------------|----------------|
| **`deposit(uint256 amount)`** | Users stake a fixed amount of Flo Tokens. |
| **`withdraw()`** | Allows users to withdraw their staked tokens. |
| **`claimRewards()`** | Users claim earned rewards in Ether after the staking period. |
| **`changeStakingPeriod(uint256 newPeriod)`** | Admin function to modify the staking duration. |
| **`receive()`** | Allows the owner to fund the contract with Ether. |

---

## 🧪 **Testing with Foundry**
The contract has been tested using **Foundry**. The **FloStakingTest.t.sol** file contains unit tests to verify the contract's core functionalities.

### ✅ **Implemented Tests**
| **Test** | **Description** |
|-----------|----------------|
| **`testDeployStakingContract`** | Ensures the contract deploys correctly. |
| **`testDeposit`** | Checks that users can stake tokens. |
| **`testDepositExceeded`** | Ensures users cannot stake more than allowed. |
| **`testWithdrawNoBalance`** | Prevents withdrawals if no tokens are staked. |
| **`testWithdraw`** | Tests successful withdrawal of staked tokens. |
| **`testClaimWhenNotStaking`** | Prevents reward claims if no tokens are staked. |
| **`testClaimStakingPeriod`** | Ensures rewards can only be claimed after the staking period. |
| **`testClaimNoBalance`** | Prevents reward claims if the contract lacks funds. |
| **`testClaim`** | Verifies successful reward claims after the staking period. |
| **`testMultipleClaims`** | Ensures users can claim multiple rewards over time. |
| **`testFuzzInvalidDeposit(uint256 amount_)`** | Uses fuzz testing to check invalid deposits. |

---

## 📄 **Requirements**
- Solidity `^0.8.28`
- Foundry for testing (`forge`)
- OpenZeppelin Contracts for ERC-20 token standards

---

## 💽 **Installation & Testing**
1. Clone the repository:
   ```sh
   git clone https://github.com/aflores255/stakingProject
   cd flo-staking
   ```
2. Install dependencies:
   ```sh
   forge install
   ```
3. Run tests:
   ```sh
   forge test
   ```

---

## 🔒 **Security Considerations**
- The contract ensures that users can only stake a fixed amount per deposit.
- Reward claims are only allowed after the staking period.
- The contract must have enough Ether funds for rewards to be claimable.

---

## 🤝 **Contributing**
Feel free to submit issues or pull requests to improve the Flo Staking contract.

---

## 📝 **License**
This project is licensed under the **MIT License**.

---

🎉 **Happy Staking!** 🚀