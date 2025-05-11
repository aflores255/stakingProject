# 🌟 Flo Staking – A Smart Contract for Token Staking and Rewards


## 📌 **Description**
The **Flo Staking** smart contract offers a simple yet powerful way to incentivize long-term token holding and reward user loyalty in a decentralized environment. By staking **FLO Tokens**, users can earn passive rewards based on predefined timeframes and conditions, promoting healthy tokenomics and user engagement. 

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

### 🏗️ Constructor

| **Component** | **Description** |
|---------------|-----------------|
| `constructor(address floToken_, address owner_, uint256 stakingPeriod_, uint256 fixedStakingAmount_, uint256 rewardPerPeriod_)` | Initializes the staking contract by setting the ERC-20 token to be staked (`floToken_`), transferring ownership to the provided `owner_`, and configuring the staking logic. This includes defining the staking period duration, the fixed amount required for staking, and the reward per period. The contract uses OpenZeppelin's `Ownable` to restrict administrative functions to the owner. |

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

## ⚙️ How It Works

The Flo Staking system is composed of modular smart contracts designed for security, clarity, and scalability. Below is a breakdown of the core contracts and how they interact:

### 1. 🧠 [`FloStaking.sol`](https://github.com/aflores255/stakingProject/blob/master/src/FloStaking.sol)
This is the **main staking contract**. It allows users to stake a fixed amount of FLO tokens and earn rewards over a specified period.

It also enforces:
- A fixed staking amount.
- A minimum staking period (`stakingPeriod`).
- A fixed reward per staking period (`rewardPerPeriod`).

### 2. 💰 [`FloToken.sol`](https://github.com/aflores255/stakingProject/blob/master/src/FloToken.sol)
An **ERC-20 compatible token** contract representing the native token of the platform: `FLO`. This is the token that users must hold and stake in order to participate in the staking program.
- Fully compliant with the ERC-20 standard.
- Can be minted and distributed as needed during deployment or testing.

### 🔁 Contract Interaction

1. Users interact with the **`FloStaking`** contract by calling `deposit()` and transferring their **`FLOToken`**.
2. The **staking contract** holds the tokens for the duration specified.
3. After the staking period ends, users can call `claimRewards()` to receive their reward tokens.
4. Users may withdraw their staked tokens using `withdraw()`.

### 🔐 Access Control
The contract uses **OpenZeppelin’s `Ownable`** module to restrict administrative tasks (like adjusting reward values) to the contract owner.

---

## 🧪 **Testing with Foundry**
The contract has been tested using **Foundry**. The **FloStakingTest.t.sol** file contains unit and fuzz tests to verify the contract's core functionalities.

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

The **FloTokenTest.t.sol** file contains unit tests to verify the token contract's core functionalities.

### ✅ **Implemented Tests**
| **Test** | **Description** |
|-----------|----------------|
| **`testMint`** | Ensures the ERC-20 tokens are minted properly |

---

### 🧪 How to Run Tests

To run the test suite with Foundry:

```bash
forge test
```

### 📊 Coverage Report

| File                    | % Lines         | % Statements     | % Branches      | % Functions     |
|-------------------------|------------------|-------------------|------------------|------------------|
| `src/FloStaking.sol` | 100.00% (30/30) | 100.00% (26/26) | 100.00% (12/12) | 100.00% (6/6)   |
| `src/FloToken.sol` | 100.00% (2/2) | 100.00% (1/1) | 100.00% (0/0) | 100.00% (1/1)   |


---

## 📝 **License**
This project is licensed under the **MIT License**.
