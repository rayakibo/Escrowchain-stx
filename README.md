EscrowChain-STX Smart Contract

**EscrowChain-STX** is a secure on-chain escrow system built on the **Stacks blockchain** to facilitate **trustless STX transactions** between two parties.  
It ensures that funds are only released when agreed conditions are met, reducing fraud and increasing trust in decentralized payments.

---

Features

- **Trustless Escrow:** Funds are locked until both parties fulfill their obligations.  
- **Two-Party Confirmation:** Both buyer and seller must approve before funds are released.  
- **Dispute Resolution:** Optional admin/DAO mechanism for conflict resolution.  
- **Automatic Refunds:** Refunds triggered when terms or deadlines are not met.  
- **On-Chain Transparency:** Every transaction is recorded and auditable on the blockchain.

---

Smart Contract Overview

- **Contract Name:** `escrowchain-stx.clar`  
- **Language:** [Clarity](https://docs.stacks.co/write-smart-contracts/clarity-overview)  
- **Framework:** [Clarinet](https://docs.hiro.so/clarinet/clarinet)  
- **Network:** Stacks Testnet/Mainnet Compatible  

---

How It Works

1. **Initialize Escrow:**  
   Buyer and seller agree to terms, and buyer deposits STX into the escrow contract.  
2. **Hold Period:**  
   Funds remain locked in escrow while both parties perform their obligations.  
3. **Release or Refund:**  
   - If both parties confirm fulfillment → funds are released to the seller.  
   - If conditions fail or time expires → funds are refunded to the buyer.  

---

Functions Overview

| Function | Description |
|-----------|-------------|
| `create-escrow` | Initializes a new escrow agreement between buyer and seller. |
| `confirm-delivery` | Allows both parties to confirm transaction completion. |
| `release-funds` | Transfers escrowed STX to the seller upon mutual confirmation. |
| `refund-buyer` | Returns funds to the buyer if the deal is not fulfilled. |
| `get-escrow-details` | Retrieves escrow data for transparency and tracking. |

---

Testing the Contract

1. Install **Clarinet**:  
   ```bash
   npm install -g @hirosystems/clarinet
